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
- **V_Cl-Cl_As q0**: As자리에 Cl 치환(Cl_As, atom95=defect_atom_index)+passiv Cl공공. **gap 깨끗, 깊은 defect state 없음**. Cl_As는 shallow double donor(+2e): 자체 준위(Cl 3p ~-6eV, Cl 3s -19.8eV)는 VB 깊이, 공여전자는 **CBM 위 전도띠 채움**(진공정렬시 Fermi=pure CBM+0.86eV, 축퇴 n형). 비자성. ⚠초기 "gap 채우는 manifold/near-metallic" 서술은 진공정렬 전 오해였음(실제 CBM 위 CB 채워짐). 검증법: planar-avg LOCPOT 진공준위 정렬(plateau std<0.1eV)로 pure CBM과 비교.

**IPR 판별 지표 (2026-07-17 추가, PROCAR 원자료 검증)**: "이 charge state에 model-charge correction이 적용 가능한가"를 판정하는 기준. IPR = 원자별 투영weight의 역참여비, uniform = 1/96 = 0.0104.
| state | IPR | ×uniform | w[defect atom] |
|---|---|---|---|
| Cl-As_In q0 HOMO | 0.0946 | **9.2×** | 0.150 |
| Cl-As_In q+1 LUMO | 0.0696 | **6.7×** | 0.130 |
| pure LUMO (host CBM, 대조군) | 0.0128 | 1.2× | — |
| V_Cl-Cl_As q0 HOMO | 0.0128 | 1.2× | 0.0044 |
| As_In q0 LUMO | 0.0128 | 1.2× | 0.019 |
- **≥6× uniform = 국소 defect level → slabcc 적용 가능. ~1.2× = host 밴드 상태(PHS) → 어떤 model-charge 보정도 범주 오류.**
- 보조 지표 **E_relax**: 0.28~0.37 eV(국소) vs 0.01~0.05 eV(밴드류)로 10배 이산 갭. 전하가 host 밴드로 가면 반응할 국소 준위가 없어 이완이 사라짐.
- ⚠**As_In ≠ V_Cl-Cl_As** (뭉뚱그리지 말 것): V_Cl-Cl_As q0는 pure CBM+0.70eV 점유 **축퇴 n형**(→ CB에 캐리어 공여, n-type origin 후보). As_In q0는 **축퇴 n형 아님** — HOMO=VBM+0.13, gap 깨끗, donor 성분은 **비점유** CB(+1.58/+1.75eV, w≈0.10-0.13). 따라서 **As_In q+1 = donor ionization이 아니라 host VB 정공**(w[36]=0.0000). 둘 다 Gaussian 불가지만 물리가 다름.
- V_Cl-Cl_As "(+1/0) CTL"은 결함준위 이온화가 아니라 **CB 전자 제거(Burstein-Moss band-filling)** → gap 내 CTL로 보고하면 안 됨(삭제 대상). 관련: [[slabcc_delocalized_defect_policy]]

**도구 인덱싱 규칙(중요, 서로 다름)**:
- `zeroband.py`(03_Band): POSCAR **1-based**. proj 예 `--proj "36 tot"`, orbital `tot/s/p/d` 지원. `--fermi <E> --ylim lo hi --spin 1|2 --colors`.
- `bandos dos`(02_G221-DOS, ~/bin/hohen_bin/bandos): **0-based** (POSCAR N → `N-1` 전달!). 예 antisite As(POSCAR36)=proj `35`. 인자 `key=value`: `proj="35 tot" xlim="-1,3" ylim="-6,6" line="r,b" filename=out E0=<abs>`. 기본 E0=Fermi.
- DOS는 ISMEAR=-5+2×2×1 → gap 내부 tetrahedron 삼각형 아티팩트. defect level 판정은 밴드(zeroband) 우선.

관련: [[surface_defect_spin_screening_full]] [[vclclas_atom95_fatband]] [[surface_defect_1shot_band_workflow]]
