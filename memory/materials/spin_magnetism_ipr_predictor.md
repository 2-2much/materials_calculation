---
name: spin_magnetism_ipr_predictor
description: "홀수 전자 mag→0은 버그 아님. frontier IPR이 자성을 예외 없이 예측하고, EENTRO≠0 단독은 스핀 미수렴 진단자가 아니다(2026-07-21 정정)"
metadata: 
  node_type: memory
  type: project
  originSessionId: d576a7a9-cf3d-4e2f-9807-95093dc06f3d
  modified: 2026-07-21T05:58:08.017Z
---

**결론: frontier 상태의 IPR 비(vs pure 밴드모서리)가 자성 여부를 결정한다. 홀수 전자수도, EENTRO≠0도 단독으로는 아무것도 진단하지 못한다.**

2026-07-21, 검증 에이전트 2인을 상반된 입장으로 붙여 실측 검증한 결과. 발단은 "홀수 전자면 mag=0이 불가능하다"는 내 주장이었고, **그 주장이 틀렸다.** 정수 점유일 때만 성립하며, 스머링이 켜져 있으면 `N_up=N_dw=511.5`가 허용되고 **비국소 상태에서는 그게 물리적 정답**이다.

## 회귀표 (02-Cl-passv 7개 + 04-InCl3 1개, ΔE = E0(spin) − E0(nonmag))

| defect | IPR/edge | up−dw 분열 | mag | ΔE |
|---|---|---|---|---|
| V_Cl-Cl_In q0 | 8.35× | — | 1.0000 | **−268 meV** |
| Cl-As_In q0 | 6.25× | 0.759 eV (7.6σ) | 1.0000 | **−171 meV** |
| **In_i_Td_In q0** | **1.41×** | **0.096 eV ≈ σ** | **0.5027** | −7.0 meV ⚠신뢰불가 |
| In_i_Td_As q0 | 1.08× | — | 0.006 | −0.5 meV |
| V_Cl-Cl_As q0 | 1.00× | 0.0009 eV | 0.005 | −0.8 meV |
| Cl_i-As q0 (04) | 1.02× | ≲0.002 eV | →0.009 | ~−1 meV |

**IPR>6× → 171~268 meV 자성, IPR<1.1× → 1 meV 미만 비자성.** 예외 없음. 진짜 자성체는 분열이 SIGMA의 7.6배라 스머링이 뭉갤 수 **없다** — 같은 프로토콜(ISMEAR=0, SIGMA=0.1, NUPDOWN 없음)로 정수 점유를 깔끔히 찾아냈다.

## ⚠ [[spin_stage_symmetry_never_broken]]의 EENTRO 진단자 정정

거기 적힌 "홀수 전자 + ISPIN=2 + **EENTRO≠0이면 스핀 미수렴**"은 **너무 뭉툭하다.** EENTRO≠0이 진단하는 건 *frontier 상태의 분수 점유*이지 *놓친 자성해*가 아니다. 둘이 일치하는 건 **상태가 속박일 때뿐**이다. 그래서 그 메모리가 "걸린다"고 지목한 V_Cl-Cl_As(0.0282)는 실제로는 IPR 1.00×의 진짜 비자성체다 — **오탐이었다.**
올바른 진단자 = **IPR 비**(스핀 독립이라 순환논법도 피함. mag이 0으로 무너진 뒤 Δ_x=I·m을 재면 순환이 된다).

## ⚠ 실제로 재계산 필요한 것: In_i_Td_In q0

분열 0.096 eV가 SIGMA 0.1 eV와 맞먹고 IPR 1.41×(게이트 사이 회색지대), **mag=0.5027이라는 물리적으로 불가능한 값에 갇혔다.** [[surface_defect_spin_screening_full]]에 "애매, 재확인 필요"로 남아 있던 미결 항목의 정체가 이것. **ΔE=−7.0 meV는 신뢰 불가 → NUPDOWN=1 또는 SIGMA 축소 재계산.** (2026-07-21 사용자 판단: 당장 안 돌리고 추가 검토 후 진행)
위험구간 규칙: **IPR 1.2~2× 구간 = Δ_x ≈ σ = 스머링 함정 구역.**

## 엔트로피 보너스 기전 (SCF가 비자성을 편애하는 실제 경로)

SCF는 `F = E − σS`를 최소화하는데 대칭 0.5/0.5 해가 **56 meV 엔트로피 보너스**를 받는다(`EENTRO = 2σ/(2√π)`, SIGMA=0.1). 따라서 **E 기준 56 meV 미만짜리 자성해는 F 경쟁에서 질 수 있다.** Cl-As_In은 143 meV로 이겨서 무사했고, 위험한 건 정확히 In_i_Td_In이 있는 자리.

## 상쇄되는 것 / 안 되는 것 (56 meV를 과대평가하지 말 것)

- **스핀 스크리닝에서는 완전 상쇄.** Cl_i-As의 EENTRO가 00(ISPIN=1) −0.05641896 vs 01(ISPIN=2) −0.05641455 — **5 μeV 차이**. 홀수 전자라 양쪽 다 반점유를 갖기 때문. ΔE 판정에 영향 0.
- **안 되는 곳 = 전자 패리티가 다른 결함끼리 비교**(DFE 서열, CTL). 홀수만 `F−E0 = EENTRO/2 = 28 meV`를 달고 내려간다. 다만 DFE 차이는 eV 규모라 **서열은 안 뒤집히고**, HSE AEXX 불확실성(수백 meV)이 훨씬 크다. → [[energy_column_sigma0_vs_toten]]의 `energy_sigma0_eV` 전환으로 공짜 해결. **이것 때문에 SIGMA 줄이거나 재계산하는 건 과잉.**

**Why:** "홀수 전자 = 자성"이라는 직관과 "EENTRO≠0 = 버그"라는 이전 규칙이 둘 다 오탐을 낳았다. 자성 판정은 전자수 패리티가 아니라 **국소화**가 결정한다. [[shallow_donor_inas_supercell_limit]](a_B=349Å)의 필연적 귀결이기도 하다 — 도너 전자가 host CBM에 있으면 교환적분이 1/V로 죽는다.

**How to apply:** 새 결함의 자성 판정은 `ipr_gate.py`([[ipr_gate_tool]])를 **먼저** 돌려 IPR 비를 본다. >2× 면 자성 기대·NUPDOWN 불필요(알아서 찾음), <1.2× 면 mag→0이 정답, **1.2~2× 면 NUPDOWN=1로 검증**. mag≈0을 보고 NUPDOWN=1을 거는 건 ~2 meV를 사면서 F를 28 meV 올려 **에너지가 높아진 것처럼 보이게만** 만든다. IPR<1.1× 결함은 [[shallow_limit_dfe_construction]]으로 작도(slabcc는 범주 오류, [[slabcc_delocalized_defect_policy]]).
