---
name: qd_defect_research_direction
description: "QD 결함형성에너지 연구 방향 (2026-09-27~10-06) — 제안 Big Question: 구속이 1S_e 를 CNL 위로 올려도 InAs CQD 는 왜 n형? 판정 = 결함전자가 1S_e 로 가는 내부이온화. 문헌 공백 판정(충전곡률은 CPC 2014 선점)·Xu–Wei 2007 분해·로드맵"
metadata:
  node_type: memory
  type: project
  originSessionId: 11c6ee48-6b18-4123-8e5e-a326020ccf79
  modified: 2026-10-02T07:00:47.648Z
---

GaAs QD 결과([[trsm_fig6_gaas_qd_model]])와 [[cqd_ntype_origin_goal]]·[[inas_cnl_branch_point]] 를 묶어 제안 (사용자 확정 아님 — "Big question 아직 뚜렷하지 않다"에 대한 내 권고).

## 0D 의 세 기준 상태 (합의 없는 지점의 본질)
| 상태 | 계산 | 값(GaAs Si_Ga⁺) |
|---|---|---|
| 외부 이온화(고립 +1 QD, e⁻→무한원/저장고) | CKT = 3DJM L→∞ | +0.331 |
| 내부 전하이동(e⁻ 같은 QD 밴드끝) | JCC ≈ TRSM | −0.564 / −0.52 |
| 차이 = QD 충전에너지 e²/2C | −δE0 | 0.894 |
실제 CQD 는 리간드·용매·필름 ε_out 에 따라 그 사이. 벌크에선 충전에너지→0 이라 구분 불필요.
실험 대응: 1S_e bleach = 내부 기준 / FET·E_F = 외부(이웃 NC) 기준.

## 제안 Big Question
**양자구속이 1S_e 를 CNL(VBM+0.50) 위로 밀어올리는데도(4 nm: 1S_e≈VBM+0.97) InAs CQD 는 왜 universal n형인가?
어떤 R·표면화학 μ·ε_out 에서 표면결함 전자가 실제로 1S_e 를 채우는가?**
- 판정기준을 슬랩의 "CTL 이 CBM 근처" → QD 의 "결함→1S_e 내부이온화 에너지 < 0" 으로 교체.
- 세부: Q1 1S_e(∝1/R²) vs 국재준위 순서 역전 크기 / Q2 D⁺–e 유전구속 인력 / Q3 ε_out·이웃 QD 충전.
- 로드맵: 0(완료) GaAs 세 기준상태 정량 → 1 GaAs 크기 스캔(δE0∝1/R, B∝R²) → 2 InAs QD + 슬랩 도너 후보(Cl_As, In_i, V_Cl-Cl_As, As_In) → 3 ε_out·μ 도핑상도.
- ⚠ 순수 방법론 논문은 비추: 0D 에선 CKT 가 고립상태 직접 줌 → 보정법 여지 작음. QD_RESEARCH_FRAMEWORK 의 기존 BQ 는 부산물로.
- ⚠ 1S_e vs 결함준위 부호판정은 갭 오차 민감 → PBE 단독 금지, HSE 확인.

## 사용자 아이디어 (2026-09-28): CKT−JCC 차이를 ε_out 로 환산
"QD 모양·크기·ε_in 을 정의 안 해도 진공 DFT 가 충전에너지를 준다 → 용매 ε 만으로 환산".
보정 논의 결과는 [[qd_charging_energy_framework]] (ε_in 내부항 B 분리 필요, 표면결함은 쌍극자로 JCC 쪽도 ε_out 의존).

## 문헌조사 (보고서 `~/materials/reports/QD 충전에너지와 결함형성에너지.md`)
- **선례 못 찾음**: E_ext − E_int = 충전에너지 해석 + ε_out 환산으로 환경 의존 결함 형성에너지/CTL. TRSM 피인용 67편 중 QD 적용 0.
- 가까운 것: Delerue–Lannoo 교과서(2004) §6.1–6.2(TB/고전), Franceschetti–Williamson–Zunger JPCB 104, 3398 (2000)(InAs addition energy, ε_out 1→20 에 Δ₁₂ 0.96→0.11 eV, 광학갭 불변), Diarra PRB 75, 045301 (2007), Liao–Liou–Chelikowsky PRMaterials 6, 054603 (2022, "charging issues are moot").
- ⚠ **Chan–Lee–Chelikowsky CPC 185, 1564 (2014) 본문 확인됨(2026-10-05, `~/papers/charged_QD` PDF·렉노)**: 고립 Si₃₄H₃₆P/Si₁₄₆H₁₀₀P 에서 IE(q)=Wq+q²/2C, C 를 **물리적 NC 정전용량**으로 해석(R=2C 가 6.3/8.8 Å ≈ 기하). → "QD 충전에너지를 DFT 곡률로 뽑는 것"은 선점됨.
- 권장 포지셔닝(정정): 남는 신규성 = **(1) TRSM/JCC vs CKT/3DJM 기준상태로 형성에너지·CTL 분해 (2) ε_out 환산 (3) 하전 표면결함 위치·환경 의존**. 충전에너지 재해석 자체는 CPC 2014 선점.
- 실험: Yoon Sci.Adv. 2023 DFT 는 Zn 억셉터만(In₅₅As₆₈ 클러스터 FNV) — InAs QD n형 결함 DFT 는 공백.
- **Xu–Luo–Li–Xia–Li–Wei PRB 75, 235304 (2007)** (렉노 `~/papers/charged_QD/lecture_note_SiQD_dopants_Xu2007.html`, 노트 `SiQD_dopants_chemical_trend_Xu2007.md`):
  Si QD 하전 도펀트를 주기상자+젤리움·보정 없음·L 미기재로 계산, 이온화에너지(P 0.62→0.06 eV)를 구속+혼성으로만 해석.
  내 분해: 보고값 = ① 내부결합 + ② QD 충전 e²/2C(~1 eV) + ③ 젤리움(−A/L, ~−0.8 eV) → ②③ 상쇄 결과.
  기여 방향: A Si QD 재계산 분해 / B 내부·외부 두 지표 / C ε_out / D CKT 절대준위(Wang–Zunger 비율 불필요) / E 하전 위치선호 / F InAs 긴장.
- Wei·Zhang 관련 PDF 는 사용자가 전부 `~/papers/charged_QD` 에 넣음(2026-10-06). **"Origin of the doping bottleneck in semiconductor QDs: A first-principles study" 미독 — 위 방향과 겹치는지 다음에 확인.**

## 다음 행동 후보
1 "doping bottleneck" 논문 확인 / 2 진공 표면 Si_Ga vs 중심 Si_Ga / 3 GaAs 크기 스캔 / 4 implicit solvent + CKT 호환성 시험 후 ε_out 스캔 / 5 InAs CQD 이전.
