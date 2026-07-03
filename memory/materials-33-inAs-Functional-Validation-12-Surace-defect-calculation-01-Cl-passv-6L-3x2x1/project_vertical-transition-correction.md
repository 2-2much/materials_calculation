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

**■ 최종 결과 (2026-07-03, vacuum scan 30/40/50Å 전 잡 완료):**

E_DFT(q+1@q0 TOTEN, 보정전): 30Å −343.7825 / 40Å −343.1937 / 50Å −342.7845 (진공 늘수록 발산 = 하전 슬랩 image self-energy).

| 진공 | SCPC E_corr | slabcc auto E_corr | slabcc fixed E_corr |
|------|-------------|--------------------|--------------------|
| 30Å | −0.5001 | ❌ delocalized abort(σ4.01) | **−0.4550**(σ1.70) |
| 40Å | −0.8656 | −0.859(σ2.58) | −0.815(σ1.73) |
| 50Å | −1.2588 | −1.253(σ2.71) | −1.203(σ1.85) |

보정 총에너지 E_DFT+E_corr — **40→50Å Δ**: SCPC 16 meV, slabcc auto 16 meV, slabcc fixed 21 meV → **세 방법 다 40Å부터 수렴**(30Å은 얇아 수렴영역 밖). **slabcc auto ≡ SCPC 6 meV 일치**(40Å −344.053 vs −344.059; 50Å −344.037 vs −344.043) ✅.
- **position-fix가 30Å delocalization 해결**: auto는 위치 최적화가 σ를 키워 abort하나, `optimize_charge_position=no`+실제 defect 위치(atom36: 30Å z=0.625/40Å 0.603/50Å 0.587, in-plane 0.417/0.582 공통) 고정하면 σ~1.7로 정상. fixed는 auto보다 |E_corr| 40–50 meV 작음(defect에 묶으니 delocalized model보다 보정 작게). `__slabcc_vertical__/vac_{30,50}A_fixed/`.

**■ Alignment 규약 확정 (scpc.F rev7 소스 추적):** SCPCOUT `Energy Correction`은 **이미 전기적 정렬 포함** (line 1037 `ecor1−ealig`, ealig=½qΔV_ref). 따로 찍히는 `Potential Alignment(x,y,z)`(−0.048)는 별개 진단량 → **추가로 더하면 이중계산**. slabcc E_corr도 `E_iso−E_per−q·dV`로 정렬 내장 → 두 코드 직접 비교 가능(6meV). 상세 [[scpc-dfe-formula]].

**■ 리포트:** `__vertical_scan__/REPORT.md` 생성함.

**남은 단계:**
1. relaxation 항 가산(E_relax = E[q+1/01_Relax] − E[q+1@q0_pre])해 relaxed 형성E 산출.
2. band-reference ΔV(defect↔pristine)는 SCPC 출력 아닌 별도 산출 후 DFE 조립.
3. **defect 준위 성격 진단(미완, 사용자 요청)**: q0의 EIGENVAL/DOSCAR/PROCAR로 deep vs shallow 판별 → lateral 셀 확대(3×2→4×3)가 수렴 개선에 유효한지 판정. (delocalized 증거 여럿 관측됨: auto model이 슬랩중앙 이동, δρ center z=27.67Å.)
- 유의: base 1shot=6.5.1, SCPC=6.6.0 바이너리. SCPC EDIFF vac_40=1E-6, vac_30/50=1E-4(가속).

계획서: `/home/jaegwan97/.claude/plans/rosy-hatching-quilt.md`. 기존 실패 이력 [[project_slabcc-correction-Cl-As-In]].
