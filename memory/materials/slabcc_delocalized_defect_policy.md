---
name: slabcc_delocalized_defect_policy
description: delocalized(shallow/PHS) 표면 결함에 model-charge correction을 적용하지 않는 방침 + 판정 기준 + E_corr=0 조용한 fallback 버그
metadata: 
  node_type: memory
  type: project
  originSessionId: 5c11235d-04bd-4ac0-b00c-45768164ae48
---

02-Cl-passv_6L_3x2x1_HSE06에서 slabcc가 As_In·V_Cl-Cl_As에 실패하는 건 **버그가 아니라 물리**다 (2026-07-17, 3-에이전트 교차검증).

**원칙**: 전하가 host 밴드 상태(PHS)에 있으면 어떤 model-charge 보정도 **범주 오류**다. 면내로 균일해지는 극한은 하전 시트이고 **무한 시트의 E_isolated는 발산** → slabcc의 (E_iso − E_per) 스킴 자체가 정의되지 않는다. "vacuum이 있으니 z error를 어떻게든 보정해야 한다"는 전제가 틀림 — shallow donor의 DFE는 전자를 CBM에 놓고 평가하는 것. SCPC 원논문(Deák, PRL 126, 076401 (2021))도 명시: *"a posteriori corrections do not yield reasonable results, since a substantial part of the charge is fully delocalized."*

**판정 기준** (판별자는 σ가 아님 — 잘 맞는 Cl-As_In q+1이 σ 2.29로 오히려 최대. σ는 V_Cl-Cl_As의 5.36Å=셀42% 같은 명백 붕괴에만 유효):
1. **IPR** — 상세 표는 [[defect_states_02_clpassv]]. ≥6× uniform=국소(적용가능), ~1.2×=host 밴드(불가). [[vclclas_cohp_donor_evidence]]의 COHP가 독립 확인(pure CBM IPR=defect IPR=0.0128).
2. **E_relax** — 0.28~0.37eV(국소) vs 0.01~0.05eV(밴드류), 10배 이산 갭.
3. **slabcc 자체 abort** — `optimize_charge_position=yes`로 돌리면 σ가 하드코딩 상한 7Å(src/slabcc_model.cpp:264)을 때리고 exit(1). 프로덕션의 `=no`는 전하를 결함 위치에 묶어 실패를 단순 RMSE 경고로 **강등시켜 숨김** → 별도 게이트 런으로 병행 권장.

**케이스별 결론**: Cl-As_In q+1만 신뢰(E_corr=0.109eV; position 풀어도 0.086 생존 → 23meV를 불확실도로 인용). Cl-As_In q+2=혼합(E_corr 0.376 < q²스케일 0.436 → 2번째 정공은 host VBM), q-1=미확정(trivariate 재시도 가치: z/면내 RMSE 비 ~3배가 전 케이스 일관=실재 이방성). As_In·V_Cl-Cl_As=폐기 후 shallow 재분류.

**⚠파이프라인 버그(미수정)**: slabcc 실패 → CSV `E_corr_eV` 공란 → `plot_DFE_from_raw_energies.py:92` parse_float("")=NaN → **383행이 조용히 ecorr=0.0으로 대체**, stderr 경고만 내고 산출물엔 안 남음. 결과: CTL_summary.csv에 **V_Cl-Cl_As +1/0 = 0.99eV, inside_gap=True**라는 가짜 준위 등재(E_corr=0 아티팩트 + 애초에 없는 준위). coverage의 `missing E_corr: 0`도 거짓(status=submitted라 pending 분류). → fallback 제거하고 drop/flag 필요.

**셀 확대는 해법이 아님**: `__a-dispersion-scan_PBE-d__/ANALYSIS.md` — 가장 국소적인 Cl-As_In조차 aDisp가 0이 아닌 ~0.24eV로 수렴(무한셀 극한). 정량값이 꼭 필요하면 SCPC(가우시안 가정 없음, Cl-As_In(+1)서 slabcc와 6meV 일치 [[vertical_scan_slabcc_scpc]]) 또는 CKT+lateral 외삽. 단 SCPC도 PHS면 "발산 안 하는 수"를 줄 뿐 물리를 구제 못 함. NK/pydefect_2d는 여전히 가우시안 모델 → dead end [[pydefect_2d_setup]].

**목표 관점** ([[cqd_ntype_origin_goal]]): 보정 실패는 손실이 아니라 **결론 그 자체**. CB에 캐리어를 공여하는 건 **V_Cl-Cl_As뿐**(축퇴 n형), As_In은 공여자 아님.
