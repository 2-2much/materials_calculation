---
name: inas110_bare_q0_charged_dfe
description: "11-110bare 하전 14잡 + DFE/CTL 결과, 그리고 09/plot10 형식 요약그림 파이프라인(04-summary). ⚠기준 '갭'이 표면상태라 band-filling·얕은/깊은 분류 재검토 필요"
metadata:
  type: project
---

2026-08-14~18. `11-110bare_6L_par3x2_PBE-d`. q0 13셀 → 하전 14잡 → DFE.
셀·빌드는 [[inas110_bare_par3x2_pure_cell]], q0 밴드 판정도 거기.

## ⚠ 먼저: 기준선이 표면 상태다

아래 모든 "갭 / VBM / CBM" 은 **표면 As DB → 표면 In DB** 간격(0.450 eV)이지
host 갭이 아니다. 반드시 [[inas110_bare_surface_state_gap]] 을 같이 읽을 것.
그래서 **band-filling 값과 얕은/깊은 분류는 잠정**이다.

## 하전 상태 선택 (config/defects.yaml, q0 서명 근거를 주석으로 박아둠)

| 결함 | charge_states | 근거 |
|---|---|---|
| V_In | `[0, 1, -1]` | 반점유 준위가 갭→CB 걸침, 양방향 |
| V_As | `[0, 1, -1]` | 갭 안(−0.351…−0.133) 반점유, 9.4× |
| In_As | `[0, 1, 2]` | VBM+0.16 채워진 준위, 9.7× |
| Cl_In | `[0, -1, -2]` | VBM+0.34 폭 0.066 **완전히 빈** 준위, 14× |
| Cl_As | `[0, 1, 2]` | 2 e 비국소(2.0×) |
| In_i1 / In_i2 / Cl_i2 | `[0, 1]` | 1 e |
| Cl_i1 | `[0, -1]` | 정공 1 |
| As_In / Cl-In_i1 / Cl-In_i2 | `[0]` | closed shell, 갭·CB 모두 빔 |

14잡 = cascade 4노드×36, NCORE=18/NSIM=36. 출발 기하는 이완된 q0 CONTCAR
(`strategy: q0_contcar`). 27개 case-charge 전부 4 stage 완료.

## CTL (band-filling 후, 조건 무관) — ⚠ **image-charge 보정 없음**

| 결함 | 전이 | ε (VBM 기준) |
|---|---|---|
| Cl_As | +2/+1 | 0.115 |
| Cl_i1 | 0/−1 | 0.145 |
| Cl_i2 | +1/0 | 0.321 |
| **V_In** | **+1/0** | **0.337** |
| In_i2 | +1/0 | 0.389 |
| Cl_As | +1/0 | 0.397 |
| **V_In** | **0/−1** | **0.404** |

★ V_In 이 양방향(+1/0, 0/−1)으로 **0.067 eV 간격** — q0 가 좁은 창에서만 안정한
negative-U 근처. 보정이 0.2~0.5 eV 급으로 들어올 수 있어 **순서가 바뀔 수 있다.**
In_i1·V_As·In_As·Cl_In 은 갭 안 CTL 없음.

E_f (In-rich @VBM/@CBM, eV): V_In 1.759/2.051 · V_As 0.826 · As_In 0.946 ·
In_As 0.626 · Cl_In 1.022/0.572 · In_i1 0.043/0.493 · In_i2 −0.221/0.169 ·
Cl_As −1.588/−1.075 · Cl_i1 −1.227/−1.532 · Cl_i2 −1.149/−0.828 ·
Cl-In_i1 −1.485 · Cl-In_i2 −1.558. As-rich 는 In↔As 화학퍼텐셜만큼 이동.
⚠ Cl 계열이 −1 eV대 음수인 건 μ_Cl=½Cl₂ 규약 탓 — **하한으로 읽을 것**
([[inas100_mu_cl_convention_cl2]], [[cl_as_negative_eform_reference_slab]]).

## 04-summary — 09/plot10 형식 요약그림

`extract_vac.py` → `bandsdos.py` → `plot13.py` → `fig_bands_dos_all13.png`.
09 `results/` 를 그대로 옮기되 두 곳을 바꿨다(둘 다 이 트리 고유의 함정):

1. ★ **진공 창을 pseudo-H 면(z≈1–5.5 Å)에 고정.** 09 처럼 "가장 평탄한 창"을 자유
   탐색하면 Cl-In_i1/Cl-In_i2/Cl_i1 만 **위쪽 면**을 잡아 0.15~0.3 eV 어긋난다.
   dipole correction 이 꺼져 있어 두 진공면 전위가 다르고, 셀마다 동일하고 결함이
   없는 건 H 면뿐. 잔여 평탄도 0.012~0.111 eV 가 정렬 오차의 정직한 값.
2. ★ **E_F·점유도를 전부 02_G221-DOS 에서.** 03_Band(Line-Mode, ICHARG=11)의 E_F 는
   경로에만 맞춰져 무의미하다. 그대로 쓰면 Cl_As·In_i1 이 CBM 위 0.57 eV 로 찍히고
   요약 막대의 occupied/half-filled 절반이 틀린다. 두 stage 가 밴드 인덱스를 공유하므로
   02 의 k가중 밴드별 점유도를 03 분산에 얹으면 된다.

진공정렬 후 pure: VBM −4.9209 / CBM −4.4705 / 간격 0.4504 eV (비정렬 분석과 일치).
⚠2026-08-18: **이 −4.92 를 IP 로 인용하지 말 것.** 기준면이 pseudo-H 면이라 IP 로는
반대쪽 면이고, 엣지도 host 가 아닌 표면상태다 → [[inas_surface_ip_ea_plan]]
E_F 사다리(pure VBM 기준): Cl_i1 −0.306 < Cl-In_i2 −0.184 < Cl-In_i1 −0.167 <
As_In −0.013 < Cl_In −0.004 < pure +0.005 < In_As +0.138 < V_As +0.261 <
V_In +0.517 < In_i2 +0.840 < In_i1 +0.859 < Cl_i2 +0.874 < Cl_As +0.954.

## 남은 일 (우선순위)

1. **02 를 ISMEAR=0 (SIGMA 0.05) 로 전량 재실행.** tetrahedron 이 per-state 점유를
   음수/1초과로 만든다(V_As −0.29, In_i2 +1.30, Cl_i1 −0.27, V_In +1.22).
   k가중 총합은 정확하지만 IPR 게이트·band-filling 은 오염된다
   ([[dos_2x2x1_tetrahedron_occ_overshoot]]). ⚠ 중성까지 포함해 27개 전부 —
   footing 을 섞으면 안 된다.
2. **표면상태 기준선 문제 해결** ([[inas110_bare_surface_state_gap]]).
3. 깊은 4종에 CoFFEE/SCPC 보정(비직교라 slabcc 불가), 얕은 5종은 shallow-limit 작도
   ([[shallow_limit_dfe_construction]]).

그림 경로: `04-summary/` (fig_bands_dos_all13, bands_grid, dos_grid, gap_states.csv,
README), `03-band_analysis/` (결함별 개별 밴드), `results/DFE_plots/`.
