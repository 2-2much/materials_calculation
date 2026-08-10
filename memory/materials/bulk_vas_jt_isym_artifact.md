---
name: bulk_vas_jt_isym_artifact
description: 216셀 V_As의 T_d는 ISYM 아티팩트 — PBE/ISYM=0은 C_3v JT(In-In 퍼짐 0.79Å). 세 트리 비교표 + PBE bulk InAs gap=0.0000 실측
metadata: 
  node_type: memory
  type: project
  originSessionId: e9363e11-2b2c-4fde-a2b9-33170a595669
  modified: 2026-08-10T12:43:11.592Z
---

216-cell V_As의 국소 대칭은 **셋업에 따라 결론이 뒤집힌다** (2026-08-11 확인).

| 트리 | 함수/a0 | ISYM | ISPIN | In-V_c (Å) | In-In 6쌍 퍼짐 | 대칭 |
|---|---|---|---|---|---|---|
| `02-LDA/bulk/3.216-cell/22.V_As/02-G333/q0/01-LDA` | LDA a0=6.0587, In ZVAL=3 | **2** | 2(NUPDOWN=1) | 2.2824 ×4 (완전 동일) | **0.0000** | T_d (spglib P-43m 24/24) |
| `07/13-HSE06_PBE-d_at_a0=HSE06_PBE-d` | HSE06 AEXX .27, In_d, a0=6.099 | 0 | 1(off) | 2.382/2.385/2.385/2.405 | 0.037 | ~T_d |
| `bloch:07/12-PBE_In-4d_at_a0=PBE_d` | PBE, In_d, a0=6.1898 | 0 | 1 | 2.326/2.382/2.389/**2.939** | **0.793** | **C_3v (JT)** |

PBE/ISYM=0의 JT 패턴: In42가 ⟨111⟩로 밀려나고(2.94 Å) 나머지 3개가 삼각형으로 수축.
In42 포함 쌍 4.404/4.501/4.507 vs 나머지 3쌍 3.714/3.725/3.751. t₂¹의 trigonal(t₂) JT 모드.

**왜 셋이 다른가**
- LDA 트리: ISYM=2가 힘을 대칭화 → JT가 **원천 금지**. T_d는 증명이 아니라 구속.
- HSE 07/13: ISYM=0이지만 **이미 대칭인 구조에서 출발**해 15 step에 0.15 Å만 이동 → 대칭 우물에서 못 빠져나옴. JT를 테스트한 적 없음.
- PBE 12: 75 ionic step, ISYM=0 → 실제로 빠져나감.

**⚠ 파급**: T_d의 a₁ ⊕ t₂(3중) 그림은 C_3v에서 a₁ ⊕ a₁ ⊕ e로 쪼개진다. gap/CB resonance 위치를
논할 때 어느 기하인지 반드시 명시할 것. HSE로 JT를 판정하려면 **PBE JT 구조를 시드로** 재이완 필요.

**PBE bulk InAs는 gapless (실측)**: `12-PBE.../calc/pure/q0/02_G333_1shot` G333(14 irr k)
VBM=CBM=**3.8265 → gap 0.0000 eV**. V_As도 0.0089. → **bulk V_As의 "gap 내 준위" 판정은 PBE로 불가**
(COHP·궤도성격·JT 기하는 유효). 표면 슬랩은 양자구속으로 PBE-d에서도 Γ gap 0.21 eV 살아있음.

관련: [[surface_defect_spin_screening_full]] [[hse_relax_vs_singlepoint]] [[spin_stage_symmetry_never_broken]]
