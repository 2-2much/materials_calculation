---
name: pbe_then_hse_workflow_plan
description: "결함 계산 2단 전략 확정: 셀(in-plane+두께) 확정 → PBE로 여러 결함 스크리닝 → HSE06으로 이어서 relax 및 자성 재판정. PBE 자성 판정은 최종이 아님"
metadata: 
  node_type: memory
  type: project
  originSessionId: bc80c5b5-7478-4d31-a59b-c06425588c04
  modified: 2026-07-28T02:08:41.890Z
---

2026-07-28 사용자 확정. 결함 계산은 **범함수 2단**으로 간다.

```
① 셀 확정        in-plane 크기 + 두께(8 ML)를 수렴 스캔으로 먼저 고정
② PBE 단계       그 셀에서 여러 결함 종류를 넓게 계산 (스크리닝·경향)
③ HSE06 단계     ②에서 추린 것에 대해 이어서 relax 및 자성 계산
```

②를 최종 결론으로 쓰지 않는다. ③이 판정자다.

## 왜 이 순서인가 — PBE 자성 판정이 실제로 뒤집힐 수 있음을 정량화했다

`04-inplane_100_As_In-Cl` p4×3 에서 실측:

- Γ-only 이완은 `mag = 0.74 μB` 로 **국소 라디칼**처럼 보인다.
- 그러나 k 를 제대로 뽑으면(2×2×1) **세 셀 모두 `mag = 0.0000`** (p4×3/p4×4/p4×5).
  결함 밴드가 0.46~0.62 eV 로 넓어 host CB 와 겹치므로 교환분열이 모멘트를 못 버틴다.
- **`NUPDOWN=1` 로 doublet 을 강제하면 `+183 meV`** (같은 기하·같은 k·같은 NBANDS,
  `NUPDOWN` 만 다름. 구속해는 항상 ≥ 비구속해이므로 "낮은 쪽이 이긴다"로 읽지 말 것).

⇒ **PBE 수준에서는 무자성·비편재 해가 확고**하다. 그런데 **183 meV 는 하필 혼성범함수가
일상적으로 뒤집는 크기**다 — PBE 의 자기상호작용 오차는 비편재 해를 계통적으로 유리하게
만들고, HSE 는 국소 상태를 보통 수백 meV 안정화시킨다.
⇒ 그래서 이 값은 "국소해가 없다"가 아니라 **"HSE 가 넘어야 할 문턱이 183 meV"** 로 읽는다.

⚠ 미측정 항: 위 183 meV 는 **기하 고정**에서 잰 값이다. doublet 상태에서 이온을 이완하면
polaronic self-trapping 으로 일부를 되찾을 수 있다. 엄밀히 하려면
`NUPDOWN=1` + 이온 이완을 한 번 돌려야 한다(아직 안 함).

## ③ 단계에서 이월할 실무 사항

- HSE 는 비싸므로 ② 에서 추린 결함만. 셀은 ① 에서 확정된 것을 그대로.
- ⚠ HSE + dipole correction 은 과거에 **SCF 미수렴** 이력이 있다
  ([[surface_defect_dipole_correction]]). PBE 에서 먼저 확인할 것.
- ⚠ HSE 는 `PRECFOCK` 이 결과를 40~60 meV 밀어올린다 — 프로젝트 표준은
  **Normal 로 통일**([[mu_reference_phases]]).
- 자성 초기화는 targeted MAGMOM (`set_magmom.py`, As_In 클러스터 2 μB) 을 쓸 것.
  Γ 단독 판정은 믿지 말 것 — 위 사례가 정확히 그 함정이다.

관련: [[inas100_inplane_scan_todo]] [[inas100_8ml_thickness_verdict]] [[cqd_ntype_origin_goal]]
[[spin_magnetism_ipr_predictor]]
