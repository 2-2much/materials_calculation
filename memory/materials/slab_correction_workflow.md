---
name: slab_correction_workflow
description: Defect_Package에 추가한 slab(2D) charged-defect slabcc correction 워크플로우(adiabatic/optical R_0 스킴)
metadata: 
  node_type: memory
  type: project
  originSessionId: ad694f23-8455-48ed-a222-c56e9af6285d
---

2026-07-14 Defect_Package(/mnt/hohenberg/byuid/jaegwan97/scripts/Defect_Package)에 slab(2D)
charged-defect finite-size correction 워크플로우를 추가함. 백엔드=**slabcc만**.

**물리 스킴(adiabatic vs optical, bulk/slab 아님):** 표면 relaxation이 커서 δρ=ρ(q,R_q)−ρ(0,R_0)가
delocalize→slabcc 깨짐. 해결: 고정 기하 R_0(=q0 이완 기하)에서 optical single-point로 δρ를 국소화.
항등식 `E_form,corr(q,R_q) = E_form(q,R_q) + E_corr(q,R_0)` (E_relax 해석적 상쇄). 따라서 plot_DFE에
raw(이완 total)+optical slabcc CSV만 넣으면 최종 adiabatic DFE. **diel_in=ε_∞(전자, 12.3)** 필수
(R_0는 이온 고정 vertical→ε_0 쓰면 이온 스크리닝 이중계산; 이온응답은 DFT E_relax가 담당).

**추가/변경 파일(커밋됨, 로컬만):**
- `scripts/prepare_defect_workflow.py`: stage에 `poscar_from: reference_charge_contcar`(+`reference_charge`,
  `reference_stage`) 분기. 형제 charge(q0)의 relaxed CONTCAR를 POSCAR로 복사(guard 포함). bulk 무영향.
- `scripts/run_slab_corrections.py`: slabcc 드라이버. optical/neutral 폴더의 LOCPOT+CHGCAR로 slabcc.in
  자동생성(slab_center/interfaces=z-범위, charge_position=defect center; vacancy는 reference_neighbors
  평균), SLURM 1노드 OMP 제출(멱등), slabcc.out 파싱(`E_iso-E_per-q*dV`), plot_DFE 호환 CSV.
- `config/slab_correction.yaml`(slabcc.in 파라미터+실행/안전), `correction_slab.sh`, `README_SLAB_CORRECTION.md`(한국어).

**최종 CLI(단순화됨):** 필수 `--charged-stage`(charged LOCPOT/CHGCAR 폴더)만. 선택 `--neutral-stage`
(생략 시=charged-stage; relax stage로 주면 q0 relaxed 밀도 재사용해 q0 optical 재계산 회피), 선택
`--relax-stage`(QA 지표 E_relax용, correction엔 불필요). `--reference-charge`는 제거(neutral은 항상 q0
고정, NEUTRAL_CHARGE=0). slabcc.out의 정렬 −q·dV는 이미 포함→따로 더하지 말 것. vacuum 스캔 없음
(R_0/R_q 동일 c축). 결과물은 results/corrections/slab_slabcc/<defect>/<q>/에 생성(입력은 calc/ 절대경로 참조).

**검증(구현 시점, VASP 재실행 없이):** parser가 Cl-As_In q+1 40Å의 −0.858935 eV 정확 파싱+deloc 경고 감지;
자동 slab_center=0.5000/interfaces=0.3633·0.6367가 기존 수동값과 일치; prepare cross-charge run_case.sh
정상(guard 포함). bulk 회귀 없음.

**커밋:** a96bc03(cross-charge geometry), a05ae8b(driver), fb414bf(CLI 단순화), 298cec6(--reference-charge 제거),
6ef61be(q0 optical skip/symlink), e4e5a16(slabcc bool→yes/no), a54cc39(slurm 부분블록 deep-merge로 modules 유지).

**end-to-end 실검증(2026-07-14, 01-Cl-passv Cl-As_In):** prepare(optical stage)→VASP optical single-point
(g2 8노드)→slabcc(g2 1노드 OMP)→CSV까지 완주. 실사용서 버그 2개(e4e5a16 bool, a54cc39 slurm merge) +
사용자 slab_correct.sh의 --charged-stage dirname(optical_Rq0→01_optical_Rq0) 잡음. 이 프로젝트 stage 이름:
relax=01_Relax(LOCPOT/CHGCAR 있음, ENCUT300), charged optical=01_optical_Rq0. neutral=q0/01_Relax 재사용
(--neutral-stage 01_Relax). **결과 Cl-As_In q+1: E_corr=+0.073 eV(RMSE 경고→신뢰낮음), E_relax=+0.088 eV(정상).**
vertical_scan −0.86(optimize_charge_position=yes)과 큰 차이=여분전하 delocalize(양쪽 다 경고)→slabcc Gaussian
모델 부적합, resonant/shallow donor 그림과 정합. 도구는 검증됨; 이 결함은 보정 자체가 ill-defined.

**사용처:** 12-Surace-defect_calculation/01-Cl-passv_6L_3x2x1 (scripts는 패키지 symlink, config는 복사본
→ slab_correction.yaml 복사+stages.yaml에 optical stage 추가 필요). relax stage=`01_Relax`. 관련 배경은
[[cqd_ntype_origin_goal]], [[vertical_scan_slabcc_scpc]], [[scpc_erel_vacuum_convergence]],
[[adiabatic_dfe_algorithm_plan]] 참조.

**q0 optical skip(구현됨, 6ef61be):** reference charge(q0)의 optical stage는 reference_stage(01_Relax)와
동일 계산이므로, run_case.sh가 reference_stage에 완료 OUTCAR+LOCPOT+CHGCAR가 있으면 VASP 건너뛰고
symlink 재사용(없으면 정상 실행). grid는 charged optical과 일치해야 함(드라이버 on_grid_mismatch가 방지).
