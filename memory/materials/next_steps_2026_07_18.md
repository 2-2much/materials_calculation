---
name: next_steps_2026_07_18
description: "2026-07-17 세션 종료 시점의 미결 작업 3건 — 미수확 slabcc 잡, 04-InCl3 spin 배치 복구, adiabatic DFE 플랜. 내일(2026-07-18) 이어서"
metadata: 
  node_type: memory
  type: project
  originSessionId: c6f88bf4-31fa-4e2c-90db-76d7de8a9d21
---

2026-07-17 세션 종료 시점. 오늘 끝낸 것과 내일 집을 것을 분리해 둔다.

## 오늘 완료 (재작업 금지)
- V_Cl-Cl_As n형 미시기원 **증거 4종 확정** → [[vclclas_cohp_donor_evidence]]. 더 볼 것 없음.
- IPR 게이트 자동화 → [[ipr_gate_tool]], 전 defect 판정표는 [[slabcc_delocalized_defect_policy]].
- CTL_summary 가짜 0.99eV 버그 **수정 완료** → [[slabcc_delocalized_defect_policy]].
- COHP charge spilling은 **문제가 아니었음**(0.86%=우수, 742는 LOBSTER ZVAL 오집계) → [[lobster_cohp_setup]].

## 내일 할 일 (우선순위)

**1. 미수확 slabcc 잡 확인** — 오늘 새로 드러난 사안.
`02-Cl-passv.../results/corrections/slab_slabcc/slab_corrections.csv`와 `corrections_optimize_charge_position_yes_Gam-only/`에 `status=submitted:55361`~`55382`인 채 **E_corr이 공란인 행이 다수**다. 큐는 비었으므로 이미 끝났거나 죽었다. 각 `slabcc.out`을 열어 실제 결과가 있는지 확인하고 수확할 것.
⚠단 [[ipr_gate_tool]] 판정상 **bound인 것만 수확 가치 있음**: Cl-As_In(전 하전), V_Cl-Cl_In q0. V_Cl-Cl_As·As_In은 수확해도 **쓰면 안 된다**(delocalized → 범주 오류).
⚠`coverage`의 `missing E_corr: 0`은 거짓 — status=submitted를 pending으로 분류해서 놓친다.

**2. 04-InCl3 spin screening 배치 복구** → 상세는 [[spin_screening_04_incl3]].
11개 중 2개만 완주(As_In −0.7meV, pure −0.3meV, 둘 다 비자성). 8개는 `01_Spin-gam-relax/`에 **POSCAR가 없어 미실행**(원인 규명 먼저), Cl-As_In은 walltime SIGTERM(NELM/walltime 상향 후 재제출).

**3. Adiabatic DFE 알고리즘 플랜 재개** → [[adiabatic_dfe_algorithm_plan]]. 미해결 결정 4개(seeding/shallow-correction분기/cross-defect기준/E_corr재사용). 플랜모드로 이어가기로 했었음.
※ 이 중 "shallow-correction 분기"는 오늘 [[ipr_gate_tool]]이 사실상 답을 준다 — 게이트가 shallow로 찍으면 보정 자체를 건너뛰고 CTL을 만들지 않는 쪽.

## 열려 있는 판단
- V_Cl-Cl_As 같은 shallow donor의 DFE를 논문에 **어떻게 제시할지** 아직 미정. CTL이 없으므로 (a) q+1 선만 제시하고 "CB에 전자 공여"로 서술하거나 (b) shallow donor 전용 표기를 쓰거나. [[cqd_ntype_origin_goal]] 판정 형식과 함께 결정 필요.
- difference DOS는 pure(`LREAL=A`/ISPIN=2/NBANDS=450) vs defect(`LREAL=.FALSE.`/ISPIN=1/NBANDS=740) 불일치로 **불필요 판정**(증거 4종으로 충분). 되살릴 이유 생기면 설정부터 맞출 것.
