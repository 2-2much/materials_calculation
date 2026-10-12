---
name: inas_kane_kp_application
description: Kane/k·p 를 InAs·InSb 에 적용하는 법(2026-10-04, 10-12 보강) — Γ기저 전개·대각화, 섭동 버린 이유, m*=0.023(F 포함 0.026), p–d 반발=VBM만 올림, 8-band 구성, g*≈−14.6, (α,μ) 3번째 판정자
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

## 2026-10-12 보강 — 노션 "알고 싶은 것" 5문항 답 (노션: ★전체적인 연구 진행 > 1. > 문헌조사 > Primitive InAs > Kane)
사용자 이해 범위 = k·p 식 유도 + Γ기저 전개 + H(k) 대각/비대각 의미까지. 노트 보충점: H₀ 에 SOC 항 없음(InAs Δ/Eg≈0.9 라 필수) · 섞이는 건 u_nk(e^{ikr} 아님) · m*≠m₀ 는 전부 비대각 k·p 에서 온다.
- **Q1 비축퇴→축퇴→Kane**: CB(s, 비축퇴)는 2차섭동 1/m*=1/m₀+(2/m₀²)Σ|p_cm|²/(E_c−E_m). VB(X,Y,Z 3중축퇴)는 분모 0 → 부분공간 대각화(Löwdin) → Luttinger γ₁₋₃, HH/LH. 섭동 유효조건 ħkP/m₀≪Eg 가 InAs 에선 k≈0.023 Å⁻¹ 에서 깨짐 → **Kane = CB–VB 는 정확 대각화, remote 만 섭동**.
- **Q2 Γ에서만 뾰족**: m₀/m*≈1+(E_P/3)[2/Eg+1/(Eg+Δ)] = 44 → m*=0.023 (F=−2.9 넣으면 0.026, 문헌값). E_P≈20 eV 는 III-V 공통 → 차이는 분모 Eg. Γ 밖은 갭 수 eV + 비포물선 E(1+E/Eg)=ħ²k²/2m* 로 고에너지에선 선형. HH(|mJ|=3/2)는 k 방향으로 CB 와 무결합 → 무거움(0.3–0.4), LH 는 CB 거울상.
- **Q3 p–d**: Td 에서 d→e+t₂, VBM(Γ15v)=t₂ 라 같은 표현끼리 반발 → VBM 만 상승, CBM(a₁)은 Γ에서 d와 무결합. LDA/PBE 는 d 너무 얕음 → 반발 과대 → 갭 소멸/역전([[inas_pbe_band_inversion_bulk]]). Eg↓ → m*↓ 로 직결. Lee–Chang 1996 LDA 갭 0.52 는 In 4d core 처리로 반발 제거된 탓일 가능성(미확인 추정).
- **Q4 8-band**: {S,X,Y,Z}×{↑,↓}. SOC로 Γ6(CB,2)·Γ8(HH/LH,4)·Γ7(SO,2). 파라미터 Eg·Δ·P + remote(F, 수정 γ). Kane eq.10: E′(E′−Eg)(E′+Δ)−k²P²(E′+2Δ/3)=0 (E′=E−ħ²k²/2m₀, Ev=0) → CB·LH·SO, HH는 E′=0. 다음 Γ상태(p 반결합 Γ7c/Γ8c) ≳4 eV 위라 8개로 충분, 14-band 는 Dresselhaus 등. InAs 는 Δ→∞/6-band 근사 불가.
- **Q5 Eg 와 k·p**: Eg 는 출력 아니라 **입력**이고 모든 띠끝 성질의 분모 — m₀/m*≈1+E_P/Eg, 섞임 ħkP/(m₀Eg), 비포물선 E(1+E/Eg), **g*≈2−(2E_P/3)Δ/[Eg(Eg+Δ)]≈−14.6 (실험 −14.9)**. → DFT 갭이 틀리면 m*·g*·양자구속이 한꺼번에 틀림. 갭 등고선 위 (α,μ) 는 여러 개 → m*·E_P 재현이 3번째 판정자.
- 사용자 노션 "10월 연구-InAs벌크 하전결함"에 Kane 관련 미결 질문: Luttinger 파라미터, SOC 포함 Kane 풀이, PbS 대비 m*, "왜 Γ에서 defect band 가 더 굽나", 64원자 셀 가능성(Kane 관점).
- 다음 단계 제안(미실행): eq.10 수치 풀이 스크립트로 CB/LH/SO vs 포물선 비교 — 사용자 승인 시에만 파일 생성.
