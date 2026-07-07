---
name: species_aliases_mechanism
description: "In_L(리간드 In)→In_d POTCAR alias. runtime.yaml species_aliases로 prep 통과, VASP는 라벨 안읽음"
metadata: 
  node_type: memory
  type: project
  originSessionId: 2163ba0c-eca3-4376-996b-9bea6a53cf93
---

03-InCl3-passv 셀은 POSCAR line6에 `In_d, As, H1.25, H.75, In_L, Cl`(6그룹)로, 리간드 In(InCl3 passivant)을 `In_L`로 별도 라벨링. POTCAR은 이미 6블록으로 In_L 자리에 In_d를 넣어둠(정상).

**오류 지점은 VASP가 아니라 Defect_Package prep 파이썬**: VASP는 POSCAR 라벨을 안 읽고 POTCAR 블록수=POSCAR 종그룹수(6=6)만 확인 → In_L 무관. 실제로 죽는 곳은 `check_species_order`(In_L≠In_d 예외)와 `compute_neutral_nelect`(zval_map에 In_L 키 없음).

**해결(Option A, 2026-07-07):**
- `config/runtime.yaml`에 `species_aliases: {In_L: In_d}` 추가
- `utils_vasp.py`에 `resolve_species_alias()` 헬퍼, `check_species_order`/`compute_neutral_nelect`에 `aliases` 파라미터(기본 None=하위호환)
- `prepare_defect_workflow.py`가 `runtime_cfg["species_aliases"]`를 두 호출에 전달

**Why:** 리간드 In을 분석·defects.yaml(InL003 참조)에서 별도 추적하려는 셀 설계 의도 유지하면서, prep의 POTCAR 교차검증만 alias로 통과. NELECT는 In_d ZVAL(13e⁻)로 정확(pure 1016 검증).

**How to apply:** "같은 POTCAR·다른 라벨" 케이스가 또 나오면(예: surface As vs bulk As) `species_aliases`에 한 줄 추가만 하면 재사용. 안전판(VASP 투입 POSCAR를 In_d로 rewrite)은 불필요—VASP가 라벨을 안 읽으므로. 관련 [[defect_package_repo]].
