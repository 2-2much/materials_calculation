---
name: adiabatic_dfe_algorithm_plan
description: "Surface defect thermodynamic(adiabatic) DFE 파이프라인 알고리즘 설계 방향 — (A)geometry완화 방식 확정, 전 donor 적용, 미해결 결정지점 4개"
metadata: 
  node_type: memory
  type: project
  originSessionId: 4fba7634-1b55-4ac3-bb55-ae75b0102813
---

12-Surace-defect_calculation에서 passivated InAs slab의 **thermodynamic(adiabatic) DFE**를 구하는 파이프라인 **알고리즘 설계 단계**(2026-07-13). 계산 아직 안 시작, 알고리즘만 고민 중. 다음 세션 재시작 후 **플랜모드**로 이어서 설계 예정.

**확정된 방침**: "thermodynamic 고려" = **(A) geometry 완화 방식**(각 charge state를 자기 relaxed geometry로 → adiabatic CTL). vertical(고정 R_q0)이 아님. **전 donor 후보(As_In, In_i, Cl_i/Cl_As, Cl-As_In 등)에 일괄 적용**이 목표. 목적=n-type origin 규명(shallow donor CTL 판정), [[cqd_ntype_origin_goal]].

**핵심 구조 사실**:
- relax 파이프라인은 **이미 charge state별 adiabatic** — stages.yaml `dynamic_incar:[NELECT,SPIN_MODE]`로 각 (defect,q) 독립 완화 → E_tot(D,q) 이미 산출됨.
- [[vertical_scan_slabcc_scpc]]는 correction **방법론만 확정한 별도 서브스터디**(slabcc≡SCPC 6meV, 진공≥40Å). 지금 설계할 것 = relaxed 총에너지 위에 얹는 **correction + assembly 레이어**.
- 조립식: `E_f(D,q;E_F)=[E_tot(D,q)+E_corr(q)]−E_pure+Σn_iμ_i+q(VBM_pure+ΔV+E_F)`
- CTL: `ε(q/q')={[E_tot+E_corr]_q−[E_tot+E_corr]_q'}/(q'−q)−(VBM_pure+ΔV)`
- **μ·E_pure는 charge state 간 상쇄 → CTL은 μ-diagram과 무관**. μ는 E_f 절대높이·지배donor에만. ∴ 알고리즘을 **CTL계산(μ불필요) / E_f절대화(μ코너)** 2단 분리 권장. VBM ref 규칙은 [[charged_defect_vbm_ref]].

**미해결 알고리즘 결정지점 4개(다음 세션 논의 대상)**:
1. **geometry seeding** — 각 q가 다른 local min으로 완화(In_i ejection [[in_i_2_adatom_ejection]], As_In 큰완화). q0먼저→다른q는 R_q0(+R_{q±1})에서 seed→최저E 채택.
2. **shallow/resonant correction 붕괴**(가장 크리티컬, n-type 직결) — resonant donor는 δρ 안잦아듦 → 국소전하 slabcc/SCPC 깨짐 + band-filling(Moss-Burstein) 필요. delocalization 감지기(δρ국소성/gap-state점유) → localized vs shallow(정렬만/외삽) 분기 로직 필요. deep/shallow가 donor마다 섞임.
3. **cross-defect 공통기준** — 전 defect 동일 셀/진공(≥40Å)/ENCUT/VBM_pure+vacuum bridge 공유해야 절대비교 성립. ⚠ENCUT=300은 In 4d(PBE-d)엔 낮음(절대값 비교 전 통일 필요).
4. **E_corr 재계산 vs 재사용** — R_q0→R_q charge center 이동 작음 → vertical E_corr 재사용 가능성(엄밀 vs 비용).

config: `01-Cl-passv_6L_3x2x1/config/`(defects.yaml charge_states·delta_atoms, stages.yaml, correction.yaml). 관련 [[scpc_vacuum_scan]] [[defect_states_02_clpassv]].
