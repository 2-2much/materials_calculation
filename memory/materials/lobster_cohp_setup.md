---
name: lobster_cohp_setup
description: "02-Cl-passv 슬랩 COHP/LOBSTER 셋업 — 최소 524밴드, LREAL=.FALSE. 필수, In_d는 4d 기저 포함"
metadata: 
  node_type: memory
  type: project
  originSessionId: 1fa1fe6b-b65e-4e31-9751-e4d78112683c
---

LOBSTER 5.1.0 위치: `/home/jaegwan97/bin/lobster-5.1.0/lobster-5.1.0` (모듈/PATH 등록 안 됨, 절대경로 호출). 입력 필요 파일 = POSCAR + CONTCAR + POTCAR + KPOINTS + OUTCAR + vasprun.xml + WAVECAR + lobsterin (KPOINTS/OUTCAR 빠지면 "could not determine which program" 에러로 즉사).

**02-Cl-passv 6L 3x2x1 슬랩(95원자: In36/As35/H1.25×6/H.75×6/Cl12) 기준 최소 NBANDS = 524.**
LOBSTER가 직접 계산해서 로그에 출력함(`you need to use at least 524 bands`). 내역: In 9(5s+5p×3+4d×5)×36=324, As 4×35=140, Cl 4×12=48, H 1×12=12. NBANDS < 524면 pCOHP가 아예 비활성화됨. 기존 02_G221-DOS 본계산은 NBANDS=450이라 COHP 불가 → 별도 폴더에서 NBANDS 올려 재계산 필요.

주의점:
- **LREAL=.FALSE. 필수** (프로덕션 템플릿의 `LREAL=A` 그대로 쓰면 안 됨). VASP는 근사 projector로 수렴시킨 ψ̃를 WAVECAR에 쓰는데 LOBSTER는 POTCAR의 정확한 역격자 projector로 PAW 복원을 다시 함 → 해밀토니안 불일치가 charge spilling 폭증으로 나타남. 에너지/힘은 변분 보호로 멀쩡하지만 파동함수 자체를 소비하는 LOBSTER는 직격당함.
- **In은 4d를 기저에 반드시 포함.** In_d POTCAR(ZVAL=13)이라 LOBSTER recommended basis가 `In 4d 5p 5s`. LOBSTER 배포 `VASP/lobsterin_example`의 `basisfunctions In 5s 5p`는 표준 In(ZVAL=3)용이라 그대로 쓰면 안 됨. 안전하게는 basisfunctions 지정하지 말고 userecommendedbasisfunctions 기본값에 맡길 것.
- pseudo-H 기저는 OK(둘 다 `H 1s`로 정상 인식). **단 전자수 부기는 틀린다(2026-07-17 확인).** LOBSTER는 POTCAR TITEL 접미사를 벗겨 원소로 그룹핑하므로 `H1.25`+`H.75` 12개를 `H 12` 한 종으로 병합하고 **전부에 첫 H POTCAR의 ZVAL(1.25)을 적용**한다 → `lobsterout`이 "738.9999 of **742**"로 찍힌다. 실제 NELECT=739(=12개 H가 6×1.25+6×0.75=12전자)이므로 **회수율은 739/739=100%이고 전자 손실이 아니다**. "전자 3개가 사라졌다"로 오독하지 말 것. 원자 순서는 병합돼도 보존되므로(좌표 1e-7 일치) 인덱싱은 안전. cf. [[pydefect_2d_setup]]의 LOCPOT `H.` 파싱 함정, pymatgen `Structure.from_file`도 `H.`에서 죽으므로 수동 파싱 필요.
- **charge spilling 0.86%는 우수한 값이다.** LobsterPy/George et al. ChemPlusChem 87, e202200123 (2022)의 기각 임계가 abs. spilling>5%. `basisSet Bunge` vs `pbeVaspFit2015` A/B 실측 결과 **0.86%로 완전 동일** → 기저 선택으로 더 줄일 여지 없음(투영 포화). orthonormality 경고 10⁻³ 오더도 정상(문제는 10⁻¹ 이상). ENCUT/EDIFF도 지배 요인 아님.
- **"PAW bands from 525 and upwards will be ignored"는 정상**이며 기저함수 총수 524와 정확히 일치. 밴드 525는 E_F+6.1 eV이고 전 k점 점유수 0.0 → ICOHP(점유상태만 적분) 영향 0. 단 COHPCAR 플롯의 E_F+6 eV 위 구간은 상태가 비어 있으므로 해석 금지(`COHPendEnergy 6` 권장).
- KPOINTS가 자동생성 격자(`G / 2 2 1`)면 `Cannot find Reciprocal lattice keyword` 경고 뜨고 vasprun.xml에서 k-point를 읽음("a little less accurate"). 신경 쓰이면 IBZKPT를 KPOINTS로 복사.
- ISYM=0, LORBIT=11, LWAVE=.TRUE.는 기존 DOS 템플릿에 이미 들어있음.

병렬화 팁: NBANDS는 band group 수(= 전체랭크/KPAR/NCORE)로 나눠떨어져야 VASP가 값을 안 올림. cascade2 8노드(256랭크) + NCORE=16에서 KPAR=1이면 band group 16개 → 740이 752로 반올림됨. k-point 4개짜리는 KPAR=4로 두면 band group 4개 → 740 그대로 유지 + HSE 속도 이득. cf. [[slurm_jobname_distinct]]

진행 중(2026-07-16): V_Cl-Cl_As/q0 `02_G221-DOS/01-DOS_NBANDS=740/` — ISPIN=1(이 defect는 spin splitting 없음), NBANDS=740, LREAL=.FALSE., KPAR=4, ICHARG=1로 부모 CHGCAR 심링크. jobid 55385. 관련 defect 상태는 [[defect_states_02_clpassv]] 참조.
