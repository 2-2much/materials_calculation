---
name: inas_number_hunt_hub
description: "InAs 실험논문 \"숫자 사냥판\" ~/papers/InAs/number_hunt_InAs.html — 실험논문 읽을 때마다 여기에 숫자·빈칸·퍼즐을 덧붙인다(렉쳐노트 아님)"
metadata:
  node_type: memory
  type: reference
  originSessionId: 7aeaeca6-39a5-4f5a-ad79-14c5f040c2ef
  modified: 2026-10-13T05:22:28.103Z
---

허브 파일: `~/papers/InAs/number_hunt_InAs.html` (2026-10-13 생성, 단일 파일, 데이터는 하단 `<script>`의 `DATA` 객체).
섹션: 빅퀘스쳔 후보(puzzles) · 빈칸 보드(gaps, 상태 calc/need/open/weak) · 숫자판(numbers, 자동 N번호, mine=내 환산) · 그림 디지타이즈(series) · 논문 카드(papers, 5줄) · 읽을 목록(queue).

**Why:** 사용자가 4년간 빅퀘스쳔을 못 잡은 원인 중 하나 = 실험 문헌을 "검증 근거"로만 읽음. 2026-10-13 결정: 실험논문은 "설명 안 된 숫자" 사냥으로 읽고 한 곳에 모은다. 목적은 여러 논문 숫자를 한눈에 → 빅퀘스쳔 생성. **렉쳐노트처럼 꼼꼼히 만들지 말 것**(사용자 명시).

**How to apply:**
- 사용자가 InAs 실험논문을 주면 렉노 대신 이 파일 DATA에 papers/numbers/gaps/series/queue 항목 추가, 퍼즐 후보 갱신. 숫자 id는 입력 순서로 자동 부여 → 중간 삽입하면 퍼즐의 N참조가 밀리니 **항상 배열 끝에 추가**.
- 원문 그림은 pdftoppm으로 렌더 후 디지타이즈, 환산값은 mine:true.
- 첫 논문: Shiba·Kajikawa JCG 301–302, 256 (2007) LT-InAs. 핵심: δ≈0.6%(GaAs와 같음)·n=1.4e19·[As]≈1.1e20(내 환산; 에이전트들의 1.8e20은 오류)·n/[As]≈0.13·격자 +0.02%(수직)→이완 +0.01%·Fig4 T_g250/300 어닐로 n 증가(미해석)·600 °C 수렴 1e18(미해석). 저자 스스로 As_In 공명도너 가설(Meggitt 1980, Khirouni 1998 근거).
- 2번째: Brudnyi 2005 (Semiconductors 39, 385) 전자 조사. ★**조사 포화 n_lim=(2–3)e18, F_lim=E_V+0.51–0.55 (77–295 K, 13개 시료 위·아래 양쪽 수렴)** — "1.8e19"는 Durand 2013의 잘못된 인용(에이전트 토론에도 이 오류가 들어갔음). 295 K F_lim=CBM+0.16–0.20 ≈ 우리 As_In ε(+1/0)=CBM+0.17. 저자 결함 지정은 비이완 준위계산(In_As/V_As)뿐 → 보유 HSE 세트로 비평형 앙상블 F_lim 재현이 HSE 추가 0의 판정 계산(G9, Z5).
- 관련: [[inas_bulk_scfermi_frozen_13]] · [[feedback_build_on_prior_work_not_critique]] · [[inas_hybrid_alpha_mu_tuning]]
- 2026-10-13 보류함(parked, Q번호) 추가: 막힌 것 한 줄, blocks yes/no, 풀리면 status solved + notion 링크.
- **노션과의 분업(사용자와 합의)**: html = 숫자·빈칸·퍼즐·보류의 *상태판*(Claude가 입력, 짧게). 노션 = 사용자가 **직접 자기 언어로** 쓰는 이해·생각(풀린 보류 설명, Z 선택 이유, 빅퀘스쳔 문장). 같은 내용 두 곳에 쓰지 않기 — html은 노션 링크로만 가리킴. 사용자는 직접 써야 머리에 들어온다고 함 → 노션 내용을 Claude가 대신 쓰지 말 것.
- 3번째: Jiang 2027 (N35–43, G15–18, Z6·Z7). 실험: PL Peak A 0.415/B 0.403 eV(12 meV 아래, As 플럭스↑에 증가), TRPL τ_SRH 3.16e-7 s, Hall 없음. 연결: G16 = 우리 DFE로 753 K As-rich [As_In] → 자릿수 커지면 'As_In 수명 지배'와 긴장(HSE 0).
