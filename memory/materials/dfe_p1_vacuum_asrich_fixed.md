---
name: dfe_p1_vacuum_asrich_fixed
description: "Cl-As_In(+1) As-rich VBM 형성E 진공수렴(current+vac30/40/50 fixed slabcc): 0.379eV(vac≥40) 수렴, current 0.423 신뢰낮음(RMSE warn). vertical값→adiabatic은 -88meV"
metadata: 
  node_type: memory
  type: project
  originSessionId: 55454a3e-4350-4b63-a808-a64f68435f75
---

2026-07-14. `12-Surace-defect_calculation/01-Cl-passv_6L_3x2x1`에서 Cl-As_In q=+1의
**As-rich VBM 형성에너지 진공수렴** 계산+플롯(`results/DFE_plots/DFE_Cl-As_In_p1_vacuum_Asrich.py`
→ 동명 PNG). 4개 셀 **동일 스킴 통일**: optical/vertical charged 1shot(2×2×1, R_q0 고정)
+ pristine 완전슬랩(2×2×1) + **fixed-position** slabcc 보정(`optimize_charge_position=no`).

**공식**: `E_f = E_bare − E_pure + Δμ + q·VBM + E_corr` (slabcc E_corr에 −q·dV 정렬 내장, 이중가산 금지).
**As-rich**: μ_In=μ_InAs−μ_As=−3.0488 → **Δμ=μ_In−μ_As−μ_Cl=+3.4059 eV** (Δn: In−1,As+1,Cl+1;
μ_As=−4.669549, μ_InAs=−7.718334, μ_Cl=−1.78515).

**데이터 소스**:
- current(z=26.26, vac~11Å): E_bare=`Cl-As_In/q+1/01_optical_Rq0`=−346.12005, E_pure=`pure/q0/01_Relax`=−343.58714,
  VBM=−0.523229, E_corr=+0.07328(`results/corrections/slab_slabcc/Cl-As_In/q+1`).
- vac30/40/50: `calc/Cl-As_In/__vertical_scan__` summary.csv의 E_pure/E_bare/VBM +
  `__slabcc_vertical__/vac_XXA_fixed/slabcc.out` E_corr(−0.45503/−0.81520/−1.20335).

**결과 E_f(+1)@VBM (As-rich)**:
| 셀 | 진공 | E_f_raw | E_corr | **E_f_corr** |
|---|---|---|---|---|
| current | ~11 | 0.350 | +0.073 | **0.423** ⚠RMSE warn |
| vac30 | 30 | 0.839 | −0.455 | **0.384** |
| vac40 | 40 | 1.195 | −0.815 | **0.380** |
| vac50 | 50 | 1.582 | −1.203 | **0.379** |

**결론**: 무보정 raw는 진공↑ 선형발산(주기이미지 self-E), slabcc 보정 후 vac30/40/50=0.384/0.380/0.379로
**수렴(vac40→50 1.4meV)**. **수렴 형성E ≈0.38 eV(vac≥40Å 신뢰)**. current(vac~11Å)=0.423은 수렴값보다
~44meV 높고 E_corr 부호까지 반대(+)+RMSE 경고 → 얇은 진공서 여분전하 delocalize로 slabcc ill-defined,
**신뢰 낮음**.

**⚠ vertical→adiabatic**: 위 값은 vertical(optical, R_q0) 형성E. 완화 포함 adiabatic DFE는
E_relax(+1)=+88meV 만큼 낮아져 **≈0.29 eV**. VBM 순수비교는 위 표, 열역학 최종 DFE는 −88meV.

관련: [[vertical_scan_slabcc_scpc]] [[slab_correction_workflow]] [[scpc_vacuum_scan]] [[slabcc_optimize_tolerance]] [[cqd_ntype_origin_goal]].

---
## ⚠⚠ 2026-08-19 폐기 — "최소 진공 40 Å" 은 틀린 결론이었다

사용자 확인: **하전 결함은 진공 15 Å 에서도 진공길이에 대해 올바르게 수렴한다.**
[[vacuum_scan_vbm_reference_trap]] (2026-07-22, 더 나중·더 정밀) 이 원인을 분리해 놓았다:

- **보정(slabcc/SCPC) 자체는 13.5 Å 에서 이미 수렴**한다.
- 얇은 진공에서 "발산"처럼 보였던 것은 **기준 레벨(gauge)** 이다. VASP 고유값은 셀-평균
  정전퍼텐셜 기준이라 진공을 늘리면 전 고유값이 통째로 이동한다(원시 VBM 2693 meV 이동,
  진공준위 기준 VBM 은 39 meV 만 이동 = **98.5 % 가 gauge**).
- 따라서 **`q·E_VBM` gauge 항과 pure↔defect `ΔV` 정렬을 제대로 넣으면** 얇은 진공에서도 맞는다.
  이 두 항을 빼먹으면 수렴한 보정이 1 eV/step 실패처럼 보인다.

즉 이 문서의 "권장 최소진공 40 Å" 은 **그 두 항을 분리하기 전의 판단**이고 폐기한다.
진공을 늘려야 하는 진짜 이유가 있다면 그것은 보정 수렴이 아니라 다른 것(예: 리간드 머리 공간)이다.
