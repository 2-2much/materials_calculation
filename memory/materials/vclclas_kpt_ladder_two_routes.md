---
name: vclclas_kpt_ladder_two_routes
description: "02 V_Cl-Cl_As PBE-d k-사다리(1~10 kpt) — Γ+PHS와 mesh−LZ 두 경로가 4.5 meV로 일치, 잔차 0.12 eV는 k·functional 무관(하전 유한크기). 도너 전자를 밴드 인덱스로 세면 안 됨"
metadata: 
  node_type: memory
  type: project
  originSessionId: ad99f4fe-653c-4334-94a6-19f7a46a69b2
  modified: 2026-07-23T11:11:20.418Z
---

2026-07-23. `02-Cl-passv/calc/__k-point_test__/Vcl_neutral_PBEd/` 에 **q+1과 k2x2x1_MP를 추가**해
ε(+1/0)의 k-수렴을 끝까지 측정. 사다리 = k1x1x1 / k2x2x1_MP / k2x2x1_G / k3x3x1_G / k4x4x1_G.
PBE-d 1shot, q0 Γ-이완 기하 고정(q+1도 **같은 기하**, 이완 12.5 meV는 의도적 배제),
ISPIN=1, ISMEAR=0 σ=0.05, ENCUT300, PREC=N, 격자 pinned, NBANDS=440.

## 핵심 결과 — 두 경로가 만난다
`ε = E(q0) − E(q+1) − E_VBM` (**pure는 E_VBM으로만 들어감** → CTL 테스트에 pure 총에너지 불필요)

| 경로 | 보정 ε | **CBM 기준** |
|---|---|---|
| A: Γ-only + PHS | 0.2615 | **−0.1258** |
| B: 2×2×1_G − LZ | 0.2954 | −0.1241 |
| B: 3×3×1_G − LZ | 0.2992 | −0.1248 |
| B: 4×4×1_G − LZ | 0.3037 | −0.1213 |

**k점 1→10개에서 CBM 기준 거리가 −0.124 ± 0.002 eV로 고정.** 항등식 실증됨.

## 잔차 0.12 eV = 하전 셀 유한크기 (k도 functional도 아님)
- PBE-d **−0.121** ↔ HSE(Γ+PHS, 1.136 vs gap 1.2505) **−0.115**. **갭이 3배 다른데 11 meV 일치**
  → 갭 의존 아님 = 정전기적 유한크기 지문. 진공 14.6 Å(하한 40~50), slabcc는 이 결함 거부.
- 고칠 방법은 lateral 셀 확대·진공 확대이지 mesh·functional 아님.

## ⚠ raw k-refinement은 답을 **악화**시킨다
raw ε: 0.211(Γ) → 0.601 → 0.730 → 0.723, gap 0.425 → **CBM을 0.30 eV 넘어섬**.
Γ-only의 band-filling은 **0이 맞다**(전자가 밴드 바닥). mesh를 켜면 폭 **1.10 eV** 밴드를 타고
올라가 CBM 위 0.42로 감. E_bf 부호: Γ **−0.050**(PHS 가지, E 올림) / mesh **+0.31~+0.43**(MB 가지, E 내림).
→ "Γ-only라 kink 생겼다" 가설 **기각**. [[cl_as_shallow_donor_kink_diagnosis]] 결론과 동일.

## ⚠도너 전자를 **밴드 인덱스로 세면 안 된다**
도너 상태는 host-CBM 유래라 BZ에서 1.1 eV 분산 → **다른 밴드와 교차, 인덱스가 k에 따라 안 고정**.
밴드 370만 세면 2×2×1_G·3×3×1_G에서 **1.00 중 0.83개만** 잡힘(Γ·4×4×1은 1.00/0.99라 **사다리
양 끝에서 오차가 숨는다**). 해법 = **중간갭 위 모든 점유 상태 적분**(인덱스 free, LZ 정식형).
고친 뒤 N_don=1.000 전 mesh. 점유>1e-3로 frontier 찾는 것도 금지(σ 꼬리가 윗밴드 오염 → PHS 부호 반전).

## MP/Baldereschi 평가 — 보정과 **함께** 쓰면 유효
- raw `E(q0)−E(q+1)`: MP +0.650 vs 수렴 +0.480 → **0.17 eV 이탈**(2점이 둘 다 E=0.784 축퇴, Fermi면 미분해).
- **LZ 보정 후 ε=0.2912 = 4×4×1 대비 13 meV.** E_bf(+0.601)가 이탈분을 상쇄(같은 물리량이므로).
- 즉 "MP는 이 결함에 못 쓴다"는 **보정 없이 쓸 때만** 참. k점 2개로 10개 답 재현.
- ⚠Γ 미포함이라 밴드모서리 불가 → 사용자 지시로 **k4x4x1_G pure VBM 차용**(그 행만 두 quadrature 혼재).
- 대조: Cl-As_In(`__CHG-DIFF__/kpt_scan`)은 평탄 deep 밴드라 bald≡MP 0.12 meV. **전이 안 됨**.

## k2x2x1_G는 버릴 것
Γ + BZ 모서리 3점 = 정확히 밴드 극값만 샘플링. Cl-As_In 절연체 q+1에서 bald/MP 대비 **165 meV** 이탈.
HSE에서 **가장 비싼 rung**이기도 함(측정 16노드 s/step: Γ-gam 4.4 / MP 31.5 / 2×2×1_G **243**).
3×3×1_G는 홀수라 이 병리 없고 Γ 포함, PBE-d에서 4×4×1 대비 7 meV.

## DFE (μ_In=−2.561, μ_As(A7)=−4.6695, μ_InAs=−7.718 → ΔH_f=−0.4875)
V_Cl-Cl_As는 Δn={In:0, **As:−1**, Cl:0} → **μ_Cl 무관**, μ_As만. 4×4×1: E_f(q0) **−1.139**(In-rich)
/ **−0.652**(As-rich), 두 극한 차 = ΔH_f. 부호 규약은 자체 bulk로 검증(V_As가 In-rich에서 낮음 ✓).
음수 E_f는 버그 아니라 **reference 슬랩 비바닥상태** 문제 재확인 → [[cl_as_negative_eform_reference_slab]].

## 도구
- `scripts/analyze_kpt_conv_ctl.py` — 사다리 수확 + 두 경로 대조표
- `scripts/plot_DFE_kpt_conv_PBEd.py` — mesh별 DFE 그림(`--mesh all`)
- `scripts/build_kpt_conv_neutral.py` — MP rung·q+1(NELECT=738) 추가, **완료 런 입력 미덮어쓰기 가드**

관련: [[bandfilling_measured_from_dos]], [[shallow_donor_inas_supercell_limit]],
[[shallow_limit_dfe_construction]], [[slabcc_delocalized_defect_policy]]
