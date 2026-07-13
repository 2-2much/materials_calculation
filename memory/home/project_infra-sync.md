---
name: infra-sync
description: "서버(kohn/sham/bloch/tgm-master) 간 프로젝트 구조, Git 동기화 전략, Claude Code 설정 공유 범위 종합"
metadata: 
  node_type: memory
  type: project
  originSessionId: 8eb65f43-70c9-449a-95ce-27d3f33a4b7b
---

## 프로젝트 분리

```
~/materials/                ← Git repo (VASP DFT 계산, 대용량)
  CLAUDE.md
  .gitignore
  .claude/commands/         ← 커스텀 skills (Git 공유)
  .claude/agents/           ← 커스텀 sub-agents (Git 공유)
  .claude/settings.json     ← 프로젝트 권한 (Git 공유)
  .claude/settings.local.json ← 로컬 전용 (.gitignore)
  InAs/ GaAs/ reproduce/

~/papers/                   ← 별도 Git repo (논문 읽기/정리, 가벼움)
  CLAUDE.md
  InAs/ GaAs/
```

**Why:** materials는 VASP 대용량, papers는 텍스트 중심. 논문이 여러 물질에 걸칠 수 있어 분리가 깔끔함.

## 동기화 전략

```
GitHub ↕ kohn / sham / bloch / tgm-master (materials + papers)
GitHub ↕ 로컬 PC (papers만 clone)
```

- sham/bloch에는 이미 materials/가 존재 → git clone 불가, git init + remote add로 연결
- reproduce 계산은 `~/materials/{물질명}/reproduce/`에 배치
- papers의 CLAUDE.md에서 reproduce 경로 참조

## Claude Code 설정 공유 범위

| 파일 | Git 공유 | 비고 |
|---|---|---|
| CLAUDE.md | 가능 | 프로젝트 지침, insights 반영 |
| .claude/commands/ | 가능 | DFT 커스텀 skills |
| .claude/agents/ | 가능 | DFT 커스텀 sub-agents |
| .claude/settings.json | 가능 | 프로젝트 권한 |
| .claude/settings.local.json | 불가 | .gitignore 대상 |
| ~/.claude/ (홈) | 별도 관리 | 메모리, 글로벌 설정 — 서버별 개별 설정 |

개인 선호도(언어 등)는 각 서버의 `~/.claude/CLAUDE.md`에 별도 설정.

## 현재 진행 상태 (2026-06-22)

- GitHub repo: `2-2much/materials_calculation` (push 완료)
- kohn: git init 완료, push 완료
- tgm-master: materials git 연결 완료, 메모리 동기화 작동 중
- sham/bloch: 아직 git 미연결 — 각 서버에서 아래 순서로 설정 필요:
  ```
  cd ~/materials
  git init
  git remote add origin https://github.com/2-2much/materials_calculation.git
  gh auth login   # 최초 1회
  git fetch origin
  git checkout main
  ```
- .claude/settings.json: 서버 공통 권한만 포함, 로컬 전용은 settings.local.json으로 분리

## papers 메모리 동기화 (2026-06-22 추가)

- papers(`~/papers/` → `/mnt/hohenberg/.../papers/`)의 `.claude/settings.json`은 hohenberg를 통해 서버 간 공유됨
- 하지만 Claude 프로젝트 메모리(`~/.claude/projects/.../memory/`)는 서버별 로컬
- `sync-memory.sh`의 `is_syncable_project()` 필터에 papers slug(`-mnt-hohenberg-*-papers*`) 추가하여 해결
- `~/materials/memory/papers/.source`에 매핑 저장

## MEMORY.md 인덱스 자동 재구성 (2026-07-13 추가)

**문제:** 개별 메모리 `.md`는 별도 파일이라 충돌 없이 머지되지만, `MEMORY.md`(단일 공유 인덱스)는 여러 서버가 동시 편집 → 오래된 버전이 push→pull로 계속 덮어써 항목이 사라짐. (repo `memory/home/`엔 파일 9개 다 있는데 MEMORY.md만 옛 4개짜리인 상태로 확인됨.)

**해결 (2중 안전망):**
1. `~/materials/.claude/gen-memory-index.py <memdir>` — MEMORY.md를 실제 존재하는 `.md`들의 frontmatter(name/description/metadata.type)로 reconcile: 빠진 파일 자동 추가, 사라진 파일 줄 제거, 중복 제거. 멱등. 기존 큐레이션 줄은 보존. `sync-memory.sh`의 pull(내려받은 뒤)·push(올리기 전) 양쪽에서 `reconcile_index()` 호출.
2. `.gitattributes`에 `memory/*/MEMORY.md merge=union` — rebase 충돌 시 양쪽 줄을 합쳐 abort 방지(다음 reconcile이 중복 정리). `.gitignore` 화이트리스트에 `!.gitattributes` 추가해야 추적됨(안 하면 무시됨).

→ 오래된 MEMORY.md가 덮어써도 다음 sync에서 개별 파일 기준으로 완전 복구됨. 즉 **MEMORY.md는 이제 파생 인덱스**이며 개별 `.md`가 진실源.
