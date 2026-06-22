---
name: pending-defect-generation
description: "추가 생성 예정인 3종 surface defect — In_i_Td_As, V_Cl-V_In, V_Cl-Cl_In (스킬 재정비 후 진행)"
metadata: 
  node_type: memory
  type: project
  originSessionId: fdcd288f-1c59-4934-bbc5-f311975ac30a
---

2026-06-22 기준, 아래 3종 defect POSCAR 생성이 보류 중이다. 사용자가 손으로 먼저 만들 수도 있음.

**Why:** 기존 5종(In_As, V_In, V_As, In_i, As_i)이 사용자가 의도한 configuration과 맞지 않아 새로 설계 중.

**How to apply:** 다음 대화에서 defect 생성을 재개할 때 이 목록과 파라미터를 기준으로 작업.

## 생성 예정 Defects (reference: inputs/pure/POSCAR)

| Defect | 설명 | 세부 |
|--------|------|------|
| In_i_Td_As | As-tetrahedral site에 In 도핑 | As016, As028, As034, As036의 centroid에 In 삽입 |
| V_Cl-V_In | double vacancy | Cl004, In028 원자 삭제 |
| V_Cl-Cl_In | vacancy + 치환 | Cl004 삭제, In028→Cl 치환 |

## 참고
- 사용자가 처음 Cl14라고 했으나 **Cl004**의 오기 (pure slab에 Cl은 001~012만 존재)
- `generate_surface_defect.py`는 단일 원자 조작만 지원 — V_Cl-V_In, V_Cl-Cl_In처럼 2개 원자 동시 조작은 스크립트 확장 또는 수동 편집 필요

Related: [[surface-defect-poscar-generation]], [[defect-calc-folder-structure]]
