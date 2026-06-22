---
name: make-surface-defect-skill-redesign
description: "/make-surface-defect 스킬 재설계 — 사용자 인자 기반 실행, 대화형 질문 제거, 다중 원자 조작 지원 필요"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: fdcd288f-1c59-4934-bbc5-f311975ac30a
---

스킬을 사용자가 인자를 직접 제공하는 방식으로 재설계했다 (2026-06-22).

**Why:** 기존 대화형 워크플로우(defect 종류 선택 → 원자 선택 → grid search)가 사용자 의도와 맞지 않았음. 사용자는 defect 이름, 대상 원자, reference를 직접 지정하고 싶어함.

**How to apply:**
- 호출 시 사용자가 제공: defect 이름, 조작할 원자 번호, 조작 내용, reference POSCAR
- Interstitial 위치: 사용자가 지정한 이웃 원자들의 centroid로 계산
- `generate_surface_defect.py`는 현재 단일 원자 조작만 지원 — 다중 원자 조작(V_Cl-V_In 같은 double vacancy) 지원 확장 필요
- 스킬 파일: `materials/.claude/commands/make-surface-defect.md` (이미 수정 완료)
