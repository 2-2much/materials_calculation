---
name: project_vertical-transition-correction
description: Cl-As_In(+1) vertical-transition charged-defect correction — slabcc≡SCPC 검증 진행상태/재개 지점
metadata: 
  node_type: memory
  type: project
  originSessionId: 0854a52a-fd0a-4222-920b-a19a6f22455b
---

Cl-As_In(+1) surface defect의 charged finite-size correction을 **slabcc≡SCPC 일치**로 검증하는 작업.
작업 디렉토리: `.../01-Cl-passv_6L_3x2x1/calc/Cl-As_In/__vertical_scan__/` (모든 스크립트/입력 여기).

**방법(사용자 확정):** "involving ionic polarization" 논문식. 중성(q=0) relaxed 지오 **R_q0에
원자 고정**, 전하만 바꿔(q'=0,+1) vertical transition → **ε∞=12.3**로 보정 → ionic relaxation은
별도 가산(E_relax = E[q+1/01_Relax] − E[q+1@q0_pre]). 정렬규칙: 공유 고정 바닥층(F F F) x,y,z를
모든 셀 동일 pin + slab z-center (`make_aligned_vacuum.py`). Vacuum scan 30/40/50 Å.

**핵심 결과 (2026-07-02, vac_40A 파일럿):** slabcc와 SCPC가 **7 meV 이내 일치** ✅
- slabcc R_q0: **E_corr = −0.859 eV** (σ_opt=2.58 Å, `optimize_tolerance=0.05` 필수 — 0.01이면 σ=4.27로 delocalized abort)
- SCPC R_q0: **E_corr = −0.866 eV** (pot.align −0.048 eV, DIEL=12.3)
- 비교용 R_q+1(q0@q+1 vs q+1/01_Relax)은 slabcc 실패(σ=5.87 delocalized) → **R_q0 고정이 맞음** 확인.
- slabcc는 delocalized(격자 키워도 discretization error 안 줄면) 판정 시 E_corr 미출력·abort. tolerance는 포텐셜 RMSE만 완화(≠ delocalization 게이트). [[feedback_scpc-vasp-workflow]]
- **주의(진단):** vac_40 slabcc 최적화된 model charge 위치가 defect(atom 36=antisite As, frac 0.417/0.582/**0.603**, 상단)가 아니라 **슬랩 중앙(0.227/0.430/0.524)**으로 이동. δρ 전하중심도 z=27.67 Å(중앙). σ=2.58 Å로 넓어 위치가 잘 결정 안 됨 = 전하 delocalized 증거. SCPC도 countercharge를 슬랩에 분산 → 둘 다 같은 delocalized 밀도 기술해 −0.859≈−0.866 일치. 위치 robust 확인용 **고정-위치 slabcc(52543, charge@atom36 고정)** 실행함 — E_corr가 −0.86 근처 유지되면 위치 무관·값 robust.

**파일럿 job(2026-07-02 저녁 제출):** 52533=SCPC vac_40(3h+ 실행, E_corr −0.8655 안정), 52534=slabcc R_q0 vac_40(완료 −0.859), 52535=slabcc R_q+1(delocalized 실패).

**야간 자동실행 중(2026-07-02 20:24 시작):** **tgm-master.hpc**의 `tmux vscan` 세션에서
`run_pipeline.sh`(VACS="30 50") 가동(Claude Code Bash가 tgm-master에서 실행됨 — 사용자 터미널은
bloch일 수 있으나 tmux·잡제출은 tgm-master). 재접속: `ssh tgm-master` → `tmux attach -t vscan`.
파일/큐는 공유라 아무 서버에서나 보임. vac_30/50 base(52537~52542) 제출됨 → 완료되면 자동으로
SCPC(EDIFF=1E-4 가속)→slabcc(tol=0.05)→`collect_results.py`(vac_40 포함 3개 요약)까지 진행.
vac_40은 세션에서 이미 처리(52533 SCPC 마무리 중).

**다음 단계(내일 2026-07-03 재개 시 확인):**
1. `__vertical_scan__/PIPELINE_DONE` 존재 + `pipeline.log` 확인, `tmux attach -t vscan`.
2. `summary.txt`/`summary.csv`: **VBM-corrected E_f가 slabcc·SCPC 각각 vacuum 수렴 + 두 방법 일치**(vac_40에서 −0.859 vs −0.866 확인됨) 검증.
3. relaxation 항 가산해 relaxed E_f 산출, 최종 리포트.
5. **고정-위치 slabcc(52543) 결과 확인**: `__slabcc_vertical__/vac_40A_fixed/slabcc.out` — charge@defect 고정 시 E_corr가 −0.86 유지되는지(위치 robust) vs 크게 달라지는지.
6. **defect 준위 성격 진단(사용자 요청, 내일)**: q0(중성)의 EIGENVAL/DOSCAR/PROCAR로 문제 준위가 gap 내 deep인지 CBM 근처 shallow/공명인지 판별. deep이면 lateral 셀(3×2→4×3 등) 확대가 국소화·수렴 개선에 도움, shallow면 셀 키워도 더 delocalize돼 다른 접근 필요. (진공 확대는 국소화엔 무관, z-image만.) 이걸로 "셀 키우면 수렴하나?" 질문 판정.
4. 유의: base 1shot=6.5.1, SCPC=6.6.0 바이너리 — TOTEN 교차비교 시 감안(E_corr 자체는 무관).
   SCPC EDIFF: vac_40=1E-6, vac_30/50=1E-4(가속, WAVECAR restart라 E_corr 동일 예상).

계획서: `/home/jaegwan97/.claude/plans/rosy-hatching-quilt.md`. 기존 실패 이력 [[project_slabcc-correction-Cl-As-In]].
