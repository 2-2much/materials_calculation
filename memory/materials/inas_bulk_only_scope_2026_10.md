---
name: inas_bulk_only_scope_2026_10
description: "2026-10-13 사용자 결정 — 학위 마무리는 InAs 벌크 본연 결함만 집중, 표면 결함은 제외. 후보 빅퀘스쳔 = 결함이 E_F를 어디에 고정하나(조사 E_V+0.52·n형 한계)"
metadata:
  node_type: memory
  type: project
  originSessionId: 7aeaeca6-39a5-4f5a-ad79-14c5f040c2ef
  modified: 2026-10-14T00:56:22.171Z
---

2026-10-13 사용자 결정: **표면 결함은 빼고 벌크 결함만** 진행 (석박통합 6년차 말, 벌크 주제 4년째). [[cqd_ntype_origin_goal]]의 CQD/표면 사슬은 당분간 범위 밖 — 벌크 논문은 표면·CQD 연결 없이 독립적으로 서야 함.

**Why:** 졸업 일정 압박 + 방향 막막함. Jiang 2027(HSE 64원자)과 결함 형성에너지 자체가 겹쳐 "HSE 결함 계산"만으론 새로움 부족.

**How to apply:**
- 후보 헤드라인(미확정): "InAs 본연 결함은 실험 숫자를 어디까지 설명하나" — 판정 기준 = 조사 F_lim E_V+0.51–0.55·n_lim 2–3e18(Brudnyi 2005), LT-MBE 1.4e19(Shiba 2007), 무도핑 n(불순물 몫). [[inas_number_hunt_hub]]의 Z2·Z5.
- 확정 조건 3개: ① 하이브리드로 E_FS 재현한 선행연구 없음 확인 ② G9(비평형 앙상블 F_lim, HSE 0) 결과 ③ 교수님 동의. 2026-10-13 기준 셋 다 미완 — "설정됐다"고 말하지 말 것.
- 계산 우선순위: N_c(Kane) 수정·G9·G16 (HSE 0) → As_i + V_In 자리이동형(~20 HSE) → SOC/α 오차막대(~4) → As_In k수렴(~3). 표면 트리 작업은 제안하지 말 것.
- 사용자에게 교수님과 졸업 일정·논문 수 상의를 권함(빅퀘스쳔보다 먼저 필요한 결정).
- 관련: [[feedback_forest_over_trees]] · [[inas_bulk_scfermi_frozen_13]] · [[inas_hybrid_alpha_mu_tuning]]
- ★2026-10-14 교수님 답장(Jiang 비교 메일에 대해): "그럼 저차원 물질에 집중해야할 것 같다. InAs 뿐만 아니라 TMD, II-VI, III-V, perovskite 등 다양한 물질로 확장." → 벌크 단독 논문 방향은 사실상 후순위. 사용자 최종 결정·면담 전. Claude 권고: 물질 나열이 아니라 **차원(3D→2D→1D→0D) 하전결함 에너지**를 공통 축으로(이미 보유: JCC 2D Table II·차원 계층·TRSM 1D BNNT·QD 충전에너지·MoTe2), InAs 벌크 HSE는 3D 기준점으로 재활용. 면담 때 졸업시점·논문 수·"저차원"의 뜻(2D/QD/NW)·방법론 vs 물질 논문을 먼저 확인.
- 2026-10-13 사용자: 새 결함(As_i 배치들, V_In 자리이동형, In_i split 등)은 **PBE로 먼저 빠르게 스크리닝하는 가능성 열어둠**. 쓰임 한정: 같은 결함·같은 전하의 구조(배치) 비교 → 후보 추리기 → PBE 기하에 HSE 1shot([[pbe_geometry_hse_1shot_delta]]: 얕은 18 meV/깊은 97 meV) 또는 HSE 이완. ⚠PBE 벌크 InAs 갭 0(밴드 역전, [[inas_pbe_band_inversion_bulk]]) → CTL·서로 다른 결함 간 형성에너지 비교·CB성 상태 점유가 걸린 전하는 판정 금지.
