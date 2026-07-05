---
name: charged_defect_vbm_ref
description: "하전결함 형성E의 VBM reference 개념 — pure VBM+ΔV=far-field host VBM(≠defect HOMO), SCPC align≠VBM align, vacuum bridge, IP 검증"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 0356f79b-9d29-4523-9dbb-a80e6d25376b
---

하전결함 형성에너지 `E_f(q)=E(D,q)−E_pure+Δμ+q·(VBM+E_F)+E_corr[+q·ΔV_align]`의 **VBM reference** 개념 정리 (Cl-As_In __vertical_scan__ 논의에서 확립, [[vertical_scan_slabcc_scpc]]).

**① VBM reference = pure(pristine) VBM eigenvalue.** neutral defect cell의 실제 VBM(HOMO)이 아님 — 그건 defect state로 오염됨(이 계는 defect level이 HOMO). pipeline도 `pure/EIGENVAL`에서 뽑아 씀(collect_results.py:88,97).

**② `VBM_pure + ΔV_align`의 정확한 의미**: defect cell 안에서 **결함에서 멀리 떨어진 far-field(벌크유사) 영역의 host VBM**과 같음. 분해식:
`neutral defect cell VBM(HOMO, 전역) = VBM_pure + ΔV_align + δ_defect`.
- ΔV_align = 평균 정전퍼텐셜 rigid shift만 담음 → far-field host 밴드끝 복원.
- δ_defect = 결함의 전자구조 섭동(gap state, defect level, hybridization) → ΔV에 안 담김.
- ∴ far-field host VBM 의미면 "= pure VBM+ΔV" 맞고, defect cell 실제 HOMO 의미면 δ만큼 다름. `pure VBM+align`을 쓰는 이유가 δ 오염 배제. 전제(far-field host 회복)의 근거=결함 섭동의 공간감쇠(localized perturbation). flat band=defect level(비분산), host VBM=dispersive 벌크밴드로 구분.

**③ SCPC align ≠ VBM align (핵심 함정)**: SCPC REFPOT=neutral defect cell LOCPOT → SCPC의 Energy Correction·Potential Alignment는 charged→neutral-defect **평균 정전퍼텐셜** 정렬(VBM/밴드끝 아님). 따라서 pristine VBM을 쓰려면 **neutral-defect ↔ pristine 정렬(q·ΔV)을 별도 산출**해야 함(SCPC가 안 줌). reference 사슬: charged →(SCPC)→ neutral-defect →(별도 vacuum bridge)→ pristine VBM.

**④ slab에서의 bridge = vacuum-level 정렬**. 진공층이 공통 zero. 검증=물리 IP(=ΔE_vert+Vvac)가 알려진 값과 정합. ⚠단 InAs 실험 IP와 정량 대조는 안 함(리포트는 "범위와 정합" 정성). InAs χ~4.9eV, Eg~0.35eV → bulk IP~5.3eV vs 계산 5.879eV(~0.5eV 높음, PBE 오차). 엄밀검증하려면 같은 셋업으로 pristine slab IP 직접계산 권장.

**⑤ delocalization 주의**: Cl-As_In은 resonant donor라 +1 보정전하 δρ가 안 잦아듦 — 이는 correction charge 국소성 문제지 VBM(valence edge)은 far-field host-like 유지. PBE gap 0.24eV 과소평가 → 절대 밴드위치·resonant 판정 HSE06 재확인 필요.

플롯: `__vertical_scan__/dfe_vbm_absolute.py` → `DFE_Cl-As_In_VBMref_absolute.png` (VBM기준 절대 E_f vs E_F, As/In-rich band). ε(0/+1)=VBM+0.81 (CBM 위 → resonant, gap 전구간 +1 안정).
