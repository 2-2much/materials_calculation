---
name: mote2_mlff_incar_fixes_and_ladder
description: "04-MD INCAR 실수정 기록(★디스크의 LANGEVIN_GAMMA가 값 1개였다 = Te가 thermostat 밖) + Langevin 채택 근거 + ★사다리 개정(300/600 폐기, 1500K 의도적 파괴 단 추가). 설계 본문은 mote2_mlff_md_plan"
metadata:
  type: project
---

2026-09-15~25. **설계 본문은 [[mote2_mlff_md_plan]]** — 여기는 그 뒤에 실제로 고친 것과
바뀐 결론만.

## ⚠ 내가 이번 세션에 한 오답 (정정)
사용자가 "ISIF=0도 가능한가" 물었을 때 **"가능하다, 다만 ISIF=2 권장"** 이라고 답했다.
**틀렸다.** [[mote2_mlff_md_plan]] 에 바이너리 에러 문자열이 이미 기록돼 있다:
`ML_MODE = train is not possible with ISIF = 0 or 1 because the stress tensor is required`.
→ **ISIF=2는 선호가 아니라 필수.** 답하기 전에 플랜 메모리를 먼저 읽었어야 했다.

## ★ 디스크 INCAR 에 실제로 있던 버그 (2026-09-15 수정)
플랜에는 `LANGEVIN_GAMMA = 5.0 5.0` 으로 적혀 있었지만 **`04-MD/INCAR` 에는 값이 하나뿐
(`= 1`)** 이었다. 종별 배열이라 이러면 **Te 가 γ=0 → thermostat 밖(NVE)**. 질량의 2/3가
Te라 온도제어가 무너진다. → `= 5 5` 로 수정.
같이 정리: `LANGEVIN_GAMMA_L`/`PMASS`(ISIF=3 전용, 죽은 태그) 주석화,
`LORBIT`/`NEDOS`/`LVHAR`(MD에서 무의미한 I/O) 끔, `ISEARCH`(VASP 태그 아님) 주석화.

⚠ **디스크 INCAR 가 플랜과 아직 다른 항목**: `POTIM=1.0`(플랜 2.0), `NCORE=16/NSIM=32`
(플랜 4/12@48tasks). 실측 비용([[mote2_mlff_budget_and_scaling]])은 전부 디스크 값
+128/384 랭크 기준이다. POTIM 2.0 으로 가면 비용이 절반.

## Langevin vs Nosé-Hoover — 근거 보강
- ★ **조화진동자 하나는 Nosé-Hoover 로 정준분포를 못 만든다**(교과서적 비에르고딕 사례).
  300 K pristine 2H 가 정확히 그 계 → 가장 중요한 basis 단계에서 가장 위험한 선택
- Step 3 는 **독립 궤적 50~100개**가 필요한데 Langevin 은 seed 만 바꾸면 진짜 독립.
  Nosé-Hoover 는 결정론적이라 상관이 남는다
- ⚠ **MSD/확산계수/VDOS 를 재려면 Langevin 금지**(γ가 직접 오염) → Langevin 으로 평형화 후
  **NVE 로 전환해 production 측정**. 또는 CSVR(전역 KE 재조정: 에르고딕 + 동역학 보존)

### γ는 작을수록 좋다 (Kramers)
장벽 넘는 rate 는 마찰에 대해 **중간이 최대**, 과감쇠면 ∝1/γ. **격자 자체가 이미 열욕**이라
Langevin γ 는 그 위에 얹는 **인공 마찰**이다. → 온도제어가 유지되는 최소값.
**학습 5 ps⁻¹ / Step 3 탐색 1~2 ps⁻¹.**

## ★ 사다리 개정 (2026-09-17, 사용자 지적 반영)
내가 제안한 300→600→900→1200 중 **300 K 단의 근거가 약했다**: 300 K 배치는 1200 K 배치의
**부분집합**이라 뜨겁게 학습하면 자동으로 덮인다. 살아남는 논거는 다른 것 —
**산출물이 quench 된 0 K 최소점의 에너지 순위**라 저온 정확도가 필요하다. 그런데 그건
300 K 5 ps 가 아니라 **0 K 근방 소량**(100 K, 200 step)이면 된다.

| 구간 | T | 길이 | 목적 |
|---|---|---|---|
| seed | ~100 K | 200 step | quench 정확도 |
| main | 900 K | 3~5 ps | 탐색이 실제로 살 온도 |
| hot | 1200 K | 3~5 ps | 커버리지 상단 |
| **break** | **1500 K+** | 1~2 ps | **의도적 파괴**, V_Te 셀에서. 안 깨지면 더 올릴 것 |

★ **깨뜨리는 건 학습에서 한 번, 탐색에서는 절대 안 한다.** 결합 끊김을 못 본 FF 는 탈착
온도를 예측할 수 없다 — break 단이 있어야 T_c 가 외삽이 아니라 측정이 된다.
반대로 Step 3 에서 녹이면 quench 결과가 비정질 쓰레기가 된다. 창 = T_hop < T < T_collapse.
(플랜의 `nfree>0 즉시 중단` 규칙은 **탐색·생산 런에 적용**, break 단에는 적용 안 함.)

## Arrhenius — 앙상블 기준 (플랜의 20 ps 단일궤적 표와 상보)
ν=10¹³ s⁻¹ 평균대기시간: ΔE=1.0 eV 는 1200 K 에서 1.6 ns, 1.5 eV 는 200 ns.
**독립궤적 100개 × 300 ps = 총 30 ns** → 1.0 eV 는 ~19회, 1.5 eV 는 0.15회.
→ **FF 탐색의 실용 장벽 천장 1.0~1.2 eV, 작동온도 1000~1200 K.**

관련: [[mote2_mlff_md_plan]] [[mote2_mlff_budget_and_scaling]]
      [[mote2_mlff_cell_kpoint_policy]] [[mote2_distorted_vte_cell_size]]
