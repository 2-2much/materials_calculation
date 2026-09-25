---
name: mote2_mlff_budget_and_scaling
description: "★168원자 MLFF-MD 실측 — 4→12노드 speedup 1.41배뿐(효율 47%)·FF step 0.017s vs DFT step 140s·★FF-only 구간 뒤 DFT step이 비싸진다(9→27 iter, 상한은 cold start 34)"
metadata:
  type: project
---

`~/materials/moTe2/04-MD/00-budget_test/` (2026-09-15). 2H-pristine 7×4, 168원자,
NBANDS=876, NELECT=1456, k 2×2×1(4점), cascade2, 바이너리 6.6.0 dftd4 std.
`t300`(끝냄) / `t1200`(미실행). `submit.sh -n <4의 배수>`.

## ★ 병렬 스케일링이 안 난다 — 4노드가 맞다

같은 구간(NELMDL delay step 1~5) 비교:

| | 4노드 (128랭크) | 12노드 (384랭크) |
|---|---|---|
| iteration당 | **27.0 s** | **19.1 s** |
| speedup | 1.00× | **1.41×** (이상 3.00×) |
| 병렬효율 | — | **47 %** |
| node-second/iter | 108 | **229** (2.12배 비쌈) |

원인: `KPAR=4`가 k점 병렬을 다 썼고 남은 건 밴드/평면파뿐. k-group당 96코어에 876밴드면
통신이 계산을 먹는다. **이 계산의 병렬 한계는 4~8노드.**
⚠ 노드는 4의 배수여야 `NCORE=16`이 유효(KPAR=4 → k-group당 랭크가 16으로 나눠떨어져야).

### 결과: 코어가 아니라 **구조로 병렬화**하라
`ML_AB` 사슬 때문에 20개 세그먼트가 전부 직렬이 된다. 그런데 **pristine은 defect의
부모지만 2H와 1T는 서로 부모가 아니다** → 여기서 사슬을 끊는다.
- Stage A: 2H-pristine / 1T-pristine 각 4노드 동시 (8노드)
- Stage B: 2H-V_Te, 2H-distort_V_Te ← 2H부모 / 1T-V_Te ← 1T부모, 각 4노드 (12노드)
- Stage C: 전체 `ML_ABN` 병합 → `ML_MODE=refit`
⚠ 전제 = **ML_AB 병합이 되는지 먼저 확인.** 안 되면 계통별 FF 2개가 되고,
그러면 2H vs 1T′ 에너지 비교는 불가(단 2H 내부 탐색만이면 무방).

## 실측 비용 (12노드, 300 K, 26 step / 49분)

| 항목 | 값 |
|---|---|
| FF-only step | **0.017 s** |
| 일상 DFT step | 9 iter ≈ 140 s |
| f (step 12~26) | **13 %**, 감소 중 |
| LOOP: iteration | 13~19 s (평균 ~16) |

세그먼트(5000 step) 추정: f=0.05 → ~17 h, f=0.02 → ~7 h.

## ★★ FF-only 구간 뒤 DFT step이 비싸진다 (내재적, 설정 오류 아님)

판정자 = 각 ab-initio step의 **첫 DAV iteration의 dE**:

| step | 직전 FF 구간 | first-dE | iter |
|---|---|---|---|
| 1 | — (**진짜 cold**) | **9843** | 34 |
| 2~11 | 없음 | 0.019 → **0.126** | 9 |
| 22 | 3 step | 0.766 | 15 |
| 27 | 4 step | 0.909 | 15 |
| 18 | 6 step | 1.505 | **27** |

- **cold가 아니다** — step 18은 1.5 eV, 진짜 cold는 9843 eV (4자리 차)
- 원인: VASP는 **직전 두 이온스텝의 전하밀도로 외삽**하는데 FF step에서는 전자구조를
  안 푸니 이력이 갱신되지 않는다. gap 길이에 따라 dE가 **단조 증가** = 예상되는 거동
- VASP가 자동 선택한 값은 `IWAVPR = 11`(전하밀도 외삽만). 12/13은 파동함수 외삽 추가 →
  **A/B 테스트 가치 있음**(50 step, 30분). 단 모드 의미는 6.6.0 문서 확인 후
- ★ **벌칙에 상한이 있다**: 아무리 길어져도 cold start 34 iter를 못 넘는다 → 예산 발산 없음
- 순이득: AIMD 9.0 iter/step vs MLFF(f=13%,20iter) 2.6 → 3.5배. f=5%면 9배

## ⚠ 고온은 이중으로 비싸다
연속 DFT 구간에서도 first-dE가 0.019→0.126으로 **단조 증가**한다(MD가 열속도를 얻으면서
step당 이동이 커짐). **1200 K는 속도 2배 → 외삽오차 3~4배** → f가 높아져서만이 아니라
**DFT step 하나하나가 더 비싸다.** 300 K 숫자로 고온을 추정하면 두 경로로 동시에 과소추정.
→ `t1200`을 반드시 잴 것.

관련: [[mote2_mlff_md_setup]] [[cascade2_sbatch_workflow]]
