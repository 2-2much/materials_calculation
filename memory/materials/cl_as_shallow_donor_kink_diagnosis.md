---
name: cl_as_shallow_donor_kink_diagnosis
description: "04 Cl_As_1/Cl_As_2 DFE의 갭 내부 kink는 k-point 문제가 아니라 PHS pull-down(0.335 eV) — 고유값·총에너지 두 경로가 2 meV로 일치, 보정 3항은 전부 반대 부호"
metadata: 
  node_type: memory
  type: project
  originSessionId: ad99f4fe-653c-4334-94a6-19f7a46a69b2
  modified: 2026-07-23T06:57:50.191Z
---

2026-07-23, 검증 에이전트 2인 독립 교차검증. **질문: Cl_As가 shallow double donor여야 하는데
DFE에 갭 내부 kink가 생긴다, Γ-only 탓인가? k 늘리면 해결되나? → 답: 아니다.**

## 정량 진단 (04-InCl3-passv_6L_4x2x1_HSE06, Cl_As_1)
셀 17.2486×12.1966×29.8137 Å(슬랩 11.3 + 진공 18.5), Γ-only, 128 ions.
pure: VBM=−1.16119, CBM=+0.09483 → **gap 1.2557**(`--band-gap 1.256`와 일치).

**독립 두 경로가 2 meV로 일치 — 이게 진단의 핵심 증거:**
- 고유값 경로: q0 b510 정렬 후 −0.2402 = **pure CBM 아래 0.335 eV**
- 총에너지 경로: E_g − ε(+1/0) = 1.2557 − 0.9189 = **0.337 eV**

즉 kink는 단일 물리량 = **CBM 유래 상태가 주기 이미지 인력으로 0.335 eV 인위적 결합**(PHS).

## 보정 방향 (부호가 승부처)
ε(+1/0) = E(0)−E(+1)−E_corr(1)−E_VBM 이므로 ∂ε/∂E_corr(1) = **−1**.
| 항 | 방향 |
|---|---|
| image-charge E_corr (∝q², **항상 양수**; 이 트리 실측 전부 양수, Cl-As_In이 E_corr(+2)/E_corr(+1)=3.91≈q²) | ↓ 더 깊어짐 |
| potential alignment −q·ΔV (In-4d 기준 q+1 −0.386, q+2 −0.673) | ↓ 더 깊어짐 |
| Moss–Burstein band-filling | **정확히 0** (CBM 위 점유 상태 없음) |
| **PHS pull-down** (CBM 아래 점유 상태 → E_tot **올림**) | ↑ **유일하게 맞는 방향** |
| lateral 셀 확대 | ↑ 맞지만 k-mesh 아님 |

ε를 E_g로 올리려면 E_corr(1)=**−0.337 eV**(음수 image-charge)가 필요 → 비물리. **보정으로 못 고친다.**

PHS 적용 시: E(q0) +0.670(=2×0.335), E(q+1) +0.294 → **ε(+1/0) 0.919 → 1.295 ≈ CBM(40 meV 이내)**.
⚠단 **ε(+2/+1)은 0.674 → 0.968로 여전히 갭 안 0.29 eV** — q+2 유한크기 정전기학 미해결.

## 왜 k-point가 아닌가
- 셀 L의 N×N mesh는 **host에 대해서만** NL 셀의 Γ와 등가. **결함 배열 주기는 L 그대로** → 농도 못 묽힘.
- pure는 VBM·CBM **둘 다 supercell Γ**(2×2×1 확인) → 밴드모서리·gap·E_VBM 기준은 **k-불변**.
- a_B=348 Å, 궤도부피/셀부피 = **~28,000배**. 결함 면밀도 4.8e13 cm⁻². **어떤 mesh로도 표현 불가.**
- 8×4(면적 4배)로 키워도 잔여 ~0.084 eV → 갭 내 kink 여전.

## ⚠"mesh ≡ correction" 은 대수적 항등식일 뿐 (2026-07-23 실측 정정)
Γ-only+PHS = mesh+MB = N·E_CBM 은 **rigid-band 대수로만** 성립(둘 다 도너 전자를 CBM에 놓음).
**총에너지로 검증하려 하면 안 된다** — 고유값합 ≠ 총에너지.
- 04 Cl_As_1 q0, **동일기하·ISPIN=1·HSE AEXX0.27·ENCUT300** 실측:
  Γ −562.94316 → 2×2×1 **−562.99529** = **−0.052 eV**. 도너밴드 고유값합 추정(+0.98)과 부호조차 반대.
- E_f에 쓰이는 건 E(defect)−E(pure)이고, 절대 총에너지는 host k-수렴으로 크게 내려간다:
  02 PBE-d k-test 실측 pure_q0 −340.030(Γ) → −342.778(2×2×1) = **−2.75 eV**.
- 02 측정 E(def)−E(pure): Γ **3.8429** → 2×2×1 4.3125 → 3×3×1 **4.4443** → 4×4×1 4.4368.
  **Γ가 0.594 eV 낮다.** 그런데 그 계의 PHS/band-filling 몫은 0.2~0.33 eV 수준 → **절반가량은
  보정으로 못 없애는 host k-수렴**. 즉 **"보정이 레버, mesh는 아니다"는 과장**이었다.
  ⚠이 test는 **PBE-d**이고 HSE k-수렴은 미완이라 04에 직접 전용 불가.

**정정된 결론**: kink/CTL 위치(농도 문제)는 k와 무관 — 이건 유효. 하지만 **shallow-limit의 앵커
E_f(0) 자체는 k에 민감**(측정된 유일 사례에서 0.6 eV)하므로 k를 무시하면 안 된다.

## 그래도 k를 늘려야 하는 곳 (혼동 말 것)
1. **deep/bound 결함**(In_As_1, In_As_2): 점유된 결함밴드가 인위적 분산을 가지는데 Γ는 **밴드 모서리**라
   E_tot이 낮게 편향. Cl-As_In 실측 **~0.19 eV**. 보정으로 못 없앰 → mesh 또는 Baldereschi 필요.
   실증: 02 `calc/__k-point_test__/Vcl_neutral_PBEd/` E(V_Cl-Cl_As q0)−E(pure q0) =
   **Γ 3.8429 → 2×2×1 4.3125 → 3×3×1 4.4443 → 4×4×1 4.4368** (Γ가 **0.594 eV 낮음**, 3×3×1 수렴).
   ⚠**HSE k-수렴은 미완**(`Vcl_neutral_HSE`는 k1만 완료).
2. slabcc용 전하밀도(2×2×1_MP 또는 Baldereschi, Γ 금지).

## 부수 발견
- **진공 18.5 Å** ≪ 자체 진공스캔이 세운 하전 슬랩 수렴 하한 **40~50 Å** → 하전상태에 별개의 실오차.
- 04 `Cl_As_1/q0/02_G221-DOS`(2×2×1) **Σocc = 2.00 e** → double donor **독립 확인**. 밴드폭 0.84 eV.
- slabcc는 "거부"가 아니라 **완주했으나 correction 미출력**, σ_opt 4.757(q+1)/5.558(q+2) bohr가
  셀 반폭(6.1 Å)을 넘어섬 = 모델전하가 셀에 안 들어감. [[slabcc_charge_truncation_guard]]
- 04는 pure·charged의 2×2×1이 없어 mesh로 재유도 불가(신규 계산 필요).

## 조치
**shallow-limit 작도**: `E_f(+q, E_F) = E_f(0) + q(E_F − E_g)`. 두 CTL이 정의상 CBM에 놓임.
⚠**이건 근사가 아니라 PHS 보정 그 자체**다(PHS +0.335 넣으면 ε=1.254≈E_g로 재현됨).
[[shallow_limit_dfe_construction]], [[shallow_donor_inas_supercell_limit]],
[[bandfilling_measured_from_dos]], [[slabcc_delocalized_defect_policy]]
