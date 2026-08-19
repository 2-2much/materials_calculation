---
name: cascade_parallel_settings
description: "cascade 파티션 표준 병렬 설정 — VASP NCORE=18/NSIM=36, slabcc OMP_NUM_THREADS=36 (노드당 36코어)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 640e3ab2-68c1-49e1-b49b-8fbed2a39915
  modified: 2026-07-22T06:40:42.913Z
---

`cascade` 파티션(tgm-master SLURM)에서 계산할 때의 표준 병렬 설정. **노드당 36코어.**

- **VASP**: `NCORE=18`, `NSIM=36` (+ k-mesh 있으면 `KPAR`로 추가 분할)
- **slabcc**: `OMP_NUM_THREADS=36` (OpenMP 단일노드, 36코어 전부 사용해 빠르게)

**Why:** 사용자가 지정한 cascade 표준값. 코어수에 안 맞는 NCORE는 밴드병렬 그룹 수를 바꿔
NBANDS 자동값까지 흔들기 때문에(수렴 스캔에선 치명적) 임의로 고르면 안 된다.

**How to apply:** cascade에 잡을 낼 때 INCAR/실행 커맨드에 위 값을 그대로 넣는다. NBANDS를
명시할 때는 밴드병렬 그룹 수(= rank_per_kgroup / NCORE)의 배수인지 확인할 것.
잡 이름은 [[slurm_jobname_distinct]]대로 calc별로 구분. 파티션 구분은 [[server_fs_git_sync_scope]] 참조.

⚠ `cascade2`는 별도 파티션(주로 HSE 본계산 큐가 점유). 가벼운 스캔은 `cascade`로 분리해 돌린다.
⚠ slabcc 실행 시 `SLABCC_CHARGE_TOLERANCE`도 함께 볼 것 → [[slabcc_charge_truncation_guard]]
