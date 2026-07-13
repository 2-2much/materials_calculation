---
name: project_slabcc-correction-validity
description: "How to judge slabcc/SCPC charged-defect correction validity — POT match + DFE convergence, not CHG shape"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1297c17b-084f-48f0-af37-849b065aa6b4
---

slabcc(및 SCPC) charged-defect finite-size 보정의 **신뢰도 판정 기준**.

**판정 기준 (모두 충족해야 채택):**
1. **MZPOT ≈ DZPOT** (모델 vs DFT 전위 planar-average 일치) — corr ≥ 0.999, nRMSE < ~2%
2. **corrected formation energy가 진공/셀 크기에 수렴** (Δ 수 meV) — raw correction 값 자체가 아님
3. **독립 방법 교차일치** (slabcc ≡ SCPC, ~수 meV 이내)

**하지 말 것 / red herring:**
- **MZCHG vs DZCHG(전하밀도 모양) 불일치는 무시하라.** slabcc 공식 reference test(NaCl Cl-vacancy, v0.8.4)에서도 CHG nRMSE ≈ 0.23–0.29이고 D가 쌍봉(bimodal)이다. 정상 현상이며 기각 근거가 아니다.
- raw correction 값이 진공 따라 발산(−0.5→−1.25 eV)하는 것도 정상 — raw 에너지의 spurious image 발산을 상쇄하는 것이므로. corrected 값 수렴만 보면 된다.

**Why:** 보정 에너지 `E_iso − E_per − q·dV`는 전부 전위에서 계산됨. Poisson이 전하를 쿨롱 커널 1/r로 smoothing하므로 ρ의 단거리 디테일(모양·쌍봉)은 전위에서 사라지고, 장거리 전위는 총전하 ±q와 대략적 퍼짐에만 의존. 따라서 모양 틀린 Gaussian이라도 총전하·퍼짐만 맞으면 전위→에너지가 맞는다. 큰 charge_sigma(2.5–4.0)는 delocalized 전위 재현을 위한 올바른 반응.

**How to apply:** slabcc 결과 검증 시 DZPOT/MZPOT 오버레이 + corrected DFE vs cell-size plot을 보고, CHG 모양 불일치나 [warning] 문구에 과민반응하지 말 것. 단 [critical] discretization(σ 폭주로 grid 수렴 실패, 예: vac_30A optimized)로 abort하면 그 run은 못 씀 → fixed-position fallback 또는 더 큰 셀 사용.

**검증 사례:** [[project_inas-band-alignment-method]] 관련, Cl-As_In(+1) vertical transition. 여분전하가 양 표면에 delocalized(쌍봉)이라 CHG는 안 맞지만, POT corr=1.000/nRMSE 0.004, corrected DFE Δ(40→50Å)≈수 meV, slabcc≡SCPC ~6 meV → 채택 가능. 40–50 Å 기준(30 Å는 수렴 이전). 방법 간 잔여 스프레드 ~0.05–0.09 eV.
