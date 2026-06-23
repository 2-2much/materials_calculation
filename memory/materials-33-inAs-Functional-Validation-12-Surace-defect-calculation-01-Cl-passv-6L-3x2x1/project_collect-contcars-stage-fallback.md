---
name: collect-contcars-stage-fallback
description: collect_contcars.py는 runtime.yaml의 preferred_geometry_stages 순서대로 CONTCAR를 탐색 — 00_Gam-relax fallback 추가함
metadata: 
  node_type: memory
  type: project
  originSessionId: a824140b-f340-4342-b5f3-b8e11a6e793c
---

`scripts/collect_contcars.py`는 `config/runtime.yaml`의 `preferred_geometry_stages` 리스트에 있는 stage만 탐색하여 CONTCAR를 수집한다. 원래 `[01_Relax]`만 있어서 `00_Gam-relax` 단계까지만 진행된 defect(In_As, In_i_Td_As, In_i_Td_In, V_Cl-* 등)가 누락됐다.

**Why:** 일부 defect는 아직 01_Relax까지 진행하지 않았고, 00_Gam-relax에서 converge된 CONTCAR만 존재.

**How to apply:** `preferred_geometry_stages: [01_Relax, 00_Gam-relax]`로 설정하여 01_Relax 우선, 없으면 00_Gam-relax fallback. 새 stage가 추가되면 이 리스트도 업데이트 필요. 관련: [[defect-calc-folder-structure]]
