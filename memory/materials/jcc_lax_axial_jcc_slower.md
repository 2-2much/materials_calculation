---
name: jcc-lax-axial-jcc-slower
description: "★(2026-09-24 정정) L⊥ 고정 축방향 스캔엔 극한이 없다 — L_ax>L⊥에서 국재전하가 시트 적층이 되어 +B·L_ax 선형 발산. 3DJM·JCC 공통, JCC는 못 지운다"
metadata:
  node_type: memory
  type: project
  originSessionId: eafb2d09-8f08-441f-b989-00f185229f85
  modified: 2026-09-24T03:55:01.848Z
---

kohn `~/materials/__JCC-reproduce__/15-Lax_scan_BNNT` · V_N^{+1} in (3,3) BNNT · L⊥ = 25 Å 고정 · Γ-only · 매 n 이완.
6점(n3~n18) 전부 이온수렴. 수치는 `results_VN.txt` / `dHf_vs_Lax.dat`.

| n | L_ax | δE₀ | ΔH_f(3DJM) | ΔH_f(JCC) |
|---|---|---|---|---|
| 9 | 22.575 | −0.487 | 4.6159 | 4.1290 |
| 12 | 30.100 | −0.360 | 4.6214 | 4.2611 |
| 15 | 37.625 | −0.284 | 4.6416 | 4.3573 |
| 18 | 45.150 | −0.235 | 4.6708 | 4.4362 |

## ★ 정정 (2026-09-24): "3DJM 은 n9 에서 수렴"은 우연이었다
3DJM 증분은 n9→12→15→18 에서 +5 → +20 → +29 meV 로 **가속**한다. 1/L 오차라면 줄어야 한다.
정체 = **L_ax > L⊥ 이면 국재 전하 배열이 z 로 쌓인 대전 시트**가 되어 2D 의 L_z 젤리움 항이 축방향에서 부활:
- 점전하+젤리움 Ewald(ε=1): n15→18 기울기 12.04 meV/Å = πe²/(6L⊥²) 12.06 (시트 영역 진입 확인)
- 맞춤 H + A/L + B·L (n≥9): 3DJM B = 5.9, JCC B = 5.7 meV/Å (≈ 0.5·B₀), RMS 0.1~0.3 meV
  (1/L 만 맞추면 RMS 10 meV). ‘s·E_M(점전하) + A/L’ 로도 s ≈ 0.46~0.53, RMS 0.2~0.4 meV
- n9 의 평평함 = 감소하는 1/L 항과 증가하는 L 항이 교차하는 **최소점**(L_ax ≈ L⊥)

**Why:** host δE₀ 는 퍼진 선전하라 선형항이 없다(−11.4/L_ax 그대로) → JCC = 3DJM + δE₀ 는 같은 B 를 물려받는다.
JCC 가 지우는 건 **L⊥ 방향 ln 발산뿐**([[jcc_dimension_hierarchy_measured]]의 14번, 414→3 meV).

## How to apply
- **L⊥ 고정 L_ax 외삽 금지** — H∞ 가 모형에 따라 4.2~4.9 eV 로 흔들린다(정의 안 되는 값).
  예전 "1/L 외삽 4.505 / 직접추정 4.62 / |A_JCC|/|A_3DJM| = 2.3(6점이면 6.0)" 은 전부 폐기.
- 1D 묽은 극한은 **극한 순서**가 있다: L⊥ → ∞ 먼저(JCC 가 처리) → 그 다음 L_ax. 또는 L_ax/L⊥ ≲ 1 유지.
- 비교 앵커는 여전히 n9(L_ax 22.575, 논문과 같은 셀): JCC 4.1290 vs 논문 4.187 (−58 meV).
  n9 가 14/L25 앵커와 0.2 meV 일치 → [[bnnt_vn_geometry_transplant]].
- 차폐 인자 ~0.5 의 출처(튜브 축방향 분극 vs 정공 비국재 w=0.62)는 미분리.
