---
name: inas_cnl_branch_point
description: "InAs CNL(branch point) = VBM+0.50 eV는 견고, CNL−CBM=+0.05~0.19는 불확실 → 우리 HSE로 부호 증명 금지. Tersoff 지름길이 0.50 정확 재현(공짜 함수검증). 양자구속이 CNL 논리를 깨는 것이 우리 프로젝트의 정당화"
metadata: 
  node_type: memory
  type: project
  originSessionId: 33fefbd9-5bd7-4c35-85b2-73de3e2d66d2
  modified: 2026-08-07T07:19:52.918Z
---

2026-08-07. King 외 2편(PRB 77,045316 InN / PRL 101,116808 In₂O₃) 렉쳐노트 작성 중 정리.
전문: `~/papers/memory/paper_notes/branch_point_CNL_InAs.md`, 렉노 `~/papers/n-type_InAs_QDs/lecture_note_branch_point_CNL.html`

## 숫자 (InAs)
- **E_CNL − E_VBM ≈ 0.50 eV — 견고**. 출처 간 0.45(Mönch 1996) ~ 0.53(Brudnyi 2003), ±0.04 안.
- **E_CNL − E_CBM = +0.05 ~ +0.19 eV — 견고하지 않다.** 불확실성이 값과 같은 크기이고, 두 원출처가
  서로 다른 온도의 갭(0.41 vs 0.34 eV)을 쓴 탓이 차이의 절반이다.
- 비교: InN +1.13 eV(N_ss≈1.6×10¹³ cm⁻²), In₂O₃ +0.40(7.2×10¹²), **InAs ≈+0.1(0.5–1×10¹²)**.
  InAs가 셋 중 가장 얕게 걸쳐 있다 → 축적층이 가장 약하고, **그래서 표면 화학으로 극성을 흔들 수 있다**.

## ⚠ 우리 계산에 대한 금지사항
**HSE06(AEXX=0.25)+PBE-d로 "CNL이 CBM 위/아래"의 부호를 증명하려 들지 말 것.**
갭 오차(0.1–0.3 eV) > CNL−CBM 간격(0.05–0.2 eV)이라 부호가 계산 오차 안에서 뒤집힌다.
대신 **0.50 eV(VBM 기준)를 실험 입력으로 받고**, 우리 결과가 거기 착지하는지를 검산으로 쓸 것.
[[feedback_model_first_not_precision]]과 같은 태도.

## ★ 공짜 함수 검증 — Tersoff 지름길이 InAs에서 정확하다
`E_B ≈ ½(Ē_V + Ē_C)`, `Ē_V = E_VBM − Δ_so/3`, `Ē_C` = **간접(진짜 최저) CBM**.
InAs: Δ_so=0.38 → Ē_V = −0.127. 간접 최소 = **L 골짜기 +1.133 eV**(0 K: Γ 0.417 < L 1.133 < X 1.433).
→ `½(−0.127+1.133) = **0.50 eV**` — Mönch 표 값과 정확히 일치.
**우리 벌크 InAs HSE06+PBE-d EIGENVAL에서 세 줄로 재현 가능.** 갭 하나 맞추는 것보다 강한 검증이고
[[charged_defect_vbm_ref]]의 VBM 기준 전체를 정당화한다. 더 정확한 방법은 BZ 평균 미드갭
(Schleife 등 APL 94, 012104 (2009) — ~/papers에 아직 없음, N_v·N_c 관례에 0.1 eV 의존).

## ★ 즉시 쓸 수 있는 검산 — 자기무모순 E_F vs CNL
슬랩 결함 세트로 전하 중성 조건을 풀어 얻은 E_F^SC가 **E_VBM + 0.5 eV 근방**에 착지해야 한다.
- 훨씬 높다 → 보상 억셉터 누락(V_In, Cl 억셉터, As_i)
- 훨씬 낮다 → 도너 누락, 또는 μ 조건이 도너에 불리
- 착지한다 → 결함 세트가 완결적이라는 **독립 증거**(논문에 그대로 쓸 수 있음)
⚠ 슬랩 결함은 면밀도(cm⁻²) → 비교 대상도 N_ss ≈ 10¹² cm⁻². [[bandfill_correction_stage]]·slabcc 보정 **후**의 E_f로 할 것.

## ★ 양자구속이 CNL 논리를 깬다 = 우리 프로젝트의 정당화 (내 추론, 논문 밖)
CNL은 존 전역의 무거운 밴드 평균이라 벌크 VBM에 거의 붙어 있는데, 구속은 1S_e만 크게 올린다
(m_e*=0.023 vs m_hh*=0.41 → 구속 증가분의 ~95%가 전자 몫).
- 벌크 InAs: CNL이 CBM 위 → 축적층·불가피한 n형 ✔
- 4 nm QD(E_g≈1.0): 1S_e ≈ VBM+0.97 vs CNL ≈ VBM+0.50 → **CNL이 갭 한가운데**(−0.47 eV).
  전자 몫을 70%로 보수적으로 잡아도 −0.31 eV로 결론 불변.
→ **ADM을 그대로 적용하면 4 nm InAs CQD는 준절연성이어야 하는데 실제로는 universal n-type.**
→ **CQD의 n형은 벌크 CNL을 상속한 것이 아니다. 표면 화학양론(In-rich, X-type 할라이드, 점결함)이 원인이다**
  = [[cqd_ntype_origin_goal]]의 정당화. 논문 서론에 그대로 쓸 수 있는 논증.
⚠ 이것은 두 논문의 주장이 아니라 내 추론 — 위 Tersoff/BZ평균 계산으로 뒷받침하기 전엔 가설로만 서술.

## 우리 기존 결과의 재해석 (한 문장)
**InAs는 Γ-CBM이 CNL 아래로 내려앉은 물질이므로 표면 도너의 "자연스러운 자리"가 갭이 아니라 전도대 안이다.**
→ [[cl_shallow_donor_no_gap_state]]의 "갭 무게 0", [[shallow_donor_inas_supercell_limit]]의 a_B=349 Å,
CTL 부재가 모두 **한 원인의 세 얼굴**이다. 계산의 결함이 아니라 InAs가 어떤 물질인가에 대한 진술.

## 부수 사실
- **In 4d를 valence에 넣는 이유의 물리**: 양이온 d ↔ 음이온 p의 **p–d 반발**이 VBM을 위로 민다.
  4d를 코어에 얼리면 VBM 위치가 틀어지고 VBM 기준으로 정의된 모든 CTL이 함께 틀어진다.
- **Burstein–Moss = 실험판 band-filling**. 1986–2000년대 "InN 갭 1.9 eV" 정설의 정체가 바로 이것
  (결함 → ADM이 E_F를 branch point 1.83 eV까지 밀어올림 → 흡수단이 밀림). 우리 슈퍼셀이 매번 같은 오차를 만든다.
- In₂O₃ 논문 파일명이 `..._In2O3 PRB(2008).pdf`이지만 **실제 저널은 PRL 101, 116808**. 인용 시 주의.
