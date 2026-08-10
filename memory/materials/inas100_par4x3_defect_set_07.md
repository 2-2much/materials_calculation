---
name: inas100_par4x3_defect_set_07
description: "07-100Cl_8L_par4x3 결함 13종 생성(2026-08-10). ★05 p4x4와 절대 registry가 0.0004Å 일치 → 자리 대응 In23/As7/Cl3 = 05의 In47/As23/Cl6. pseudo-H는 전 셀 고정 완료"
metadata: 
  node_type: memory
  type: project
  originSessionId: 21521b3d-9090-4351-9826-e8574651dc0d
  modified: 2026-08-10T01:53:45.184Z
---

2026-08-10. `12-Surace-defect_calculation/07-100Cl_8L_par4x3_PBE-d`에
05-100Cl_8L_p4x4_PBE-d의 결함 세트를 그대로 재현했다.

## ★ 두 셀은 같은 절대 registry에 놓여 있다
05 p(4×4) pure의 **모든 원자를 항등사상(t=0)으로 07 par4×3 셀에 wrap하면 최대 잔차
0.0004 Å**. 두 셀 모두 표면 병진격자 Λ = {(8.754 m, 4.377 n)}의 초격자이기 때문
(05: a=2t₁, b=4t₂ / 07: a=2t₁, b'=t₁+3t₂). 그래서 **05의 결함 좌표를 그대로 옮기면
국소 이웃거리가 정확히 재현**된다(2.68/2.68/2.90, 2.68/2.68/2.70/2.74 등 전부 일치).

자리 대응 (pure POSCAR 1-based):

| 역할 | 05 p4×4 | **07 par4×3** |
|---|---|---|
| bare 표면 In | In47 (A47) | **In23 (A23)**, dimer 짝 In24가 Cl3를 인다 |
| 2층 As (4배위) | As23 (A87) | **As7 (A55)** |
| passivation Cl | Cl6 (A166) | **Cl3 (A123)** |

## 만든 것 — 13종 (`Initial_POSCARs/<name>/POSCAR` + `.labeled`)
As_In · Cl_In · V_In / Cl_As · In_As · V_As / V_Cl / V_Cl-Cl_As /
Cl_i-As · Cl_i-In / In_i_sub · In_i_surf / **Cl-As_In**.
`config/defects.yaml`을 07 인덱스로 새로 씀 (기존 파일은 05를 그대로 복사한 것이라
인덱스가 전부 틀렸었다).

NELECT (pure=924): 짝수 As_In 916 / Cl_In 918 / Cl_As 926 / In_As 932,
홀수 V_In 911 / V_Cl 917 / V_As=V_Cl-Cl_As 919 / Cl-As_In 923 / Cl_i 931 / In_i 937.

`Cl-As_In`은 **이상격자 As_In 위에 Cl 하나를 얹은 미완화 seed**다. 방향·거리는 05의
완화 구조에서 antisite As→Cl 벡터 `(−0.897, 0.000, +2.012) Å` (|v|=2.203)를 그대로 썼다
— dimer 짝 In24 반대쪽으로 기운 방향. bloch에 par4×3 완화 CONTCAR이 있으면 그게 더 낫다.

## pseudo-H — 2026-08-10 고정 완료
07 pure가 H를 `T T T`로 달고 왔었다(05는 `F F F`). 사용자 지시로 **pure 포함 14개 셀
전부 H를 `F F F`로 고정**했다. 이제 셀당 `F F F` 48개 = pseudo-H 24 + bottom In 12 +
bottom As 12로 05와 같은 규약이고 H 기하가 E_f에서 정확히 상쇄된다.
([[inas100_pseudoh_lasph_footing]])

## ⚠ species 라벨 함정
07 POSCAR 6행은 `In`인데 POTCAR TITEL은 `In_d`. 그대로 두면 `check_species_order()`가
전 케이스를 거부한다 → `config/runtime.yaml`에 `species_aliases: {In: In_d}` 추가함
([[species_aliases_mechanism]]).

## ⚠ 셀 선택 재론
[[inas100_cell_convergence_metric]]은 2026-07-29에 **p4×4 채택**으로 확정했다.
par4×3은 중성 E_b 수렴이 제일 좋지만 **면적이 p4×3와 같아 2D Madelung 자체이미지가
네 셀 중 최악이고 slabcc가 전단 셀을 못 다룬다.** 07은 중성 스크리닝·밴드·자성용으로 읽을 것.

관련: [[inas100_par4x3_sheared_cell]] [[inas100_dimer_row_chain]]
[[inas100_ligand_site_vs_electron]] [[charge_state_selection_rule]]
