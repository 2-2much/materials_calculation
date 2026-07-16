---
name: chargestate_optical_slabcc_setup
description: 02-Cl-passv charge-state 선택(neutral DOS Fermi 위치 기반)+optical 1shot/slabcc vertical correction 프로덕션 셋업. 노드/CPU·charge state는 유연하게.
metadata: 
  node_type: memory
  type: project
  originSessionId: a862c19a-13d3-4459-a360-f416072abbe3
---

12-Surace-defect_calculation/02-Cl-passv_6L_3x2x1_HSE06 프로덕션 셋업 (2026-07-16). **셋업 값은 고정 아님 — 아래 두 규칙으로 매번 유연하게 정한다.**

**규칙1 — charge state 선택 = neutral defective cell DOS의 Fermi level 위치.**
- E_F가 CBM 위 → `0,+1,+2` (전자 전도대 유출, donor). VBM 아래 → `0,-1,-2` (acceptor). gap 내부 → CTL 브래킷(예: `0,+1,-1`).
- ⚠판정에 필요한 계산-간 정렬은 **진공 준위 금지**(dipole correction off라 양면 진공 1.26 eV 비대칭·기울기). **슬랩 하부(결함 반대면, 전 셀 동일) In/As core 정전퍼텐셜(OUTCAR "average electrostatic potential at core")로 정렬** — dipole 무관, In/As ΔV가 ~1meV 일치로 교차검증됨. CLAUDE.md "bulk-PBAND 정렬 선호"와 부합.
- 이번 판정(pure VBM=−0.752/CBM=+0.440, gap 1.19eV 기준): V_Cl-Cl_As E_F=CBM+0.58→`0,+1,+2`; As_In E_F≈VBM(−0.02)→`0,+1,-1`; Cl-As_In E_F=midgap(VBM+0.51)→`0,+1,+2,-1`.

**규칙2 — 노드/CPU 설정 = 실제 쓰려는 노드의 코어 수 기준.** cascade2=32core/node였음. 그때 값: INCAR `NCORE=16 NSIM=32`(32/16=밴드당2그룹), runtime.yaml `ntasks_per_node=32 omp=1`, slab_correction.yaml `omp_num_threads=32 ntasks_per_node=32`. nodes 수(그땐 8)도 필요에 따라. **다른 노드 쓰면 그 노드 core 수로 다시 맞출 것.**

**optical 1shot / slabcc 워크플로우(config-driven):**
- stages.yaml: `00_Gam-relax`(charged relax) → `00_Gam-optical_Rq0`(vertical, frozen R_0). optical은 `poscar_from: reference_charge_contcar, reference_charge:0, reference_stage:"00_Gam-relax"` → prepare가 각 charged 폴더에 q0/00_Gam-relax CONTCAR(R_0) 복사, q0 자신은 relax LOCPOT/CHGCAR symlink 재사용.
- INCAR_00-Gam-optical_1shot: relax와 **grid-lock**(PREC=N/PRECFOCK=N/ENCUT=300) 필수 — slabcc가 LOCPOT/CHGCAR FFT grid 일치 요구. NSW=0, LVHAR+LCHARG=T, ISPIN/NELECT는 prepare 주입.
- 이번 프로덕션은 Gamma-only **nonmagnetic**(runtime.yaml spin_mode). 필요시 magnetic_seed로 전환.
- 이 워크플로우 스크립트(prepare_defect_workflow.py가 reference_charge_contcar 처리, run_slab_corrections.py)는 [[defect_package_repo]] GitHub(2-2much/Defect_Package) 최신을 계산폴더 scripts/로 복사해 씀. 로컬이 구버전이면 fetch 후 갱신.
- slabcc: `diel_in=ε_∞`(vertical이므로; InAs(110) 검증값 12.3, cf. [[vertical_scan_slabcc_scpc]] [[slab_correction_workflow]]). 실행: `run_slab_corrections.py --charged-stage 00_Gam-optical_Rq0`.

목표 맥락은 [[cqd_ntype_origin_goal]] [[adiabatic_dfe_algorithm_plan]].
