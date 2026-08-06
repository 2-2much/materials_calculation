---
name: ncore_ace_zpotrf_small_cell
description: 작은 셀(plane wave 수백 개)에서 NCORE=18을 쓰면 hybrid ACE의 FOCK_ACE_CONSTRUCT ZPOTRF가 깨진다 — 병렬은 KPAR로
metadata: 
  node_type: memory
  type: project
  originSessionId: a7f8bf6c-3a7a-42dc-878e-32f7d2bd3741
  modified: 2026-08-06T21:55:46.095Z
---

2026-08-07, InAs bulk primitive cell(2원자, HSE06) 에서 확인.

cascade 표준 `NCORE=18`/`NSIM=36`([[cascade_parallel_settings]])을 4노드(144 rank)에 그대로
적용하면 SCF 4스텝 뒤 이렇게 죽는다:

```
FOCK_ACE_CONSTRUCT: LAPACK routine ZPOTRF failed!
```

## 원인 분리 (같은 계산, 4노드 144 rank)
| | 설정 | 결과 |
|---|---|---|
| A | `NCORE=18`, `NSIM=36`, `LSCALAPACK=.FALSE.` | 동일하게 ZPOTRF 실패 → **scaLAPACK 아님** |
| B | `KPAR=8`, `NCORE=1`, `NSIM=4`, `NBANDS=36` | 정상 수렴 |

1노드 `KPAR=6`/`NCORE=1` 도 정상. 즉 **범인은 NCORE**.

## 왜
이 셀은 Γ점 plane wave 가 **645개**뿐. `NCORE=18` 이면 한 밴드의 645개 계수를 18 rank 에
쪼개 rank 당 36개 — ACE(adaptively compressed exchange) 교환연산자의 Cholesky 가 이
입도에서 깨진다. `NCORE=18` 은 100~216원자 슬랩(plane wave 수만 개)용 값이다.

## 처방
작은 셀은 k점이 많으므로(여기선 DOS 72, band 175) **병렬을 전부 `KPAR` 로 넣는다.**
`NCORE=1` + N rank/k-group 이면 밴드병렬 그룹이 N개라 `NBANDS` 는 N의 배수여야 한다
(144 rank / KPAR=8 → 18 rank/group → `NBANDS=36`). 4노드 병렬효율 ≈ 75%.

판단 기준은 노드 수가 아니라 **plane wave 수 / NCORE**. 수백이면 NCORE=1.

관련: [[cascade_parallel_settings]], [[scalapack_mlx_ofi_hang]](다른 증상 — hang),
[[g1_node_vasp_binary_limit]]
