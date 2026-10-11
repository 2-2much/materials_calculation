---
name: qd_charging_energy_framework
description: "★QD 충전에너지 이론 틀 (2026-09-28~10-02 논의) — CKT−JCC = −δE0 = e²/2C(Janak). A/ε_out+B 의 정체(바깥=가우스 정확, 안=분포계수 β/ε_in). 진공 VASP 값엔 ε_in·쌍극자 다 들어있고 문제는 환경 환산뿐. 표면결함 쌍극자·리간드 껍질·수화껍질"
metadata:
  node_type: memory
  type: project
  originSessionId: 11c6ee48-6b18-4123-8e5e-a326020ccf79
  modified: 2026-10-07T04:58:55.923Z
---

GaAs QD Si_Ga⁺ 결과([[trsm_fig6_gaas_qd_model]])를 해석하며 정리한 틀. 계산 아니라 유도·논의.

## 1. 핵심 항등식
- E(N) 2차 → Janak: ε_HOMO 가 N 에 선형, 곡률 U = e²/C. `IP = −ε_HOMO + e²/2C`.
- **δE0 = −(IP + ε_HOMO) = −U/2 = −e²/2C**, 그리고 **ΔH_CKT − ΔH_JCC = −δE0 = 0.894 eV**.
  ½ = Slater 전이상태의 ½ = 충전 일 ∫φdq 의 ½. e²/2C = 전하 하나 올리기, e²/C = addition energy(곡률, IP−EA).
- 도체구 C = ε_out·R. 0.8955 eV → C = 8.04 Å(도체 가정). ⚠ ε_in 항을 넣으면 R_eff 8.6~9.0 Å — **값 하나로 R 과 ε_in 분리 불가**.

## 2. A/ε_out + B 의 출처 (사용자 질문 2026-10-02)
`W = (1/8π)∫D·E dV` 를 QD 안/밖으로 나눔.
- **밖**: 가우스로 D = Q/r² (안쪽 분포·ε 무관) → `Q²/(2ε_out R)` **정확** → A = Q²/2R (순수 기하).
- **안**: 구대칭이면 D = Q(r)/r² 도 ε_out 무관 → `B = βQ²/(2ε_in R)`, β = 분포계수
  (표면전하 0 / 균일부피 0.2 / 1S 분포 ≈0.79; Delerue U=(1/ε_out+0.79/ε_in)e²/R = Brus 1.786 재배열).
- 성립조건: 구대칭 + 날카로운 선형 유전 경계. 중심 Si_Ga + T_d HOMO 구멍이라 우리 계산은 잘 맞음.
- 다중극 일반식: l 성분 반응계수 `∝ (l+1)(ε_in−ε_out)/[ε_in(lε_in+(l+1)ε_out)]`.
  **l=0 만 1/ε_out 에 단순 비례**, l≥1 은 ε_out=ε_in 에서 부호 바뀜 (= Brus α_n 급수, 경계 접근 시 발산).

## 3. 진공 VASP 값에 이미 들어있는 것 (사용자 지적, 맞음)
0.894 eV 에는 QD 실제 모양·크기, **크기 의존 ε_in(PBE 전자응답 ε_∞, 1shot 이라 이온 이완 제외)**, 표면 응답,
그리고 (표면결함이면) **쌍극자·이미지 항까지 전부 자기일관으로 포함**. 진공 값은 그 자체로 완전.
→ 문제는 **다른 ε_out 으로 환산할 때만**: B 는 불변이라 진공 값 전체를 1/ε_out 로 줄이면 과소평가
(내부항 비중 ε_in 10.9 기준: ε_out 1→7%, 2→13%, 4→22%, 10→42%).
분리법 = **ε_out 하나 더 계산**(기울기 A, 절편 B). 크기 스캔은 A·B 둘 다 1/R 이라 분리 못 함.

## 4. 표면 결함·환경 (추정치, 고전 연속체)
- 표면 D⁺(깊이 d≈2 Å) 이미지: `≈ (e²/4ε_in d)(ε_in−ε_out)/(ε_in+ε_out)` → 진공 +0.14, 물 −0.12 eV, **부호 반전**.
  표면결함은 **내부보상 상태(JCC/TRSM)도 쌍극자라 ε_out 의존** → "차이만 환산" 틀은 중심결함에서만 깔끔.
- 리간드 껍질 3층 모형 `(e²/2)[(1/ε_L)(1/R−1/(R+t)) + 1/(ε_out(R+t))]`: R=8, 올레산 t≈10 Å ε_L≈2.5 →
  물 0.21 / 헥산 0.25 eV (진공 0.90, 맨 물 0.01). **긴 리간드가 충전에너지 지배, 용매 거의 무관.**
  수화껍질이 표면에 닿는 건 짧은 무기/친수 리간드(할라이드·InCl₃·S²⁻·MPA) — InAs X형 리간드가 경계.
- 수화껍질은 연속체 아님: 유전포화, 배위, 전하이동. Vogel…Houtepen JACS 146, 9928 (2024) PbS 약 1 eV 이동 "not purely dielectric".

## 5. 1/L, 1/L³ = 다중극
1/L = monopole–monopole Madelung(ε=1, A=20.43). 1/L³ = 젤리움 포물선 × 2차 반지름 모멘트(사중극자 텐서의 trace, 방향성 l=2 는 입방격자에서 0).
1/L², 1/L⁴ 은 T_d·입방 반전대칭으로 0. 중성 host 의 L20 28.5 meV 는 다중극 아님(octupole 1/L⁷) → 파동함수 겹침.

## QD 에서 CTL 의 의미 (2026-10-07 논의)
- 벌크: E_F 는 연속 변수, 저장고는 결정 자신(충전 0) → ε(q/q+1) 은 결함 고유.
- QD: 전하가 둘로 갈림 — **QD 알짜전하 Q(정수, 외부 저장고 μ_res 가 결정)** vs **결함 국소 전하(고정 N 에서 내부 배치가 결정)**.
  외부 CTL ε(Q/Q+1) = QD 전체의 전기화학퍼텐셜 μ(N)=E(N)−E(N−1) = **Coulomb blockade 전도 피크 위치**, 연속 준위 간격 ≥ e²/C(+Δε). 내부 판정은 E_F 무관(TRSM/JCC).
- 고립 QD 에선 E_F 가 자유 변수가 아님(N 고정). 필름/용액의 E_F 는 앙상블·대이온·redox 가 정함.

## 문헌 근거 (2026-10-11 조사, 원문확인 여부 표시)
- 고전 기원: Brus JCP 79,5566(1983)/80,4403(1984) Σ_pol·1.786 (원문 미확인, 표준인용). Makov–Nitzan–Brus JCP 88,5076(1988) 금속·유전체 구 IP: 고전 W+3/8 e²/R 은 틀리고 **W+½e²/R** (초록 확인).
- Franceschetti–Williamson–Zunger PRL 83,1999 / PRB 62,2614(2000): μ1=ε+Σ_pol, μ2=μ1+J_ee(Coul+pol) 분해 (arXiv cond-mat/9908417 원문 확인).
- **DFT ΔSCF ≈ 고전 편극** 논쟁: Ögüt–Chelikowsky–Louie PRL 79,1770(1997) → Godby–White PRL 80,3161(1998, ΔLDA 는 밀도이완=정전 부분만, 비국소 SE 약 0.68 eV 누락) → Franceschetti–Wang–Zunger PRL 83,1269(1999, OCL 자기에너지는 "almost entirely classical polarization", Σ_pol 식 0.94 계수, 원문 확인).
- ε_in 개념: Delerue–Lannoo–Allan PRB 68,115411(2003, 표면 결합 끊김이 평균 ε 감소 원인), PRL 84,2457(2000).
- 1/ε_out+0.79/ε_in 형태: Niquet–Delerue–Allan–Lannoo PRB 65,165334(2002)·Delerue–Lannoo 교과서 추정 — **원문 미확인**.

## How to apply
- 진공 결과 인용 시 "ε_in·모양 포함된 완전한 값"으로. 환경 값은 반드시 A/B 분리 또는 직접 계산.
- 표면 결함은 해석식 대신 원하는 ε_out 에서 직접 계산(implicit solvent + CKT/JCC, 호환성 미확인).
- 다음 시험: 진공 **표면 Si_Ga vs 중심 Si_Ga** (쌍극자 항 크기), 그다음 ε_out 스캔.
관련: [[jcc_dE0_koopmans_janak]] [[qd_defect_research_direction]] [[cqd_ntype_origin_goal]]
