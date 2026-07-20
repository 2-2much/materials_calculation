---
name: spin-stage-symmetry-never-broken
description: 01_Spin 단계가 ISTART=1로 비자성 WAVECAR을 물려받아 MAGMOM이 무력화 — 11개 전부 대칭성을 깬 적 없음. EENTRO≠0이 스핀 미수렴 진단자
metadata: 
  node_type: memory
  type: project
  originSessionId: f4bfd3d3-c080-491a-b5ba-f0c4ca66ef42
  modified: 2026-07-20T05:28:37.456Z
---

2026-07-20 확인. 02/04의 `INCAR_01.Spin-gam-relax`가 **`ISTART=1` + `ICHARG=1`** 이고
`stages.yaml`이 `copy_from_previous: [WAVECAR, CHGCAR]`로 **비자성** 결과를 물려준다.
`runtime.yaml`의 `magnetic_seed`가 MAGMOM을 실제로 써넣긴 하지만, 초기 밀도·궤도가 파일에서
오므로 **MAGMOM은 무시된다**.

## 증거 1 — 자화가 0에서 자라난 사례가 하나도 없음
02 전 결함 자화 이력: **11개 전부 mag(이온 1단계) ≈ mag(최종)**.
자성으로 판명된 Cl-As_In(1.0)·V_Cl-Cl_In(1.0)은 처음부터 mag=1로 시작한 것(점유수 강제)이지
탐색의 결과가 아니다. 즉 이 stage는 **대칭성 파괴를 시도한 적이 없다**.

## 증거 2 — EENTRO가 독립 진단자
홀수 전자계를 ISPIN=2로 제대로 풀면 점유수가 정수로 떨어져 **EENTRO=0**이 되어야 한다.

| defect (q0) | NELECT | 00 σ→0 | 01_Spin_N σ→0 | ΔE(spin) | ISPIN=2 EENTRO/2 |
|---|---|---|---|---|---|
| pure | 744 짝 | −419.22533 | −419.22592 | −0.6 meV | 0.0000 |
| As_In | 736 짝 | −420.82397 | −420.82426 | −0.3 meV | 0.0000 |
| **Cl-As_In** | 743 홀 | −423.16429 | −423.33535 | **−171 meV** | **0.0000** ✓수렴 |
| **V_Cl-Cl_In** | 731 홀 | −413.63645 | −413.90459 | **−268 meV** | **0.0000** ✓수렴 |
| **V_Cl-Cl_As** | 739 홀 | −413.83071 | −413.83148 | −0.8 meV | **0.0282** ⚠미수렴 |
| In_i_Td_In | 757 홀 | −419.62901 | −419.63602 | −7 meV | **0.0224** ⚠미수렴 |

V_Cl-Cl_As·In_i_Td_In은 전자를 두 채널에 0.5씩 뭉갠 채 끝났다. **자성이 "소멸"한 게 아니라
스핀 해를 못 찾은 것.** → 홀수 전자 + ISPIN=2 + EENTRO≠0 = 스핀 미수렴 플래그(무비용 자동화 가능).

## ⚠ 기존 기록 무효화
[[surface_defect_spin_screening_full]]의 *"단일점 스핀 스크리닝은 오판한다
(V_Cl-Cl_As가 −0.975 μB였으나 이완하면 붕괴)"* 는 **무효**다. `spin_test`/`01_Spin-gam-relax`가
**PRECFOCK=Fast**, `00_Gam-relax`/`01_Spin_PRECFOCK=N`이 **Normal**이라 서로 다른 정밀도를 뺀 값이었다.
Fast는 총에너지를 **+40~60 meV** 밀어올린다(As_In에서 ISPIN=2(Fast)가 ISPIN=1(Normal)보다 43 meV
**높게** 나와 변분원리 위반 → 아티팩트 확정). 같은 Normal끼리인 ΔE 표(위)는 유효.

## 조치
1. `INCAR_01.Spin`을 **ISTART=0 / ICHARG=2**로, `copy_from_previous: []`. 그래야 magnetic_seed가 산다
2. **PRECFOCK 전 단계 Normal 통일.** Fast 계열 결과는 봉인
3. 판정 실험: `V_Cl-Cl_As/q0`를 Normal+ISTART=0+MAGMOM 시드로 재이완 →
   **σ→0 기준 −413.83148보다 5 meV 이상 낮고 mag≈1이면 자성 채택**. 보조로 NUPDOWN=1 강제
   - ⚠유보: 도너 전자가 delocalized CB 상태라 교환분열이 셀 부피에 반비례 → **비편극이 옳을 수도** 있다
4. stage `00`의 `dynamic_incar`에서 `SPIN_MODE` 제거(그래야 00은 비자성 유지, 전역 magnetic_seed와 양립)
5. ⚠stages.yaml 주석 블록에 **id 중복**(02는 id"01" 2개, 04는 id"02" 3개) — 통째 해제 시 충돌

에너지 비교는 반드시 σ→0으로: [[energy_column_sigma0_vs_toten]]
