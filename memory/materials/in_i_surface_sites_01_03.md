---
name: in_i_surface_sites_01_03
description: 01/03 표면 In_i_1(In1+As2)·In_i_2(In2+As1) 3-fold hollow 자리 확정값 + In_i는 5s² lone pair 유지하는 단일도너라 Cl 1개로 상쇄된다는 전자세기
metadata: 
  node_type: memory
  type: project
  originSessionId: c112f7c9-ad4a-4a61-8428-865a9d3d4938
  modified: 2026-08-03T04:14:50.573Z
---

2026-08-03. `12-Surace-defect_calculation/{01-Cl-passv_6L_3x2x1, 03-InCl3-passv_6L_4x2x1_PBE-d}`
에 표면 In interstitial 도너 연구 셋업. kohn에서 새로 생성(bloch 트리와 별개).

## 자리 정의 (사용자 명명, **초기 배치 기준** — relax 후 구조는 크게 바뀜)
- **In_i_1** = 표면 In 1개 + As 2개가 만드는 3-fold hollow
- **In_i_2** = 표면 In 2개 + As 1개가 만드는 3-fold hollow

⚠**삼각형 centroid로 잡으면 안 된다**: (110) 지그재그 사슬이라 변이 2.67/2.67/**4.38 Å**로
거의 일직선 → centroid가 가운데 원자 위 1.0 Å에 떨어진다. **격자 스캔으로 3NN이 2.45~2.95 Å,
4번째 이웃 ≥3.05 Å인 점**을 찾아야 진짜 hollow가 나온다. 스크립트 접근법만 기억하면 재현 가능.

**확정 좌표(pure POSCAR frac, PBE-d 이완 슬랩 기준)**
| | frac | 3NN (pure 번호) | passivation 최근접 |
|---|---|---|---|
| 01 In_i_1 | (0.7333, 0.3444, 0.7094) | In29 2.48 / As64 2.69 / As71 2.82 | Cl 2.54 |
| 01 In_i_2 | (0.5889, 0.2000, 0.7475) | In27 2.47 / In29 2.59 / As63 2.70 | Cl 2.47 |
| 03 In_i_1 | (0.3111, 0.9000, 0.6230) | In37 2.45 / As82 2.53 / As86 2.67 | Cl 2.55 |
| 03 In_i_2 | (0.4222, 0.2889, 0.6197) | In37 2.45 / In45 2.51 / As85 2.85 | Cl 2.80 |

결함 POSCAR에서는 In 블록이 1개 늘어 **As/Cl 인덱스가 전부 +1** 밀린다.
defect_atom_index = 01:**37**, 03:**49**. 추가 Cl = 01:**98**, 03:**130**.

## 핵심 물리: In_i는 triple donor 아니라 **단일 도너**
In_d ZVAL=13 → 6.5밴드 추가. **4d¹⁰(5밴드) + 5s²(1밴드)가 채워지고 5p¹ 1개만 남는다.**
In의 5s² inert lone pair가 살아있어 유효 +1로 거동. 그래서:
- pure NELECT **짝수** → In_i **홀수** → In_i+**Cl 1개** → 다시 **짝수**
- 01: 744 → 757 → 764 / 03: 1016 → 1029 → 1036 (실측 확인)
→ **Cl 1개가 도너 전자를 정확히 상쇄**한다는 것이 비활성화 판정의 1차 지표.
판정은 gap 준위가 아니라 **NELECT 홀짝 + CB 점유**로 할 것
([[shallow_donor_inas_supercell_limit]], [[cl_shallow_donor_no_gap_state]]).

## 이미 나와 있는 HSE 근거 (재계산 금지)
- 02 `In_i_Td_As` / `In_i_Td_In` (subsurface Td, z≈16.3): IPR gate **delocalized (shallow)**,
  ratio_vs_CBM 1.08 / 1.41, carrier 1개. E_form(In-rich) **2.378 / 2.531 eV**.
- 04 `In_i_2`(배출 adatom 기하): 역시 **delocalized (shallow)**, ratio_vs_CBM 0.986.

관련: [[in_i_2_adatom_ejection]] [[cqd_ntype_origin_goal]] [[incl3_cl_as_in_unbound]]
