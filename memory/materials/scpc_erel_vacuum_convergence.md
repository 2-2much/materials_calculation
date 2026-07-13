---
name: scpc_erel_vacuum_convergence
description: "Cl-As_In q+1 relaxation energy E_rel(+1)=E(+1,Rq0)-E(+1,Rq+1) vacuum 수렴 테스트 결과 (20/30/40Å)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 332dc2ba-3479-4ec3-a90a-d68b93650ae7
---

12-Surace-defect_calculation/01-Cl-passv_6L_3x2x1/.../Cl-As_In/__SCPC-test__ 에서 q+1 relaxation energy의 vacuum 무관성 검증 완료 (2026-07-13).

**정의**: E_rel(+1) = E(+1, R_q0) − E(+1, R_q+1), 둘 다 bare(SCPC OFF)·동일설정·동일 vacuum.
- E(+1,R_q0): q+1_Rq0/ = q0/POSCAR(중성 이완구조) + NELECT=742 single-point
- E(+1,R_q+1): q+1_pre/ = 하전 이완구조 + NELECT=742 single-point

**결과**: 20Å=101.3, 30Å=109.0, 40Å=112.9 meV. spread(20-40)=11.7 meV, 증분 7.7→3.9 meV 단조감소 → 수렴값 ~0.113-0.115 eV. **판정: 수렴(vacuum-무관).**

**물리**: 절대 E(+1)는 monopole self-energy(∝q²)로 vacuum 커질수록 발산(20→40Å ~2.16eV씩)하나 R_q0/R_q+1 두 항에서 상쇄되어 E_rel은 발산 안 함 — 기대대로.

**주의**: vac_20/40 OUTCAR "EDIFF was not reached" flag는 cosmetic (마지막 dE 6.5e-7/9.0e-7 < EDIFF 1e-6, 마지막6스텝 <30μeV). meV 결론 무영향.

계산: g2 8노드×12, KPAR=4 (2x2x1=4 irred kpt), ENCUT300/ENAUG600/EDIFF1e-6/ISPIN1. 판정 스크립트 compute_Erel.py. ↔ [[scpc_vacuum_scan]] [[vertical_scan_slabcc_scpc]]
