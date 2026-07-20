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

## 진행 상황 (2026-07-20 갱신)

**1. 미수확 slabcc 잡 — 해소 완료.** 공란+submitted는 **V_Cl-Cl_As q+1(55381)·q+2(55382) 딱 2개**뿐이고 나머지는 전부 done. 두 slabcc.out 모두 `[critical] ... model charge is fairly delocalized!`로 자체 중단(큐 비었음=정상 실패). IPR 게이트상 delocalized라 **수확 대상 아님** → "correction N/A (delocalized)"로 확정. 더 볼 것 없음.

**3. Cl-As_In q-1 판정 — bound (deep) 확정.** IPR 3.93× + E_relax 0.277(bound) 일치. slabcc E_corr=0.142(done) 유효. Cl-As_In 전 하전(−1/0/+1/+2) 전부 bound.

**4. shallow 기준 + acceptor 작도 — 구현·검증 완료(2026-07-20).** 상세 [[ipr_gate_tool]] [[shallow_limit_dfe_construction]]. fork 검증에서 CSV 컬럼 스왑 버그·band-filling 부호·auto-inference 과잉 3건 잡아 수정 완료.

**2. k-point 수렴성 계획 — 확정(미제출).** 아래 별도 섹션.

### (옛 1번 원문 보존)
`02-Cl-passv.../results/corrections/slab_slabcc/slab_corrections.csv`와 `corrections_optimize_charge_position_yes_Gam-only/`에 `status=submitted:55361`~`55382`인 채 **E_corr이 공란인 행**. ⚠`coverage`의 `missing E_corr: 0`은 거짓(status=submitted를 pending으로 분류해 놓침).

## k-point 수렴성 테스트 계획 (2번, fork 검증 반영)
**필요함**(LDA bare-As_In 선례 전이 불가): bare→Cl passivation 밴드모서리 변화 / As_In(절연체 중성)→V_Cl-Cl_As q0(CB 부분점유=느린 수렴) / LDA→HSE(gap·m* 변화가 band-filling 크기·수렴속도 결정) / band-filling은 Γ-only에서 0.
LDA 선례 수치: Γ 형성E ~80meV 과소, 2×2×1 ~15meV, 3×3×1 ~4meV 수렴(하한선).
**조건**: 대상=**V_Cl-Cl_As q0 + pure(매 mesh 둘 다)**. **Single-shot on fixed Γ-relaxed geom**(재이완 X). **ISPIN=1**(둘 다 비자성). **Γ-centered 필수**(CBM@Γ, MP-miss-Γ 금지). **aspect-matched**(3×2 셀→3×방향 k 적게, 예 2×3×1/3×4×1), z×1. **ISYM=0**(단일전자 CB 점유 평균화 방지). 2단: Tier-1 PBE-d로 mesh만 특정(⚠PBE는 gap 붕괴→**총에너지 차이 plateau 위치만** 신뢰, band-filling 절대값은 금지), Tier-2 HSE06 Γ/2×2×1/수렴mesh로 확정. **수렴 목표량=보정후 E_f=E_f_raw−E_bf(k)**(각 조각보다 빨리 수렴). 4×4×1도 미수렴이면 근본해법=lateral 셀 확대(3×2→4×3).

**2. 04-InCl3 spin screening 배치 복구** → 상세는 [[spin_screening_04_incl3]].
11개 중 2개만 완주(As_In −0.7meV, pure −0.3meV, 둘 다 비자성). 8개는 `01_Spin-gam-relax/`에 **POSCAR가 없어 미실행**(원인 규명 먼저), Cl-As_In은 walltime SIGTERM(NELM/walltime 상향 후 재제출).

**3. Adiabatic DFE 알고리즘 플랜 재개** → [[adiabatic_dfe_algorithm_plan]]. 미해결 결정 4개(seeding/shallow-correction분기/cross-defect기준/E_corr재사용). 플랜모드로 이어가기로 했었음.
※ 이 중 "shallow-correction 분기"는 오늘 [[ipr_gate_tool]]이 사실상 답을 준다 — 게이트가 shallow로 찍으면 보정 자체를 건너뛰고 CTL을 만들지 않는 쪽.

**4. band-filling(Moss-Burstein) 보정 — 오늘 새로 드러난 최대 구멍.** 상세 [[shallow_limit_dfe_construction]].
파이프라인에 **아예 없다**(`grep band.?fill|moss|burstein scripts/` → 0건). V_Cl-Cl_As q0에서 **~0.78eV** = 형성에너지와 맞먹는 크기라, **V_Cl-Cl_As 선이 틀린 규모는 E_corr의 ~0.1eV가 아니라 이쪽 ~1eV**다.
⚠단 **지금 상태로 구현하면 어떤 기준을 쓰든 틀린 숫자가 나온다**: 에너지를 뽑는 `00_Gam-relax`가 Γ-only라 자기 기준 band-filling을 **0으로 오판**(4k 기준 0.33 / 셀-내부 0.78 — 기준별로 제각각). **k-mesh 상향(4×4×1↑)이 선행**이고 근본 해법은 **lateral 셀 확대(3×2→4×3)**. 순서상 아래 5번보다 뒤.

**5. Cl-As_In q-1 판정** — [[ipr_gate_tool]]로 즉시 가능(계산 불필요). 유일한 미확정 케이스: E_relax 0.277(국소적)인데 slabcc RMSE 경고, spin-down 준위(VBM+0.9~1.4eV) 안에 CBM=1.19가 들어옴. `03_Band` PROCAR에서 LUMO의 atom36 IPR — 6× uniform 이상이면 bound, 1.2×면 CB.

## 열려 있는 판단
- ~~V_Cl-Cl_As 같은 shallow donor의 DFE를 논문에 어떻게 제시할지~~ → **작도법은 2026-07-17 확정**: [[shallow_limit_dfe_construction]] (E_f(+1,E_F)=E_f(0)+(E_F−E_g), 점선/bound 표기, CTL 없음). **남은 결정은 band-filling 보정을 넣은 뒤 최종 수치를 어떻게 인용할지**와 [[cqd_ntype_origin_goal]] 판정 형식.
- E_f(V_Cl-Cl_As q0)는 이미 In-rich −1.08eV인데 band-filling 보정 시 **더 음수로** 내려감 → 표면 donor 안정성 주장이 강해지는 방향. n-type origin 결론에 직접 영향이라 확인 필요.
- difference DOS는 pure(`LREAL=A`/ISPIN=2/NBANDS=450) vs defect(`LREAL=.FALSE.`/ISPIN=1/NBANDS=740) 불일치로 **불필요 판정**(증거 4종으로 충분). 되살릴 이유 생기면 설정부터 맞출 것.
