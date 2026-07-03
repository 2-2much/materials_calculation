---
name: defect_states_02_clpassv
description: 02-Cl-passv 6L-3x2x1 HSE06 defect state 정리(pure gap 1.19eV 기준) + bandos/zeroband 원자 인덱싱 규칙
metadata: 
  node_type: memory
  type: project
  originSessionId: 35c0f203-2148-495c-9517-4f0066cc3670
---

12-Surace-defect_calculation/02-Cl-passv_6L_3x2x1_HSE06 defect state 분석 (2026-07-03).
정리 결과: calc/__defect-states-summary__/ (README.md + 밴드/DOS png).

**기준**: pure slab HSE06 gap ≈ 1.19 eV (VBM=0 @Γ, CBM=+1.19 @Γ, gap 내 상태 없음).

**결론(각 셀 VBM 기준 상대값; cross-cell 절대비교는 bulk-PBAND alignment 필요)**:
- **As_In q0**: 깊은 gap 상태 없음. antisite As 성분은 VBM 아래 ~-0.4eV 공명 + CB. shallow/비자성.
- **Cl-As_In q0**: 자성 S=1/2. As36 국소 스핀분열 level — ↑점유 VBM위 ~+0.5eV, ↓비점유 ~+0.9~1.4eV. 안티사이트 라디칼. → ISPIN=2 필수.
- **Cl-As_In q+1**: 비자성. As36 비점유 level VBM위 +0.76~1.17eV(upper gap). (+1/0) donor.
- **V_Cl-Cl_As q0**: 단일 level 아님. As공공 dangling In-bond(이웃 In 28,30,33) defect 다발이 gap 채움. 실질 gap≈0.08eV, Fermi pinned(near-metallic). 비자성.

**도구 인덱싱 규칙(중요, 서로 다름)**:
- `zeroband.py`(03_Band): POSCAR **1-based**. proj 예 `--proj "36 tot"`, orbital `tot/s/p/d` 지원. `--fermi <E> --ylim lo hi --spin 1|2 --colors`.
- `bandos dos`(02_G221-DOS, ~/bin/hohen_bin/bandos): **0-based** (POSCAR N → `N-1` 전달!). 예 antisite As(POSCAR36)=proj `35`. 인자 `key=value`: `proj="35 tot" xlim="-1,3" ylim="-6,6" line="r,b" filename=out E0=<abs>`. 기본 E0=Fermi.
- DOS는 ISMEAR=-5+2×2×1 → gap 내부 tetrahedron 삼각형 아티팩트. defect level 판정은 밴드(zeroband) 우선.

관련: [[surface_defect_spin_screening_full]] [[vclclas_atom95_fatband]] [[surface_defect_1shot_band_workflow]]
