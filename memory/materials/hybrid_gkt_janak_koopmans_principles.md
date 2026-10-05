---
name: hybrid_gkt_janak_koopmans_principles
description: gKT·piecewise linearity 원리 학습 정리(2026-10-03) — 앙상블=혼합상태라 정의상 직선, Janak(항상 성립)+Koopmans형 요구 ⇔ 직선, 근사 DFT 곡률 원인, range separation erfc 분할
metadata:
  type: user
---

사용자가 2026-10-01~05 에 HSE 원리 → 앙상블 → Janak/Koopmans → gKT 를 차례로 공부함(InAs (α,μ) 튜닝 준비, [[inas_hybrid_alpha_mu_tuning]]). 이후 설명은 이 이해 수준을 전제로 할 것.

- **앙상블** = 정수 전자수 복사본들의 혼합상태 ρ=Σp_k|Ψ_k⟩⟨Ψ_k|. E=Tr(ρH)=Σp_kE_k 가 선형 → 분수 N 에서 직선(PPLB 1982). 전하 초선택 규칙 때문에 N 이 다른 상태는 중첩 불가, 혼합만. 실제 예: 떨어진 H₂⁺(각 H 는 축약밀도행렬로 혼합), 결함 점유의 시간평균, 시료 내 결함 집단.
- 순수 vs 혼합 판별: 순수는 결과 100% 인 측정축 존재 / Tr ρ²=1 / 블로흐 |r|=1. 혼합의 구성(↑↓ 50:50 vs →← 50:50)은 관측 불가, ρ 만 물리적.
- **근사 DFT 곡률**: NELECT 분수 = 앙상블 아닌 실제 분수전하 구름 → 하트리 q² 항의 자기상호작용. PBE 볼록(비편재), HF 오목(과국소). 하이브리드 = 상쇄량 맞추기. ISMEAR 스미어링도 한전자 수준 앙상블이라 곡률 못 고침.
- **Janak** ∂E/∂n_i=ε_i: 어떤 범함수에서도 성립(접선). **Koopmans형(gKT)**: ε = ΔSCF(할선, 궤도이완 포함). 둘 다 ⇔ 구간 직선. E=a+bq+cq² → 접선 b, 할선 b+c, 반대끝 b+2c. Deák Table II 1.4/1.1/0.7 → 1.2/1.2/1.2.
- Deák 그림의 q = 결함 전하(q=1 = 전자 1개 제거). 기울기 0→1 ≈ −3.15, 1→2 ≈ −1.1 eV, q=1 꺾임 ≈2 eV = 고정구조 U(물리). 그림의 "−IE/−EA" 라벨은 부호 관례 느슨 — 정확히 기울기 = −ε_HOMO(VASP 내부 영점 기준).
- **Range separation**: 1/r = erfc(μr)/r + erf(μr)/r (항등식). 절반지점 r≈0.48/μ (μ=0.2 → 2.4 Å ≈ In–As 결합). LR 은 r=0 에서 2μ/√π 로 유한. k공간 SR 은 4π/k² 특이점 없음 → k수렴 빠름(μ 선택의 비용 이유). μ→0 PBE0, μ→∞ PBE. HF·PBE 가 같은 μ 써야 빼는/넣는 교환이 맞음(HSE03 버그).
- 관련: [[jcc_dE0_koopmans_janak]], [[hybrid_choice_Ga2O3_Deak2017]].
