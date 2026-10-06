---
name: trsm_fig6_gaas_qd_model
description: "★TRSM(Xiao2020) Fig.6 GaAs QD Si_Ga⁺ 재현 — 3DJM 이 논문 JM 12–16 meV 재현(1/L+1/L³, ε=1), JCC 평평 −0.564(TRSM −0.52), CKT +0.331 = 3DJM E∞, 차이 0.894 eV = QD 충전 e²/2C. 트리 위치·모델·설정·진행상황(L50/L60)"
metadata:
  node_type: memory
  type: project
  originSessionId: 11c6ee48-6b18-4123-8e5e-a326020ccf79
  modified: 2026-10-06T05:36:19.859Z
---

2026-09-24~10-02. 이론 해석은 [[qd_charging_energy_framework]], 연구 방향·문헌은 [[qd_defect_research_direction]], CKT 사용법·함정은 [[vasp_ckt_0d_kernel_truncation]].

## 트리 (사용자가 README 읽고 직접 실행)
| 위치 | 내용 |
|---|---|
| bloch `~/materials/__JCC_Reproduction__/20-TRSM_Fig6_GaAsQD` | 구조 생성·이완(00-relax)·3DJM/JCC 스캔(01-scan)·analyze.py·그림 |
| bloch `.../21-GaAs_lattice_PBE` | E–V 10점 + BM → **a0 = 5.7509 Å** (B0 60.3 GPa) |
| bloch `.../22-mu_reference_GaAsQD` | Si 벌크·α-Ga (01-relax ISIF3 ENCUT520 → 02-sp ENCUT400). 기준상엔 CKT 안 씀(μ 는 경계조건 무관) |
| kohn `~/materials/__JCC-reproduce__/20-TRSM_Fig6_GaAsQD/02-CKT` | 0D CKT 15잡 + analyze_ckt.py (bloch 자원 부족으로 이관) |
⚠ kohn 의 13·14·15 번은 BNNT 가 사용 중 → GaAs QD 는 20번대 (사용자 규약).

## 모델
- 논문 인셋 판독: **마젠타=Ga, 카키=As** (색 아닌 공 크기비 = VESTA 반경 Ga 1.53/As 1.21 로 판정), ≈[001] 뷰.
- **rc7.35 Ga 중심 구 절단 = Ga43As44H76 (H1.25×36 on Ga, H.75×40 on As), 163원자 — 사용자 확정.** Si_Ga 는 중심 Ga.
  (rc8.40 Ga55As68H100 은 처음 내가 선호했으나 사용자 판독으로 기각. {100} H–H 1.52 Å 충돌도 8.40 에만 있음.)
- ⚠ make_qd.py 함정(수정됨): rc 를 절대 Å 로 자르면 a 를 키울 때 바깥 껍질이 빠짐(a0 5.7509 에서 Ga31As28).
  → **rc = A_REF 5.6533 격자 기준 반지름, 실제 컷오프 rc·a/A_REF**, 파일명 `_a{a}`. 본계산 = `structures/*_rc7.35_Ga43As44H76_a5.7509_L20.vasp`.
- 전자수(ZVAL Ga_d 13·As 5·Si 4·H1.25·H.75): host 854, **host_qp1 853(홀수)**, SiGa_p1 844(SiGa⁰ 845).

## 설정 요약
PBE.54 Ga_d, ENCUT 400, PREC=A, LREAL=A, Γ(vasp_gam), ISMEAR0 **σ=0.01**, EDIFF 1E-5·LSCALAPACK=.T.(사용자가 바꾼 값), 에너지 = TOTEN([[feedback_energy_toten]]).
L=20 에서 한 번 이완 → 같은 원자배치를 L 셀 중앙에 이식(make_Lseries.py, CONTCAR 좌표 + POSCAR 종이름) → L 의존 = 순수 정전기.
host_qp1: HOMO **t2 3중축퇴 → 5/6 분수점유, EENTRO −10.6 meV 상수**(δE0 에 +5.3 meV, L 무관). σ 를 키우면 비례해 커짐.

## 결과 (eV, μ_i=0, ε_F=ε_VBM; E_Ga−E_Si = +2.518422, E_Si −5.424782, E_Ga −2.906360 eV/atom)
| L | 3DJM | 논문 JM | JCC | 논문 TRSM | δE0 |
|---|---|---|---|---|---|
| 20 | −0.449 | −0.437 | −0.564 | −0.530 | −0.115 |
| 30 | −0.276 | −0.260 | −0.566 | −0.521 | −0.290 |
| 40 | −0.146 | −0.132 | −0.563 | −0.519 | −0.417 |
- 3DJM = E∞ − A/L + B/L³: **A 19.54(자유)/20.43 고정(ε=1), E∞ +0.315/+0.336, B ≈1708** → 발산 아님.
- δE0 = JM 의 거울상(A −19.51, B −1701) → JCC 는 L20→40 에 1 meV 변화.
- **CKT(L35/40) +0.331 = 3DJM E∞**, δE0^CKT = −0.8955(전 L), IP 6.372, ε_HOMO −5.476(진공 기준, L 무관), 갭 2.72.
- **CKT − JCC = 0.894 = −δE0 = 고립 QD 충전 e²/2C** (R_eff ≈ 8 Å; B 에서 역산한 7.9 Å 와 일치).
- JCC vs TRSM 35–45 meV: 재현 기준 안. ⚠ 내가 했던 "0D 에선 JCC≠TRSM 이 드러날 것" 예측은 이 QD 에선 안 보임(과신).
- 중성 host 도 L20→40 에 28.5 meV 변함 = 다중극 아님(octupole 1/L⁷) → L20 이미지 H층 겹침(간격 3.87 Å).

## 진행 중 (2026-10-02 기준)
- **L50**: g1 12노드·12랭크/노드·NCORE12, L50 INCAR 만 `LVHAR=.FALSE.`·`LVTOT=.F.`(LOCPOT 미기록, 에너지 무관). host_q0 실측 노드당 RSS **12.6 GB**(31 GB 중 41%).
- **L60**: 3폴더에 `HOLD` 파일(submit.sh 가 HOLD 상태로 건너뜀, `rm HOLD` 로 해제). L50 실측 기준 노드당 ~22 GB 예상 → **L50 과 같은 설정으로 충분**(LVHAR/LVTOT off·g1 run.sh 반영 필요, submit.sh 의 L60 노드 16→12).
- 예측: 3DJM L50 ≈ −0.06, L60 ≈ 0.00 eV, JCC −0.564 근처 평평. analyze.py 는 완료된 L 자동 탐지.
- ⚠ HPC 메모리: OUTCAR "Maximum memory used"(rank0)를 전 랭크에 곱해 추정하면 과대평가(내가 L60 32 GB/노드로 잘못 예측).
  실측은 `sstat -j <id>.0` MaxRSS(Intel MPI 는 노드당 합). NCORE 를 줄이면 랭크당 격자 메모리가 오히려 늘 수 있음(추정, 미실측).

## 남은 일
1/L³ 의 직접 검증(∫Δρr², LCHARG=.T. 로 host q0/qp1 L25 재계산) / 표면 Si_Ga vs 중심 Si_Ga(쌍극자 항) / GaAs 크기 스캔 / ε_out 스캔.
