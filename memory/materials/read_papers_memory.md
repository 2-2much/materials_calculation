---
name: read_papers_memory
description: (범용 다리) materials 세션에서 논문/문헌 근거가 필요할 때 papers 프로젝트의 논문 분석 노트를 읽는 법. 특정 주제 전용이 아니라 paper_notes 전체 진입점.
metadata:
  type: reference
---

**materials 세션에서 논문·문헌 근거가 필요하면** papers 프로젝트의 논문 분석 노트를 참조한다.
(materials 세션은 papers CLAUDE.md를 로드하지 않으므로, 이 메모리가 유일한 다리 역할.)

## 접근 경로 (hohenberg, 모든 master 노드에서 읽기 가능)
- **인덱스 먼저**: `~/papers/memory/paper_notes/README.md` — 주제별 .md 파일 목록.
- 그 다음 **작업과 관련된 주제의 .md만** 열어 읽는다. (paper_notes에는 InAs QD 외에도
  VASP, defect total energy correction 등 여러 주제가 계속 추가되므로, **매번 전부 통독하지 말 것**.)
- 실제 경로: `~/papers` = `/mnt/hohenberg/byname/정재관/papers` (심볼릭). 계산 노드에선 hohenberg 접근 불가 주의.

## 주의 — 동기화본과 다름
- `~/materials/memory/papers/`(materials repo 동기화본)에는 papers **auto-memory만** 있고 **paper_notes는 없다.**
- 논문 분석 전문(paper_notes)은 papers git repo(2-2much/papers) 소속 → hohenberg 경로로만 닿는다.

## 현재 주제 예시 (인덱스에서 확인)
- n-type InAs QD intrinsic n-type 기원 → `n-type_InAs_QDs.md` (이 DFT 목표 [[cqd_ntype_origin_goal]]의 문헌 근거)
- (이후 VASP, defect correction 등 추가 예정)
