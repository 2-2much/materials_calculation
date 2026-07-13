#!/usr/bin/env python3
"""
MEMORY.md 인덱스를 해당 폴더의 개별 메모리 .md 파일들로부터 재구성(reconcile).

멀티서버 동기화에서 MEMORY.md(단일 공유 파일)가 오래된 버전으로 덮어써지는 문제를
방지한다. 개별 .md 파일(별도 파일이라 충돌 없이 머지됨)이 진실源이며, 이 스크립트가
매 sync마다 인덱스를 그에 맞춰 맞춘다:
  - 존재하는 .md 중 인덱스에 없는 것 -> 타입별 섹션에 자동 추가
  - 인덱스에 있는데 파일이 사라진 것 -> 해당 줄 제거
  - 기존에 손으로 다듬어 둔 줄은 그대로 보존(멱등)

Usage: gen-memory-index.py <memory_dir>
"""
import os, re, sys, glob

# metadata.type -> (섹션 매칭 키워드(우선순위 순), 없을 때 만들 기본 섹션 제목)
TYPE_SECTION = {
    "user":      (["유저", "user"],                  "## 유저 정보"),
    "feedback":  (["피드백", "feedback", "작업"],     "## 작업 방식 / 피드백"),
    "project":   (["연구", "project", "프로젝트", "인프라"], "## 연구 / 프로젝트"),
    "reference": (["참고", "reference", "자료"],       "## 참고 자료"),
    "_default":  ([],                                 "## 기타"),
}
LINK_RE = re.compile(r"\]\(\s*([^)]+\.md)\s*\)")


def parse_front(path):
    """아주 단순한 frontmatter 파서: name, description, metadata.type 추출."""
    name = os.path.splitext(os.path.basename(path))[0]
    desc, mtype = "", "_default"
    try:
        lines = open(path, encoding="utf-8").read().splitlines()
    except Exception:
        return name, desc, mtype
    if not lines or lines[0].strip() != "---":
        return name, desc, mtype
    in_meta = False
    for l in lines[1:]:
        if l.strip() == "---":
            break
        m = re.match(r"^(\w[\w-]*):\s*(.*)$", l)
        if l.startswith(("  ", "\t")):
            mm = re.match(r"^\s+type:\s*(.*)$", l)
            if in_meta and mm:
                mtype = mm.group(1).strip().strip('"').strip("'").split()[0] or "_default"
            continue
        in_meta = False
        if not m:
            continue
        key, val = m.group(1), m.group(2).strip().strip('"').strip("'")
        if key == "name" and val:
            name = val
        elif key == "description" and val:
            desc = val
        elif key == "metadata":
            in_meta = True
    if mtype not in TYPE_SECTION:
        mtype = "_default"
    return name, desc, mtype


def pretty(slug):
    for p in ("project_", "user_", "feedback_", "reference_", "ref_"):
        if slug.startswith(p):
            slug = slug[len(p):]
            break
    return slug.replace("-", " ").replace("_", " ").strip()


def find_section(lines, keywords):
    """키워드 우선순위 순으로 매칭되는 첫 '## ' 헤더의 인덱스."""
    for k in keywords:
        for i, l in enumerate(lines):
            if l.startswith("## ") and k.lower() in l.lower():
                return i
    return None


def insert_point(lines, hdr_idx):
    """섹션 헤더 다음, 다음 '## ' 헤더 직전(뒤쪽 빈 줄 제외) 위치."""
    j = hdr_idx + 1
    end = len(lines)
    while j < len(lines):
        if lines[j].startswith("## "):
            end = j
            break
        j += 1
    k = end
    while k - 1 > hdr_idx and lines[k - 1].strip() == "":
        k -= 1
    return k


def reconcile(memdir):
    idx = os.path.join(memdir, "MEMORY.md")
    files = sorted(
        os.path.basename(f) for f in glob.glob(os.path.join(memdir, "*.md"))
        if os.path.basename(f) != "MEMORY.md"
    )
    actual = set(files)

    lines = []
    if os.path.exists(idx):
        lines = open(idx, encoding="utf-8").read().splitlines()

    # 1) 사라진 파일을 가리키는 줄 제거 + 중복 항목 제거(union 머지 대비)
    kept, referenced = [], set()
    for l in lines:
        links = [os.path.basename(x) for x in LINK_RE.findall(l)]
        if links:
            if all(x not in actual for x in links):
                continue  # stale entry -> drop
            if any(x in referenced for x in links):
                continue  # 이미 인덱싱된 파일의 중복 줄 -> drop
            referenced.update(links)
        kept.append(l)
    lines = kept

    # 2) 빠진 파일을 타입별 섹션에 추가
    missing = [f for f in files if f not in referenced]
    for f in missing:
        name, desc, mtype = parse_front(os.path.join(memdir, f))
        title = pretty(name) or pretty(os.path.splitext(f)[0])
        hook = (" — " + desc) if desc else ""
        entry = f"- [{title}]({f}){hook}"
        keywords, default_hdr = TYPE_SECTION[mtype]
        hdr = find_section(lines, keywords) if keywords else None
        if hdr is None:
            if lines and lines[-1].strip() != "":
                lines.append("")
            lines.append(default_hdr)
            lines.append(entry)
        else:
            lines.insert(insert_point(lines, hdr), entry)

    out = "\n".join(lines).rstrip("\n") + "\n"
    if not os.path.exists(idx) or open(idx, encoding="utf-8").read() != out:
        open(idx, "w", encoding="utf-8").write(out)
        print(f"[reconciled] {idx}  (+{len(missing)} added)")
    return len(missing)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("usage: gen-memory-index.py <memory_dir>")
    reconcile(sys.argv[1])
