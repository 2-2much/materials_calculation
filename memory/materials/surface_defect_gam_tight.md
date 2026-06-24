---
name: surface-defect-gam-tight
description: InAs (110) surface defect 00_Gam-relax EDIFFG -0.02→-0.01 tightening 작업 (2026-06-24)
metadata: 
  node_type: memory
  type: project
  originSessionId: 4b38a661-c729-4ba3-9bac-a210765574d3
---

## 작업 내용
`12-Surace-defect_calculation/01-Cl-passv_6L_3x2x1/calc/` 내 12개 defect의 00_Gam-relax를 EDIFFG=-2E-2 → -1E-2로 tighten하여 continuation 계산.

**Why:** Force convergence를 더 타이트하게 하여 정확한 relaxed geometry 확보.

**How to apply:** 후속 01_Relax, 02_Band 단계 진행 시 새 CONTCAR 기반으로 진행해야 함.

## 셋업 상세
- 기존 결과 → `00_Gam-relax_bak/` (OUTCAR, OSZICAR, POSCAR, CONTCAR, vasprun.xml, std.log)
- `00_Gam-relax/`: CONTCAR→POSCAR, EDIFFG=-1E-2, WAVECAR/CHGCAR 유지 (restart)
- config 템플릿 `INCAR_00.Gam-relax`도 -1E-2로 업데이트됨
- `run_gam_tight.sh` — 00_Gam-relax만 실행 (01_Relax 진행 안 함)
- `submit_gam_tight.sh` — 일괄 제출 스크립트

## 대상 defect (12개)
As_In/q0, As_i_Td_In/q0, Cl-As_In/q0, Cl-As_In/q+1, In_As/q0, In_i_Td_As/q0, In_i_Td_In/q0, pure/q0, V_Cl-Cl_As/q0, V_Cl-Cl_In/q0, V_Cl-V_As/q0, V_Cl-V_In/q0

## 제외
- In_i/q0, In_i2/q0 — 00_Gam-relax 없이 바로 01_Relax로 진행된 케이스

## 제출 상태
- 2026-06-24 sbatch 제출 완료 (Job ID 52329~52340, partition g1, 12 nodes each)
