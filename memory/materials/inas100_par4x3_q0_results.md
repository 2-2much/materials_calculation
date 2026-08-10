---
name: inas100_par4x3_q0_results
description: "07 par4x3 q0 14셀 결과 확정 — 자성은 V_Cl·In_i_sub 둘뿐, 깊은준위 5종, ★E_F를 CB로 미는 건 V_Cl-Cl_As·In_i_surf·Cl-As_In. 여기서 하전 14케이스 도출"
metadata: 
  node_type: memory
  type: project
  originSessionId: 21521b3d-9090-4351-9826-e8574651dc0d
  modified: 2026-08-10T12:49:36.832Z
---

2026-08-10. `07-100Cl_8L_par4x3_PBE-d` 중성 14셀(pure+13결함) 완주. PBE-d, Γ 이완 → 2×2×1 단일점.
pure 갭 **0.888 eV**(VBM raw −1.2219). 정렬은 In 4d 준내각(에너지창 [−17,−13] eV) 중앙값.

## 스핀 — 자성은 둘뿐

| defect | NELECT | ΔE=E₀(01)−E₀(00) | mag | EENTRO | IPR |
|---|---|---|---|---|---|
| **V_Cl** | 917 odd | **−53.98 meV** | **0.974** | −0.005 | **9.02×** |
| **In_i_sub** | 937 odd | **−15.10 meV** | 0.721 | −0.032 | **7.67×** |
| 나머지 12 | | \|ΔE\|<0.6 meV | <0.003 | | |

`V_Cl`은 MAGMOM 2.0→0.974로 48스텝에 걸쳐 **수렴**(탐색의 결과), 스핀분열 0.314 eV=3.1σ.
`In_i_sub`는 mag 0.72/EENTRO −0.032로 **정수 점유 미달** → NUPDOWN=1 검증 대상.
⚠ ΔE 잡음 바닥은 **±0.3 meV**(00은 EDIFF=1E-5, 01은 1E-4) — 양수 0.2 meV 따위는 무시.

## ★ (110)과 갈린다 — Cl-As_In은 (100)에서 비자성
(110)에서 IPR 6.25× / ΔE −171 meV / mag 1.0 이던 것이 여기서는 **1.89× / +0.04 meV / 0.001**.
**같은 결함 이름이 면에 따라 다른 물건**이다. (110) 결과를 (100)에 이식 금지.

## 갭 내 준위 (2×2×1에서 추출, E−VBM)

| defect | 준위 | 점유 | 밴드폭 |
|---|---|---|---|
| V_Cl | +0.36↑ / +0.68↓ | 1.00 / 0.00 | 0.03/0.07 |
| In_i_sub | +0.48↑ / +0.69↓ | 1.00 / 0.00 | 0.12/0.16 |
| Cl_As | +0.36 (축퇴) | 1.00 / 1.00 | 0.05 |
| V_As | +0.62 (축퇴) | 0.48 / 0.52 | 0.08 |
| **Cl_In** | **+0.50 (축퇴)** | **0.00 / 0.00** | 0.04 |
| 나머지 8 | — 없음 — | | |

## ★★ E_F — n형 기원의 핵심

| defect | E_F−VBM | E_F−CBM | **CB 전자수** |
|---|---|---|---|
| **V_Cl-Cl_As** | +0.983 | **+0.095** | **0.523** |
| **In_i_surf** | +0.975 | **+0.087** | **0.492** |
| **Cl-As_In** | +0.892 | +0.004 | 0.097 |
| V_As / In_i_sub / Cl_As / V_Cl | +0.62/+0.54/+0.39/+0.38 | | 0 (깊은준위에 pin) |
| 나머지 6 + pure | +0.00~+0.10 | | 0 |

⇒ **셋은 갭에 준위가 없고 IPR도 1.07/1.12/1.89×인데 전자를 host CB에 얹는다.**
"n형은 준위가 아니라 전자수"([[cl_shallow_donor_no_gap_state]])의 직접 실증.
bandfill(02) 도 같은 결론: `In_i_surf` MB N_e 1.0 E_bf +0.178, `V_Cl-Cl_As` MB +0.057.
⚠ CB 전자 0.5개는 par4×3 결함면밀도(4.3e13 cm⁻²)에서의 값. 희박 CQD로 곧장 옮기지 말 것.

## ⚠ IPR 게이트의 구조적 한계 (여기서 처음 드러남)
`ipr_gate.py`는 q0 행에서 **HOMO만 probe**한다 → **비점유 깊은 준위를 못 본다.**
`Cl_In`이 IPR 0.97×로 "shallow"로 분류됐지만 실제로는 **갭 한가운데 +0.50에 완전히 빈 평탄
준위**가 있다(밴드 그림에서 육안으로 잡음). **게이트만 믿지 말고 밴드/DOS를 볼 것.**
([[ipr_gate_tool]] [[ipr_gate_occdiff_probe]])

## 도출된 하전 계산 14케이스 (2026-08-10 제출, 잡 55993~56006)
```
1순위(진짜 CTL) V_Cl +1,−1 · In_i_sub +1,+2 · Cl_As +1,+2 · V_As +1 · Cl_In −1,−2
2순위(검증용)   V_Cl-Cl_As +1 · In_i_surf +1 · Cl-As_In +1
3순위(억셉터)   V_In −1 · Cl_i-In −1
[0] 유지        As_In · In_As (준위·캐리어 없음) · Cl_i-As (Cl_i-In보다 0.12 eV 높은 이성질체)
```
⚠ **2순위 q+1을 DFE 선 그리는 데 쓰지 말 것** — 전자가 host CB에 있어 image-charge 보정이
범주 오류다. 선은 `E_f(+1,E_F)=E_f(0)+(E_F−E_g)` 얕은극한 작도로 그리고, 이 계산은
"전자가 실제로 빠지는가" 확인용이다([[shallow_limit_dfe_construction]] [[slabcc_delocalized_defect_policy]]).
보정은 CoFFEE(전단 셀 가능). 사용자 판단: **현 진공 14.55 Å 에서도 CoFFEE 수렴한다**(2026-08-10).

## Cl_i 는 CQD 결함으로 부적절 (사용자 판단 + 근거)
`Cl_i-In`이 `Cl_i-As`보다 **0.120 eV 낮다**(같은 조성 직접비교. bridging μ₂ vs terminal).
그러나 (1) cp 표면에서는 그 빈 배위자리를 MA가 차지 → E_bind(In–MA)만큼 억제,
(2) E_f=−1.099 eV는 μ_Cl=½Cl₂ 라는 도달불가 상한에서의 값, (3) **억셉터**라 n형을 보상,
(4) 실험 Cl/As=0.12로 할라이드는 과잉이 아니라 부족.
⇒ n형 후보가 아니라 **μ-diagram의 보상 억셉터 가지**로 분류.

그림: `results/figures/{bands,dos}_par4x3_q0.png` (14패널, E_F 표시, VBM=0 정렬).

관련: [[inas100_par4x3_defect_set_07]] [[gamma_relax_adequacy_par4x3]]
[[inas100_ligand_site_vs_electron]] [[charge_state_selection_rule]] [[bandfill_correction_stage]]
