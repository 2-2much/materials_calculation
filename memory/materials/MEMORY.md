- [User Profile](user_profile.md) — KAIST 소속, DFT 계산 연구
- [CQD n-type Origin Goal](cqd_ntype_origin_goal.md) — 최상위 목표: InAs CQD intrinsic n-type origin을 표면 point defect로 규명. 판정=CTL(shallow donor?)+μ-diagram. (110) Cl→InCl3 passivation reference. ↔ 문헌 근거는 [[read_papers_memory]] 통해 papers 논문 분석 노트 참조
- [Read Papers Memory](read_papers_memory.md) — (범용 다리) 논문/문헌 근거 필요 시 ~/papers/memory/paper_notes/README.md 인덱스 먼저 읽고 관련 주제 .md만 열기. paper_notes는 hohenberg 경로로만 닿음
- [InCl3 Cl-As_In Unbound](incl3_cl_as_in_unbound.md) — 03-InCl3-passv Cl-As_In q0: Cl이 As_In 아닌 표면 In으로(In-Cl 2.41Å), bound complex 아님. complex→독립 donor(As_In,In_i,Cl_i) 스캔+CTL 비교로 재정렬 권고
- [In_i_2 Adatom Ejection](in_i_2_adatom_ejection.md) — 03-InCl3-passv In_i_2/q0: interstitial In이 3.76Å 튕겨나가 Cl층 위 저배위 adatom으로 배출(무결합). 음의 E_form(In-rich −0.20eV)은 안정결함 아니라 In이 금속기준 회귀 신호. 내일 ISPIN·saddle판정·결합자리 재이완 TODO
- [scaLAPACK mlx OFI Hang](scalapack_mlx_ofi_hang.md) — VASP hang(rank 99%CPU/OUTCAR정지): scaLAPACK BLACS Bcast가 Intel MPI mlx OFI collective서 정지. fix=LSCALAPACK=.FALSE. 또는 I_MPI_COLL_DIRECT=off. 노드축소는 지연만. gstack으로 진단. Cl_i-As 고유(V_As 재실행 정상완주로 환경 기각)
- [Defect Package Repo](defect_package_repo.md) — 정본=/mnt/hohenberg/.../Defect_Package. ⚠2026-07-16 GitHub 배포+재구성: github.com/2-2much/Defect_Package(private)로 push, 추적=scripts/+example/+LICENSE(MIT)+requirements.txt(2폴더 allowlist), inputs/·Initial_converged_POSCARs/·POTCAR untrack+gitignore. POTCAR 히스토리 스크럽 완료(filter-branch+force-push, ⚠GitHub unreachable blob은 자체GC까지 잔존가능). 사용=example/를 repo밖 계산폴더로 복사·편집, 패키지개선은 clone에서 commit+push. calc scripts 심링크사고 해소(실복사·계산폴더 git추적, 53d6e42). 옛기록: 로컬only(무효), 운용모델·커밋컨벤션(2026-07-14), NFS심링크 dangling→seed즉사(2026-07-15)
- [Lab Members](lab_members.md) — 연구실 구성원 명단
- [SCPC Debug](scpc_debug.md) — SCPC: CKT 비호환, getgrid 버그, SCPCOUT interleaving, OSZICAR 유실, 권장 설정
- [SCPC Reference](scpc_reference.md) — SCPC GitHub README 참조, INVCOR/REFCHG 그리드 호환 주의
- [Surface Defect Gam Tight](surface_defect_gam_tight.md) — InAs surface defect 00_Gam-relax EDIFFG -0.02→-0.01 tightening (2026-06-24)
- [Bloch Workspace Setup](bloch_workspace_setup.md) — bloch 서버 VS Code workspace 설정 진행 중, config.txt→config 이름 변경 필요
- [Vertical Scan slabcc≡SCPC](vertical_scan_slabcc_scpc.md) — Cl-As_In(+1) __vertical_scan__: slabcc≡SCPC corrected E 6meV 일치, 40→50Å 16-21meV 수렴(30Å 이탈, 최소진공40Å), 정렬 이중계산 금지, resonant donor(HSE 확정필요)
- [Charged Defect VBM Reference](charged_defect_vbm_ref.md) — VBM ref=pure VBM(≠neutral defect HOMO). pure VBM+ΔV=far-field host VBM(δ_defect 배제). SCPC align은 정전퍼텐셜(charged→neutral-defect)이지 VBM 아님→pristine bridge 별도(slab는 vacuum정렬, IP검증). InAs 실험IP 정량대조 안함
- [SCPC Vacuum Scan](scpc_vacuum_scan.md) — Cl-As_In SCPC 20/30/40Å 완료. SCPC formation E_f 수렴(In-rich 4.49→4.51eV); ⚠SCPC TOTEN은 이미 보정포함→E_corr 별도가산 금지. 큰 E_corr(~1.8eV)=표면 국소전하+작은 3×2 셀(버그 아님, lateral 키워야 줄어듦). 리포트 make_report.py로 재생성(ZLOW/ZHIG 버그 수정)
- [Cl2 HSE06 Calc](cl2_hse06_calc.md) — Cl2 분자 HSE06 이완 (AEXX=0.27, LHFSKIP, VASP6.5.1), ENCUT300 완료(-5.3953 eV), ENCUT400 진행중(job 52424)
- [SLURM Jobname Distinct](slurm_jobname_distinct.md) — SLURM 잡 제출 시 jobname을 calc별로 구분되게 작성(예: cd-k2x2x1_G-qp1)
- [CHG-DIFF kpt Scan](chgdiff_kpt_scan.md) — Cl-As_In CHG-DIFF k-point 수렴: k1x1x1 미수렴, k2x2x1_MP=k1_bald 수렴. vaspkit 314는 상대경로 필수
- [pydefect_2d Setup](pydefect_2d_setup.md) — 03-pydefect_2d/ NK 보정 셋업(Cl-As_In q+1). 유전율은 슬랩 셀-평균(이방성)이어야 함(벌크 직접입력 금지), effective-medium 근사 레시피, 면수직 plateau<벌크는 정상, LOCPOT 원소명 H. 파싱 함정
- [Surface Defect 1shot Band Workflow](surface_defect_1shot_band_workflow.md) — 02-Cl-passv 3단계(spin-Gam-relax→G221-1shot tetrahedral DOS→hybrid Band). 전 defect ISPIN=2 계산 진행중(2026-07-01)
- [Surface Defect Spin Test](surface_defect_spin_test.md) — Spin test 결과: Cl-As_In/q0만 자성(1.0 μB, -125 meV) → 본계산 ISPIN=2 필요. V_Cl-Cl_As 재실행 예정
- [a-Dispersion Scan PBE-d](adispersion_scan_pbed.md) — Cl-As_In a축 dispersion 수렴 스캔(PBE-d p3/p4/p5×2, Y-Γ-X-S). ⚠큰셀 결함은 strip-insertion(reference q0 이식)으로 만들 것(ideal배치→Cl2 desorption). run script ROOT 절대경로
- [Surface Defect Gam-relax Spin Comparison](surface_defect_gam_relax_spin_comparison.md) — Cl-As_In/q0 non-mag vs spin ΔE=-171meV(open-shell radical). 결정: 12-Surace-defect_calculation 본계산 전체 ISPIN=2로 통일
- [Surface Defect Dipole Correction](surface_defect_dipole_correction.md) — ⚠️번복(2026-07-01): dipole ON시 HSE SCF 미수렴 → 전체 dipole OFF로 재계산 결정. 이전 방침(q0 ON/DIPOL=0.518, 하전 OFF)은 참고용 보존. 스크립트 charge-conditional 블록은 defensive로 유지
- [Surface Defect Spin Screening Full](surface_defect_spin_screening_full.md) — 전 defect 스핀 스크리닝 + ISPIN 분기 방침. 자성=V_Cl-Cl_In/q0(-268meV),Cl-As_In/q0(-171meV); In_i_Td_In/q0 애매(mag0.5,-7meV) 재확인. charge parity 실증(Cl-As_In q0자성/q+1비자성). 방침전환: 전체ISPIN=2통일→스핀에너지 기반 분기(현큐 완주, 다음배치부터). ispin은 defects.yaml 아님→별도 spin_screening.yaml(B안, 내일 배선). git관리도 내일 논의
- [Surface Defect ICORELEVEL Bug](surface_defect_icorelevel_bug.md) — DOS/Band INCAR의 ICORELEVEL=1<TAB># 이 IERR=5 파싱오류로 즉사. config 템플릿(02.G221-DOS/03.Band) 버그. 12개 파일 주석처리 완료(2026-07-01)
- [Surface Defect OSZICAR Buffering](surface_defect_oszicar_buffering.md) — HSE 잡 실행 중 OSZICAR 갱신 안 됨(버퍼링) → std.log/OUTCAR로 모니터링. HSE 이중루프(exchange 갱신 점프)로 step 많이 필요, NELM 120~150 권장
- [Surface Defect ISTART/WAVECAR gam-std](surface_defect_istart_wavecar_gam_std.md) — gam(Gamma-only) WAVECAR을 std가 못 읽음(plane wave coeff 48187≈2×24094). DOS 단계만 ISTART=0(ICHARG=1 유지), 03_Band(std→std)는 ISTART=1 무방
- [Species Aliases Mechanism](species_aliases_mechanism.md) — In_L→In_d POTCAR alias(runtime.yaml species_aliases). 오류는 VASP아닌 prep 파이썬(check_species_order/NELECT). VASP는 라벨 안읽음
- [Defect States 02-Cl-passv](defect_states_02_clpassv.md) — 02-Cl-passv defect state 정리(pure gap 1.19eV): As_In 얕음/Cl-As_In q0 스핀분열 라디칼/q+1 비점유 upper-gap/V_Cl-Cl_As Fermi pinned. ⚠도구 인덱싱: zeroband 1-based, bandos dos 0-based(N-1)

## 연구 / 프로젝트
- [SCPC E_rel Vacuum Convergence](scpc_erel_vacuum_convergence.md) — Cl-As_In q+1 relaxation energy E_rel=E(+1,Rq0)−E(+1,Rq+1) vacuum 수렴 확인(20/30/40Å: 101→109→113meV, spread 11.7meV, 증분 단조감소→수렴). monopole self-energy 상쇄로 vacuum-무관. g2 8노드 KPAR=4
- [Adiabatic DFE Algorithm Plan](adiabatic_dfe_algorithm_plan.md) — surface defect thermodynamic(adiabatic) DFE 파이프라인 알고리즘 설계 중. (A)geometry완화 확정, 전 donor 적용. relax는 이미 charge별 adiabatic·correction+assembly 레이어가 신규. CTL은 μ무관(2단분리). 미해결 결정 4개(seeding/shallow-correction분기/cross-defect기준/E_corr재사용). 플랜모드 이어서
- [incl3 passv 4x2 thickness](incl3_passv_4x2_thickness.md) — 03-InCl3-passv 4x2 슬랩 셀 구성(위 InCl3/아래 pseudo-H, 6층 11.3Å) + 두께 6L→5L 검토 진행상태·판단기준
- [slabcc correction](slabcc_correction.md) — Cl-As_In CHG-DIFF slabcc correction 시도 결과 및 슈퍼셀 크기 문제
- [Slab Correction Workflow](slab_correction_workflow.md) — Defect_Package에 추가한 slab(2D) slabcc charged-defect correction(adiabatic/optical R_0 스킴). optical(고정 R_0) single-point→slabcc→plot_DFE. diel_in=ε_∞. CLI=--charged-stage(필수)+--neutral-stage/--relax-stage(선택). prepare에 reference_charge_contcar+q0 skip/symlink. 01-Cl-passv 적용
- [DFE +1 Vacuum As-rich (fixed)](dfe_p1_vacuum_asrich_fixed.md) — Cl-As_In(+1) As-rich VBM 형성E 진공수렴(current+vac30/40/50 fixed slabcc): 보정후 0.384/0.380/0.379eV 수렴(vac≥40 신뢰), current(vac~11Å)=0.423 RMSE warn 신뢰낮음. Δμ_As=+3.4059. vertical값→adiabatic −88meV(≈0.29eV). 플롯=results/DFE_plots/DFE_Cl-As_In_p1_vacuum_Asrich.py
- [KP slabcc NaCl Reproduction](kp_slabcc_nacl_reproduction.md) — Komsa-Pasquarello NaCl Cl-vac(q+1) E_f 재현 toy(11-Surface/KP_slabcc_reproduction). 저자 구조+CKT footing+KPAR3, 입력완비. tgm-master 자리부족→잡취소, kohn 이전 진행. slabcc _test_값 +0.556/−0.174 검증됨
- [vclclas atom95 fatband](vclclas_atom95_fatband.md) — V_Cl-Cl_As/q0 03_Band fatband — atom 95(passivation Cl) spin up=dw 동일, 순 스핀 없음
- [Spin Screening 04-InCl3](spin_screening_04_incl3.md) — 04-InCl3-passv HSE06 spin screening: 11개 q0에 magnetic_seed(runtime.yaml)로 01_Spin-gam-relax 제출(5노드, jobid 55291~). ΔE_spin=E(01)−E(00)<0이면 자성. 00 baseline TOTEN 기록. ⚠SLURM 완료 미통보
- [optical correction adiabatic rationale](optical_correction_adiabatic_rationale.md) — 표면 결함 adiabatic DFE에서 finite-size 보정은 frozen-R_0 optical(E_corr^opt)을 채택하는 이유와 부기 항등식
- [charge state + optical/slabcc setup](chargestate_optical_slabcc_setup.md) — 02-Cl-passv 프로덕션 셋업. ⚠유연히: charge state=neutral DOS Fermi 위치(하부 core-level 정렬, 진공 금지), 노드/CPU=쓰려는 노드 코어 수. optical 1shot(grid-lock)→slabcc(diel=ε_∞) 워크플로우

## 참고 자료
- [Server FS & Git Sync Scope](server_fs_git_sync_scope.md) — ⚠git 자동동기화는 memory/.claude만 옮기고 계산폴더는 안 옮김(.gitignore=*). /home·/TGM 로컬, /mnt/hohenberg/byuid/jaegwan97만 공유NFS. 서버간 계산이동=공유마운트/수동복사. tgm-master=SLURM(g1/g2), kohn 등은 별도서버
- [slabcc optimize_tolerance](slabcc_optimize_tolerance.md) — slabcc optimize_tolerance는 목표 RMSE 임계값 아니라 BOBYQA 상대수렴 tolerance. 최종 RMSE>tol이어도 정상(local min). 남은 RMSE=등방 Gaussian 모델 한계, 줄이려면 charge_trivariate=yes/다중Gaussian
- [zeroband fatband tool](zeroband_fatband_tool.md) — zeroband.py — hybrid band(zero-weight kpt) projected fatband 플로터 위치/사용법
- [zeroband spin parsing](zeroband_spin_parsing.md) — zeroband.py 밴드플롯 --spin 옵션 및 collinear ISPIN=2 PROCAR 파싱 수정

## 작업 방식 / 피드백
- [shared memory mirror](feedback_shared-memory-mirror.md) — Codex durable memories should be mirrored to both memory/materials and memory/codex, with matching slugs and refreshed indexes
- [conversation log](conversation_log.md) — Concise dated summaries of Codex conversations in this repo, mirrored with memory/codex/conversation_log.md
