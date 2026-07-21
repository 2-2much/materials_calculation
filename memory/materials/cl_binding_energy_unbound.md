---
name: cl_binding_energy_unbound
description: "02-Cl-passv Cl-As_In의 Cl binding energy = 음수(unbound). Cl2 기준 −0.317eV, HCl −1.306eV. Γ-only는 이 양에 미수렴(130meV)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 21ba4701-12fb-4582-8d69-24cecc9e027f
  modified: 2026-07-21T08:41:43.750Z
---

## Cl binding energy — Cl-As_In의 Cl은 결합하지 않음 (2026-07-21)

대상: `12-Surace-defect_calculation/02-Cl-passv_6L_3x2x1_HSE06/calc/{Cl-As_In,As_In}/q0`

두 계는 조성이 **정확히 Cl 1개만** 다름(In35/As37/H1 6/H. 6, Cl 13 vs 12;
전자수 743.0 vs 736.0 = ZVAL(Cl) 7). 따라서

**E_b = [E(As_In) − E(Cl-As_In)] + μ_Cl = ΔE_slab + μ_Cl**

(E_b < 0 = 탈착이 발열 = unbound. 부호 규약 주의: 이건 desorption 에너지)

| | Γ-only (01_Spin-gam-relax) | 2×2×1 (02_G221-DOS) |
|---|---|---|
| E(Cl-As_In) | −423.33535350 | −425.49752293 |
| E(As_In) | −420.82425977 | −423.11650931 |
| **ΔE_slab** | **+2.51109** | **+2.38101** |

μ_Cl은 [[mu_reference_phases]] 사용:

| reservoir | E_b (2×2×1) |
|---|---|
| Cl₂ | **−0.317 eV** |
| HCl (H-rich) | **−1.306 eV** |
| InCl₃ | 미계산(μ_In 부재), 실험 ΔH_f 추정 −1.6(기체단분자) ~ −2.2(고체) eV |

### 열역학 정리 (계산 없이 부호 확정)
**Cl₂ 기체가 μ_Cl의 상한**(μ_Cl > ½E(Cl₂)면 Cl₂ 석출). 따라서 평형에 있는
**어떤 Cl reservoir도 E_b를 더 음수로만 만듦**. Cl₂ 기준 −0.317이 가장 덜 음수인 극한값.
상별 μ_Cl 서열 = 기체단분자 > 고체 > 용액.
↔ 이건 [[cl_as_negative_eform_reference_slab]]의 "μ_Cl 구속 넣으면 04 음수 해소"와 같은 방정식
(E_f(Cl 추가 결함) = −E_b).

### ⚠ Γ-only는 이 양에 수렴하지 않음
Γ→2×2×1에서 ΔE_slab이 **130 meV** 이동(2.511→2.381). 부호는 안 바뀌고 오히려
더 unbound가 되지만, **Γ-only 값(−0.187)을 인용하지 말 것**. 3×2 셀에서 결함준위
분산이 커서 Γ 한 점으로 밴드평균이 안 잡히는 것으로 보임 ↔ [[defect_states_02_clpassv]]

### 남은 구멍
- 기하는 여전히 **Γ에서 이완된 것**. 2×2×1 값은 고정기하 single-point(순수 k-오차만 분리).
- **2×2×1이 수렴점인지 미확인** → 3×3×1 single-point 2건이면 판정 가능.
- 슬랩은 PRECFOCK=**Normal**, reference set은 **fast** → ~30 meV footing 차 잔존.
- ZPE 미포함(Cl₂ ½ZPE +17 meV, 표면 Cl–As 진동 미측정, 부분상쇄 ~20 meV 이내).
