---
name: bandfilling-measured-from-dos
description: 기존 2x2x1 DOS에서 직접 측정한 band-filling ≈0.33 eV — shallow-limit에 수동 주입된 0.78 eV와 2배 이상 불일치
metadata: 
  node_type: memory
  type: project
  originSessionId: f4bfd3d3-c080-491a-b5ba-f0c4ca66ef42
  modified: 2026-07-23T06:57:34.260Z
---

2026-07-20. 02-Cl-passv의 **기존 `02_G221-DOS`(2×2×1, ISPIN=2, ISMEAR=−5)** EIGENVAL에서
추가 계산 없이 band-filling을 뽑았다.

## 방법
점유 가중 평균 `⟨E⟩ = Σ w·occ·E / Σ w·occ` 를 최상위 점유 밴드에 대해 계산, 그 밴드의 최저점과 비교.

| defect | 밴드 | 전자수 | E_min | ⟨E⟩ | 채움 |
|---|---|---|---|---|---|
| **V_Cl-Cl_As** | 370 | **1.0000** | 0.3288 | 0.6588 | **0.330 eV** |
| Cl-As_In | 372 | 1.0000 | −0.4838 | −0.2977 | 0.186 eV |
| As_In | 368 | 2.0000 | −1.1392 | −1.0059 | (0.133 = 단순 분산) |
| pure | 372 | 2.0000 | −1.3789 | −1.1051 | (0.274 = 단순 분산) |

전자수 총합이 네 셀 모두 정확(744/736/743/739)해 계산 신뢰됨.

## 핵심 불일치
`DFE_shallow_limit.csv`에 **수동 주입된 값은 0.78 eV** — 여기서 측정한 0.33 eV의 **2.4배**.
0.78의 출처 계산이 트리 어디에도 없다(CLI `--bandfill DEFECT=EV`로 ad hoc 주입, 재현 불가).
shallow-limit anchor를 −1.078 → −1.858로 **780 meV** 움직이는 항이라 결론에 직접 영향.

⚠ 두 값의 기준이 다를 수 있다: 위 0.33은 **결함 셀 자신의 밴드 최저점** 기준이고,
정식 Lany–Zunger는 **pure CBM** 기준이라 셀 간 정렬(core-level)이 필요하다.
그래도 규모 차이가 커서 0.78을 그대로 쓰기 전에 대조 필수.

## ✅기준 문제 해결 + 용어 정정 (2026-07-23, 교차검증 2인)
위 ⚠는 **맞았다**. 0.330/0.186은 **결함 밴드 자기 최저점** 기준이라 Lany–Zunger 항이 아니다.
**pure CBM 기준으로 환산하면 V_Cl-Cl_As = +0.219 eV**(pure 2×2×1 CBM=+0.4397 Γ 기준). 0.330을 LZ
band-filling으로 쓰면 **~50% 과보정**.

⚠**"Γ-only가 band-filling을 0으로 오판"은 틀린 표현**이다. Γ-only의 0은 **옳다** — 밴드 바닥엔
Moss–Burstein 항이 없다. Γ-only가 놓치는 건 같은 LZ 스킴의 **다른 가지, PHS pull-down**
(CBM 아래로 끌려간 host 유래 상태를 CBM으로 되돌리는 항, 부호 **반대**: E_tot을 **올린다**).
앞으로 "Γ-only = band-filling 누락"이 아니라 **"CBM 기준 PHS shift 누락"**으로 쓸 것.

**mesh ≡ correction 등가**: 대수적으로만 성립. 두 보정 모두 도너 전자를 CBM에 놓는 처방이라
Γ-only+PHS = mesh+MB = N·E_CBM (**출발점만 다르고 도착점 동일**). ⚠**총에너지로는 검증 안 된다**:
고유값합 ≠ 총에너지. 04 Cl_As_1 q0 동일기하·ISPIN=1·HSE 실측 Γ(00_Gam-relax −562.94316) →
2×2×1(02_G221-DOS −562.99529) = **−0.052 eV**(도너밴드 고유값합 추정 +0.98과 무관, 부호도 반대).
다른 밴드 재적분이 압도. **"+0.98 eV"를 총에너지 변화로 인용하지 말 것.**

## Γ-only는 band-filling을 구조적으로 0으로 오판(⚠위에서 정정됨)
k-분해 가중 적분이라 k점 1개면 정의상 0. **DFE 에너지가 전부 `00_Gam-relax`(Γ-only)에서 나오므로
파이프라인에 band-filling이 반영될 자리가 없다.** 4 k점(2×2×1)도 성긴 적분이라 위 0.33은
추정치로 취급할 것.

관련: [[shallow_limit_dfe_construction]], [[defect_states_02_clpassv]],
[[dos_2x2x1_tetrahedron_occ_overshoot]]

## ✅종결 (2026-08-02) → [[bandfill_correction_stage]]
출처불명 0.78 eV는 **폐기**. DFE가 실제로 읽는 `01_Spin-gam-relax`(Γ, ISPIN=2)에서 계산한
값은 **−0.125 eV**(PHS 가지, E_f를 **올림**). 여기 적힌 0.330(자기 밴드최저점)·0.219(pure CBM
환산)는 **2×2×1 DOS**에서 잰 것이라 DFE 에너지와 다른 계산 → 앵커에 쓰면 안 됨.
Γ에서 PHS만 나오고 mesh에서 MB로 부호가 뒤집히는 것은 k-사다리로 실증됨.
