---
name: surface-defect-1shot-band-workflow
description: "02-Cl-passv_6L_3x2x1_HSE06 워크플로우 config 검토 결과, spin test 결과, 본계산 진행 상황 (2026-06-30)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 0b838ed2-3a0f-4b92-a22c-131ab8936454
---

## 워크플로우 구성 (3단계)
- Stage 00: `00_Gam-relax` — vasp.gam, Gamma-only, 구조 이완
- Stage 01: `01_G221-1shot` — vasp.std, 2×2×1 G-centered, single-point SCF
- Stage 02: `02_Band` — vasp.std, IBZKPT+k-path 조합 KPOINTS, band structure

**대상 defect**: Cl-As_In (q0, q+1), V_Cl-Cl_As (q0), As_In (q0), pure (q0)

## 클러스터 설정
- partition: cascade2, 12 nodes × 32 cores = 384 total MPI
- Stage 01/02: KPAR=4, NCORE=16 → 384/4=96, 96/16=6 ✓ 정수

## KPOINTS_02.Band 구성
HSE hybrid band structure용 explicit format:
- IBZ 4개 k-점 (weight=1): Γ, X=(0.5,0,0), Y=(0,0.5,0), M=(0.5,0.5,0)
- k-path 18개 (weight=0): Y→Γ→X→M (각 6점, Δ=0.1)
- 총 22개 k-점

## Config 수정 사항 (이번 대화)
- `INCAR_00.Gam-relax`: `PREFOCK=Fast` → VASP6에서 무시됨, `PRECFOCK=Fast`가 올바름 (vasp.gam에서는 무관)
- `INCAR_02.Band`: `#NBANDS=400` 주석 → 해제 필요
- `runtime.yaml`: `defect_moment: 1.0 → 2.0`, `neighbor_moment: 0.5` 유지
- `runtime.yaml`: slurm partition=cascade2, nodes=12, ntasks_per_node=32 업데이트됨

## run_case.sh 주의사항
- 기존 run_case.sh는 stage 00만 포함 → prepare_defect_workflow.py 재실행 필요
- prepare 후 `stage_finished()` 로직: "General timing and accounting" 문자열 확인
- Cl-As_In/q0,q+1의 `01_G221-1shot`은 CHG-DIFF용 custom 계산이지만 finished=True → 02_Band로 자동 진행됨

## build_magmom_string 주의사항
- `type: vacancy`이면 `defect_atom_index`를 무시함
- V_Cl-Cl_As의 atom 95(Cl_As)는 실제로 구조에 존재 → run_spin_test.sh에서 vacancy 타입에 대해 defect_atom_index가 유효하면 defect_moment 별도 적용하도록 수정함

**Why:** vacancy type의 build_magmom_string이 defect_atom_index를 건너뛰는 설계 때문
**How to apply:** spin 계산 시 V_Cl-Cl_As 계열 vacancy에 유사한 이슈 주의
