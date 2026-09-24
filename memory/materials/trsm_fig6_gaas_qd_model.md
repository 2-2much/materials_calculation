---
name: trsm_fig6_gaas_qd_model
description: TRSM(Xiao2020) Fig.6 GaAs QD 재현 준비 — 인셋 판독(마젠타=Ga·카키=As)·QD 모델 rc7.35 Ga42Si1As44H76 확정(8.40 기각)·JM 곡선은 발산 아닌 ε=1 Makov-Payne(1/L+1/L³)
metadata:
  node_type: memory
  type: project
  originSessionId: 11c6ee48-6b18-4123-8e5e-a326020ccf79
  modified: 2026-09-24T04:17:26.949Z
---

2026-09-24 시작. 사용자 결정: **TRSM 구현은 보류**, VASP PAW로 host/JM(q=+1)까지 + JCC 보정 적용.
QD 크기는 인셋 판독으로 정하기로 함. 파일·폴더는 아직 안 만듦(스크래치패드에서만 작업).

## 인셋 원자 판독
- 색은 VESTA 기본색이 아님(VESTA는 Ga·As 둘 다 초록). **공 크기 비가 VESTA 원자반경과 일치**:
  마젠타 : 카키 ≈ 1.25 = Ga 1.53 / As 1.21, 파란 Si(1.18) ≈ 카키 크기, H 0.46 → **마젠타=Ga, 카키=As**.
  Si는 마젠타 자리(=Ga)에 있고 카키와 결합 → Si_Ga와 모순 없음.
- 뷰는 ≈[001] + 약 10° 기울임. Ga 행 5개(간격 a/2), As 행 6개, 투영 As 폭 ≈14.1 Å, **가장 바깥 dihydride는 전부 As**.

## QD 후보 (Ga 중심 구 절단, 배위 1인 원자 제거 반복)
| rc | 조성 | H(Ga쪽 1.25) | H(As쪽 0.75) |
|---|---|---|---|
| **7.35 (확정, 논문 모델)** | Ga43As44 → Ga42Si1As44 | 36 | 40 |
| 8.40 (처음엔 선호 → 사용자 판독으로 기각) | **Ga55As68 → Ga54Si1As68** | **24** | **76** |
rc=8.95는 가장자리에 Ga가 나와서 제외. 8.40 선호 근거: 윗면 As dihydride 쌍 + 더 둥근 윤곽 +
아래 JM 피팅의 R_eff≈8 Å(rmax 8.36). host 592e 닫힌 껍질, Si_Ga⁰ 593(홀수→ISPIN=2), q+1 592.
L=20에서도 이웃 셀 이미지 사이 H–H 거리 4.2 Å라 들어간다.

## ★논문 JM 곡선 = 1/L (발산 아님)
논문 점(눈으로 읽은 값) L=20..40: −0.437/−0.344/−0.260/−0.190/−0.132.
- a+b/L RMS 12 meV · a+bL RMS 10 meV
- **E∞ − A/L + B/L³, A=q²α_M e²/2=20.43 eV·Å 고정(ε=1)** → RMS **1.3 meV**, E∞=+0.35, B=1880 eV·Å³
- 세 계수 모두 자유롭게 두면 A=19.6(−4%)
- 1/L³ 항 = QD 표면으로 밀려난 편극전하 (1−1/ε)q의 2차 모멘트 → R_eff≈8 Å
물리: 유전체 구 안의 전하는 **밖에서는 가려지지 않음** → 진공이 셀을 채우면 ε_eff→1.
L 축으로 그리면 거의 직선처럼 보이는 것은 L³ 항 때문. JM∞ − TRSM ≈ 0.87 eV.
→ 우리 JM 계산의 검증 기준: A≈20.4 재현, B ∝ (1−1/ε)R².

관련: [[trsm_1d_nanotube_literature]], [[jcc_dimension_hierarchy_measured]] (0D는 젤리움·이미지 둘 다 1/L)

## 2026-09-24 생성물 — `~/materials/__JCC_Reproduction__/20-TRSM_Fig6_GaAsQD/`
- `make_qd.py` (--a --L --rc --dH_*), `structures/{host,SiGa}_rc{7.35,8.40}_*_L20.vasp`
  종 이름 `Ga [Si] As H1.25 H.75`, a=5.6533(실험값 임시 — PBE a0 정해지면 재생성), X–H 1.52 초기값
- ⚠ H–H 1.52 Å 충돌은 **rc8.40에만** 있음({100} dihydride). **rc7.35는 충돌 없음**(최소 H–H 2.48 = 같은 As의 dihydride). 2026-09-24 사용자 확인: **논문 모델 = rc7.35**, host·SiGa 두 개로 진행
- `plot_JM_invL.py` → `fig_JM_invL.png` (L 축 / 1/L 축)

## 2026-09-24 폴더 번호 규약 (사용자 지시)
kohn `~/materials/__JCC-reproduce__` 의 **13·14·15 는 BNNT 가 사용 중** → GaAs QD 트리는 20번대.
- `20-TRSM_Fig6_GaAsQD` (구 13) · `21-GaAs_lattice_PBE` (E–V 10점 + BM, Ga_d/ENCUT400/Γ12³) ·
  `22-mu_reference_GaAsQD` (Si 벌크 + α-Ga, 01-relax ISIF=3 ENCUT520 → 02-sp ENCUT400)
- 사용자가 README·스크립트 읽고 **직접 실행**. a0 의 목적 = QD 초기구조 이완 시간 단축(어차피 이완함)

## ⚠ 2026-09-24 make_qd.py rc 함정 (수정 완료)
21 BM 결과 **PBE a0 = 5.7509 Å** (B0 60.3 GPa). 이 a 로 재생성하자 Ga31As28 로 줄어듦 —
rc 가 절대 Å 라서 바깥 껍질이 7.34→7.47 Å 로 밀려 컷오프 밖으로 빠짐.
→ **rc 는 A_REF=5.6533 격자에서의 반지름(모양 이름)**, 실제 컷오프 = rc·a/A_REF 로 수정. 파일명에 `_a{a}` 추가.
a=5.60~5.90 전부 Ga43As44H76 유지 확인, a=5.6533 은 옛 파일과 좌표 동일.
본계산 구조 = `structures/{host,SiGa}_rc7.35_Ga43As44H76_a5.7509_L20.vasp` (L=20 진공 3.87 Å).
잘못된 쌍은 `structures/__wrong_Ga31As28_absolute_rc__/` 로 격리.

## 에너지 열 규약 (2026-09-24 사용자 결정)
22 기준상은 **`free  energy   TOTEN`** 사용 (α-Ga 는 MP smearing → F 가 변분량, σ→0 외삽식은 Gaussian/FD 용).
21 E–V 스캔은 sigma->0 그대로 둠(k 조밀·반도체라 차이 무시). → 전 트리 공통 규칙으로 확장됨: [[feedback_energy_toten]].

## 2026-09-24 QD 본계산 입력 완성 (사용자가 읽고 직접 실행)
`20-TRSM_Fig6_GaAsQD`: 00-relax/{host_q0,SiGa_p1}_L20 → make_Lseries.py 로 L=20..40 셀 중앙 이식 →
01-scan/{host_q0 854e, host_qp1 853e (JCC δE0), SiGa_p1 844e}. vasp_gam, ISMEAR0/σ0.01, ENCUT400 PREC=A LREAL=A,
KPAR1/NCORE12/NSIM12/LSCALAPACK.F., g2 4노드(L≥35 8노드). ZVAL Ga_d 13·As 5·Si 4·H1.25·H.75.
옛 구조는 사용자가 `_formal_structures_/` 로 옮김. 스크립트는 스크래치 복사본에서 가짜 CONTCAR 로 시험 통과.
