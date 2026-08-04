---
name: pbe_geometry_hse_1shot_delta
description: "PBE 하전 기하 + HSE 1shot 의 오차 δ 실측 2점 — 얕은 결함 18meV(회수율 8%), 깊은 결함 97meV(회수율 70%). 분기 기준은 IPR 게이트"
metadata: 
  node_type: memory
  type: project
  originSessionId: c112f7c9-ad4a-4a61-8428-865a9d3d4938
  modified: 2026-08-04T02:46:07.146Z
---

2026-08-04. "하전 계산을 PBE로 이완하고 배율만 줘서 HSE 1shot 으로 때울 수 있는가"를 실측한 결과.
자료: `02-Cl-passv_6L_3x2x1_HSE06/__delta_test_{In_i_1,Cl-As_In}_qp1__/`

## 재는 양의 정의 (중요 — 헷갈리기 쉬움)
**δ(q) = E_HSE(q, R_q^PBE) − E_HSE(q, R_q^HSE) ≥ 0**
함수를 **HSE 로 고정한 채 기하만** 바꿔 재므로 함수 오차가 섞이지 않는다.

⚠ **E_PBE(+1)−E_PBE(0) vs E_HSE(+1)−E_HSE(0) 비교는 이 목적에 쓰면 안 된다.**
그건 기하 오차 + **함수 오차**를 섞는다. 실측: In_i_1 에서 PBE **+149 meV** vs HSE **−577 meV**
(부호까지 반대, ~0.7 eV 차이). 1shot 스킴은 PBE **에너지를 안 쓰고 기하만** 쓰므로 무관하다.
그 비교는 "PBE 만으로 전하전이 서열을 매길 수 있나"라는 **다른 질문**의 답이다(→ 못 매긴다).

⚠ 두 전하 다 1shot 이면 최종 오차는 **Δ_CTL = δ(+1) − δ(0)** 로 **부분 상쇄**된다.
δ(0)는 `00_Gam-relax` 의 E[first ionic] − E[last] 로 이미 공짜로 얻어져 있다.

## 실측 2점 (Γ-relax, ISPIN=1 기준으로 통일)

| | **In_i_1 q+1** (얕음) | **Cl-As_In q+1** (깊음) |
|---|---|---|
| E_relax^HSE = δ 상한 | **19.9 meV** | **322.5 meV** |
| **δ(+1)** | **18.3 meV** | **96.8 meV** |
| **PBE 기하 회수율** | **8 %** | **70 %** |
| 전하 유발 이완(기하) | 0.063 Å | 0.260 Å |
| PBE↔HSE 기하 오차 | 0.091 Å | 0.087 Å |
| 신호/잡음 | 0.7 (묻힘) | 3.0 (뚜렷) |

**핵심 관찰: PBE↔HSE 기하 오차는 결함 종류와 무관하게 ~0.09 Å 로 일정하다.**
달라지는 건 전하 유발 이완의 크기뿐이고, 그게 0.09 Å 보다 작으면 PBE 이완이 무의미해진다.

## 운용 결론 (분기)
- **얕은/비국소 하전 상태** → PBE 하전 이완 **생략**. R_q0 기하로 1shot(=기존 `01_opt`/`00_Gam-optical_Rq0`
  단계가 이미 하는 일). 오차 ~20 meV. PBE 하전 이완을 돌려도 1.6 meV 만 벌어 값어치 없음.
- **깊은/bound 하전 상태** → **HSE 직접 이완**. PBE 1shot 으로 대체하면 **~100 meV** 잔차가 남고
  CTL 을 그대로 밀어낸다(합격선 50 meV 초과 → **불합격**).
- 판별자는 **IPR 게이트**(≥6×uniform = bound) + 기존 20건의 E_relax 이분(깊음 132~366 meV vs
  얕음 11~60 meV). 1shot 의 전자구조에서 공짜로 나오므로 추가 비용 없음. → [[defect_states_02_clpassv]]

⚠ **표본 2점뿐**. 깊은 케이스가 하나라 "70% / 97 meV" 의 일반성은 미확인.
다음 점: 04 `In_As_1`/q+1(132 meV) 또는 `In_As_2`/q+1(322 meV) — 둘 다 HSE 참조 완비.

## 방법 함정 (재현 시)
- **배율 위치**: PBE 이완은 **PBE-d 셀에서** 하고 그 뒤 균일 배율(×0.9852099996). HSE 셀에서 PBE 를
  직접 이완하면 면내 −1.48% 압축 → Poisson 으로 z **+1.6%(0.214 Å)** 인공 오차. → [[hse_relax_vs_singlepoint]]
- **δ 비교는 이미 HSE 셀에서 이뤄진다** — 배율은 PBE 기하에만 적용되므로 셀 불일치는 없다.
- ⚠**`ALGO=Damped` 는 cold-start(ISTART=0/ICHARG=2) 단일점에서 발산한다.** E 가 +4.9e4 eV,
  rms 1.7e6 까지 튐. `ALGO=Normal` 로 즉시 정상 수렴(39 전자스텝). Damped 가 유효한 건
  금속성 결함에서 Normal 이 정체할 때뿐 → [[hse_slab_scf_settings]]. 참조 INCAR 를 통째로
  복사하면 이 태그까지 딸려오니 주의.
- ⚠**q+1 이 q0 CONTCAR 를 시드로 잡으려면 `use_nearest_charge_contcar: true` 가 필요**하다
  (`utils_vasp.py:801` 에서 q≠0 경로 전체가 이 플래그로 게이트됨). `use_q0_contcar: true` 만으로는
  안 되고, 조용히 **미이완 `inputs/defects/*/POSCAR`** 로 폴백한다. prepare 후
  `initial_poscar_selection.prepare.json` 의 `selected` 를 반드시 확인할 것.
- **CONTCAR 는 종 라벨을 자른다**(`In_d`→`In`, `H1.25`→`H1`, `In_L`→`In`). 배율/이관 전 6행 복원.
- **STOPCAR(LSTOP)** 은 stage 를 "General timing" 으로 정상 종료시켜 run_case.sh 가 **다음 stage 로
  진행**한다. 막으려면 종료 감지 즉시 `scancel` 하는 감시가 필요.
- 힘 수렴 판정은 **자유 원자만**(Selective Dynamics T). 고정 바닥층·pseudo-H 는 0.29 eV/Å 여도 정상.

관련: [[in_i_hse_port_02_04]] [[in_i_shallow_donor_cl_deactivation]] [[pbe_then_hse_workflow_plan]]
[[optical_correction_adiabatic_rationale]] [[ipr_gate_occdiff_probe]]
