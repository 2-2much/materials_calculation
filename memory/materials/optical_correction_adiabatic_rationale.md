---
name: optical_correction_adiabatic_rationale
description: 표면 결함 adiabatic DFE에서 finite-size 보정은 frozen-R_0 optical(E_corr^opt)을 채택하는 이유와 부기 항등식
metadata: 
  node_type: memory
  type: project
  originSessionId: 8ec154ea-8dbe-442b-aaac-d411ac965637
---

01-Cl-passv_6L_3x2x1 charged DFE 부기 확정(2026-07-15).

**최종식(adiabatic DFE):**
`E_f^adia(q,E_F) = E(q,R_q) − E_pure − Σn_iμ_i + q(E_VBM+E_F) + E_corr^opt`
- 에너지 본체는 완전 이완 하전 `E(q,R_q)`(=`01_Relax`)를 쓰고, **correction 항만** vertical 스킴의 `E_corr^opt`를 빌려온다.
- 항등식: `E(q,R_q) = E(q,R_0) − E_relax`, `E_relax = E(q,R_0)−E(q,R_q) ≥ 0` (CSV E_relax_eV=0.0883 for Cl-As_In q+1).
- 따라서 "vertical에서 E_relax 빼기" ≡ "이완 하전 에너지 직접 쓰기". **이중계산 금지**(01_Relax 쓰면서 E_relax 또 빼면 틀림).

**왜 E_corr^opt(frozen R_0)인가:**
- 정렬(alignment)이 깨끗: 하전(R_q) vs 중성(R_0) 직접비교는 기하 유발 퍼텐셜 shift가 정전 finite-size 항과 섞여 오염됨. R_0 고정 시 순수 정전항만 분리.
- 물리적 결정타(사용자 확인): **R_q에서 표면 이완이 매우 커서 charge density가 매우 delocalized** → adiabatic 보정(E_corr^adia)이 ill-defined(Gaussian 모델전하 부정확). frozen-R_0 optical이 신뢰가능한 보정.
- 근사 `E_corr^adia≈E_corr^opt`의 정당화: monopole(q²/εL)·유전환경이 이완 불변으로 보정을 지배, multipole 변화는 2차 효과.

관련: [[slab_correction_workflow]] [[dfe_p1_vacuum_asrich_fixed]] [[scpc_erel_vacuum_convergence]] [[vertical_scan_slabcc_scpc]]

**플롯 방침(2026-07-15):** 전체-defect 플롯=adiabatic만(--stage 01_Relax + optical correction CSV). 개별-defect 플롯=vertical(01_optical_Rq0, 점선)+adiabatic(01_Relax, 실선) 같은 E_corr^opt.
