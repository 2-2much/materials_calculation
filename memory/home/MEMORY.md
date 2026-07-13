## 유저 정보
- [User role](user_role.md) — Computational materials scientist, VASP DFT, InAs surface defects, Korean speaker

## 인프라 / 프로젝트 구조
- [서버 동기화 & 프로젝트 구조](project_infra-sync.md) — materials/papers 분리, kohn/sham/bloch/tgm-master Git 동기화, papers 메모리 동기화 추가

## 연구 (DFT 계산)
- [InAs surface defect Fig.8](project_inas-surface-defect-fig8.md) — Reproduce PRB Fig.8 (VBM & DFE vs concentration) for In_i^{+1}, bare vs CKT
- [Band alignment method](project_inas-band-alignment-method.md) — Use bulk-PBAND alignment instead of LOCPOT for delta_V in charged defect DFE
- [SCPC DFE 공식](project_scpc-dfe-formula.md) — SCPC correction 적용 시 pure cell VBM 사용, SCPC PA는 charged↔neutral만 포함
- [SCPC vacuum scan](project_scpc-vacuum-scan.md) — SCPC Table II 재현, vacuum 두께별 Cl-As_In(+1) formation energy, VBM 추출법
- [slabcc correction validity](project_slabcc-correction-validity.md) — Judge by MZPOT≈DZPOT + corrected-DFE convergence + slabcc≡SCPC, NOT CHG shape
- [slabcc mechanics](project_slabcc-mechanics.md) — E_isolated = MODEL-only scaled-cell linear-fit extrapolation; DIEL.dat plot vs row-index
- [전이레벨 FC 분해](project_transition-level-fc-decomposition.md) — relaxed 결함: ε_therm = ε_opt(vertical+E_corr, ε_∞) − E_rel(+1); E_rel은 q=+1 고정 R_q0→R_q+1 차이
- [E_rel vacuum 테스트](project_erel-vacuum-test.md) — E_rel(+1) vacuum-무관 실증(진행중), __SCPC-test__/q+1_Rq0 세팅, SCPC-test 폴더 의미
