- [Defect 계산 폴더 구조](project_defect-calc-folder-structure.md) — calc/{defect}/{charge}/01_Relax→02_Band 패턴, config/inputs/scripts 분리
- [Surface defect POSCAR 생성](project_surface-defect-poscar-generation.md) — In_As, V_In, V_As, In_i, As_i 5종 생성 완료, Td_In site(z=0.630) 사용, /make-surface-defect 스킬
- [slabcc correction Cl_As_In](project_slabcc-correction-Cl-As-In.md) — 3가지 시도(single/multi/fixed) 모두 부적합, E_corr=0.018~0.079 eV, Falletta 필요
- [slabcc z-shift 주의](feedback_slabcc-z-shift.md) — slabcc가 slab_center 기준으로 출력 CHGCAR z좌표를 shift함
- [보고서 grid 보간](feedback_report-grid-interpolation.md) — DFT/model z-grid 다르므로 np.interp 필수
- [MPI hang 사건](project_mpi-hang-incident.md) — 2026-06-23 In_As q0 Relax, PMPI_Alltoallv 교착(n001), 서버 관리자 보고 필요

## 작업 방식 / 피드백
- [cli naming preference](feedback_cli-naming-preference.md) — CLI 인자 명명 규칙 — --mu_In 스타일 선호, YAML config보다 CLI 선호
- [make surface defect skill redesign](feedback_make-surface-defect-skill.md) — /make-surface-defect 스킬 재설계 — 사용자 인자 기반 실행, 대화형 질문 제거, 다중 원자 조작 지원 필요
- [scpc vasp workflow](feedback_scpc-vasp-workflow.md) — VASP SCPC 및 slabcc 실행 시 반드시 지켜야 할 설정(바이너리·REF파일·WAVECAR·tolerance)

## 연구 / 프로젝트
- [chemical potential cli](project_chemical-potential-cli.md) — plot_DFE_from_raw_energies.py 화학퍼텐셜 CLI를 --mu_X + --conditions 방식으로 일반화 완료
- [cl chemical potential](project_cl-chemical-potential.md) — Cl₂ 분자 PBE 화학퍼텐셜 계산 결과 (ENCUT 300/400 비교)
- [collect contcars stage fallback](project_collect-contcars-stage-fallback.md) — collect_contcars.py는 runtime.yaml의 preferred_geometry_stages 순서대로 CONTCAR를 탐색 — 00_Gam-relax fallback 추가함
- [git remote and skill setup](project_git-remote-and-skill-setup.md) — 01-Cl-passv_6L_3x2x1 프로젝트의 git remote 정보와 /make-surface-defect 스킬 복사 이력
- [pending defect generation](project_pending-defect-generation.md) — 추가 생성 예정인 3종 surface defect — In_i_Td_As, V_Cl-V_In, V_Cl-Cl_In (스킬 재정비 후 진행)
- [vertical transition correction](project_vertical-transition-correction.md) — Cl-As_In(+1) vertical-transition charged-defect correction — slabcc≡SCPC 검증 진행상태/재개 지점

## 참고 자료
- [slabcc charge sigma trivariate](reference_slabcc-charge-sigma-trivariate.md) — slabcc charge_sigma가 하나만 나오는 이유(등방성 단일 가우시안) + surface defect에서 charge_trivariate on/off 판단
