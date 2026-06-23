---
name: git-remote-and-skill-setup
description: 01-Cl-passv_6L_3x2x1 프로젝트의 git remote 정보와 /make-surface-defect 스킬 복사 이력
metadata: 
  node_type: memory
  type: project
  originSessionId: b4c9902c-8141-4114-9ae5-ee329d5e3fe6
---

## Git Remote

이 프로젝트(`01-Cl-passv_6L_3x2x1`)의 git origin은 hohenberg 서버 로컬 저장소:
`/mnt/hohenberg/byuid/jaegwan97/scripts/Defect_Package/`

**Why:** GitHub이 아닌 서버 내부 경로를 사용. push/pull 시 이 경로 참조.

## /make-surface-defect 스킬 복사

2026-06-23에 `~/materials/.claude/commands/make-surface-defect.md`를 이 프로젝트의 `.claude/commands/`로 복사함.

**Why:** 원래 스킬은 `~/materials` 프로젝트에만 있어서 하위 git repo에서는 사용 불가했음.
**How to apply:** 이 프로젝트에서 `/make-surface-defect` 스킬 직접 사용 가능. 스킬 내용 수정 시 양쪽 동기화 필요.

## 스킬 vs 스크립트 구조

- `scripts/generate_surface_defect.py` — CLI 도구 (POSCAR 조작 엔진)
- `.claude/commands/make-surface-defect.md` — Claude 워크플로우 지시서 (자연어 → 스크립트 호출 + 검증 + defects.yaml 업데이트)

Related: [[surface-defect-poscar-generation]], [[defect-calc-folder-structure]]
