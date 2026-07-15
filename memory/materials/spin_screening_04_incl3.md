---
name: spin_screening_04_incl3
description: "04-InCl3-passv HSE06 spin screening — 11개 q0 defect magnetic_seed로 01_Spin-gam-relax 제출, 완료 후 ΔE_spin=E(01)−E(00) 비교"
metadata: 
  node_type: memory
  type: project
  originSessionId: 603463df-407a-4363-8755-ae564e5339de
---

2026-07-15, kohn(TGM SLURM). `12-Surace-defect_calculation/04-InCl3-passv_6L_4x2x1_HSE06`에서
**spin에 의한 에너지 변화 스크리닝** 착수. 방법: 00_Gam-relax(nonmag, ISPIN=1) → 01_Spin-gam-relax
(ISPIN=2, magnetic_seed) 두 stage TOTEN 비교. **ΔE_spin = E(01_Spin) − E(00_Gam) < 0 이면 magnetic ground state.**

**셋업:**
- `config/runtime.yaml` spin_mode.mode: `nonmagnetic` → **`magnetic_seed`** (ISPIN=2, MAGMOM 동적 시드:
  defect_moment 2.0 + neighbor_moment 2.0, rcut 3.0Å; pure는 128*0). INCAR_01.Spin-gam-relax는 ISPIN=2
  하드코딩 + ISTART=1/ICHARG=1(00의 WAVECAR/CHGCAR restart).
- prepare(missing-stage)로 11개 q0에 01_Spin-gam-relax 생성. HSE06 AEXX=0.27, ENCUT300, gam bin.
- SLURM 노드 8→**5로 축소**(runtime.yaml + 각 run_case.sh sed) — cascade2 idle 5개 활용. run_joblist.sh submit.
- 제출 완료(jobid 55291~55301): pure 실행, 나머지 대기. ⚠SLURM 잡은 harness가 완료통보 안 함.

**00_Gam-relax(nonmag) baseline TOTEN(eV):** pure −565.98900, As_In −567.39802, Cl-As_In −570.28470,
Cl_i-As −568.97843, Cl_As_1 −562.94316, Cl_As_2 −561.98881, In_As_1 −561.77122, In_As_2 −561.01430,
In_i_2 −568.59235, V_As −558.08658, V_In −560.03042. (전부 수렴+WAVECAR 있음.)

**기대:** [[surface_defect_spin_screening_full]](02-Cl-passv)에서 자성=Cl-As_In(−171meV), V_Cl-Cl_In(−268meV);
04에서도 이들 위주 확인. 완료 후 자성 defect는 ISPIN=2 유지, 비자성은 되돌릴지 판단. 관련
[[surface_defect_gam_relax_spin_comparison]], [[slab_correction_workflow]](같은 04 폴더 slabcc 셋업).

**04 폴더 특성:** origin remote 제거됨, scripts는 Defect_Package symlink(공유 NFS). 상세 [[slab_correction_workflow]].
