---
name: inas_kane_kp_application
description: Kane/k·p 를 InAs·InSb 에 적용하는 법(2026-10-04) — Γ기저 전개·대각화, Γ밖 s–p 섞임 이유, m0/m*≈1+E_P/E_g≈53, 비포물선 전환 k≈0.023 Å⁻¹, (α,μ) 3번째 판정자로 사용
metadata:
  type: project
---

사용자 노트: 업로드 `kane_model_kp_notes.md`(Q1–Q11, k·p 유도까지 이해). 이 대화는 그 다음 단계.

- 파라미터(Vurgaftman 2001, 0 K, ⚠기억값·원문 대조 필요): InAs Eg 0.417/Δ 0.39/E_P 21.5/F −2.90/γ 20.0,8.5,9.2 · InSb 0.235/0.81/23.3/−0.23/34.8,15.5,16.5. 검산 m* = 0.0242 / 0.0135.
- 모델 선택: 2-band(어림) · 3차식 Kane eq.10(**InAs 필수, Δ/Eg≈0.9**; InSb 는 3.5 라 eq.13 근사 가능) · 8×8(정공·warping, γ 재정규화 안 하면 spurious 해).
- 확장 방법: u_nk = Σ c_m(k) u_m0, H_mm'(k)=(E_m0+ħ²k²/2m0)δ + (ħ/m0)k·p_mm' 를 k마다 대각화. k 는 명시적으로만 → Eg·Δ·P 로 Γ 주변 결정. 근사는 기저 절단뿐.
- Γ에선 Td 로 A₁(s)/T₂(p) 안 섞임. k≠0 → little group C2v/C3v 로 낮아져 s,p_x 같은 표현 + ⟨S|p_x|X⟩≠0 → 섞임 진폭 ≈ ħkP/(m0Eg).
- CB 뾰족: m0/m* ≈ 1 + E_P/Eg ≈ 1+52 (곡률 98% 가 VB 준위반발). LH 거울상, HH 는 CB 와 결합 안 해 무거움. P/m0 ≈ 1.4×10⁶ m/s, 비포물선 전환 k ≈ Eg/(2ħP/m0) ≈ 0.023 Å⁻¹ (Γ–X 의 2%).
- QD 1Se 어림(k=π/R): R 2/3/5 nm 포물선 3.92/1.74/0.63 vs 비포물선 1.09/0.67/0.34 eV → 포물선 EMA 2–4배 과대.
- 얕은 도너 수소모형: E_d≈1.4 meV, a_B≈334 Å → 슈퍼셀 영역 아님([[shallow_donor_inas_supercell_limit]]).
- **활용**: 갭 등고선 위 (α,μ) 후보 판별 = HSE+SOC primitive Γ근방을 eq.10 피팅 → Eg·Δ·E_P (E_P 는 LOPTICS WAVEDER 로 교차검증), m*0.024·E_P21.5 재현 여부. SOC 필요(결함계산과 별도), 자기격자에서. → [[inas_hybrid_alpha_mu_tuning]]
