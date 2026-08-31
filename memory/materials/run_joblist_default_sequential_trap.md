---
name: run-joblist-default-sequential-trap
description: "⚠ scripts/run_joblist.sh 의 기본 모드가 sequential = 로그인 노드에서 VASP 직접 실행. 반드시 `submit` 을 명시할 것"
metadata:
  node_type: memory
  type: feedback
---

2026-08-31, 35 트리 제출에서 `bash scripts/run_joblist.sh calc/joblist.txt` 를 그대로 실행했다.
두 번째 인자가 없으면 **`MODE="${2:-sequential}"`** 이 걸린다. sequential 은 sbatch 가 아니라
`run_case.sh` 를 **현재 셸에서 직접** 돌린다 → sham 로그인 노드에서 `mpirun -np 96 vasp.6.3.2.std.x`
가 떠서 **load average 97** 까지 올라갔다. [[no_compute_on_login_node]] 위반.

**How to apply**:
1. 항상 모드를 **명시**한다: `bash scripts/run_joblist.sh calc/joblist.txt submit`
   (모드: `sequential` | `submit` | `submit-chain` | `submit-defect-chains`)
2. 제출 직후 `squeue` 로 **JOBID 가 찍히는지** 확인한다. 큐가 비어 있는데 명령이 안 끝나면
   sequential 로 돌고 있는 것이다 — `ssh <서버> uptime` 의 load 로 즉시 확인된다.
3. 정리 순서: 상위 `mpiexec.hydra` PID 에 **`kill -9`** 를 주면 96 랭크가 한 번에 정리된다.
   개별 vasp PID 를 kill 해도 hydra 가 살아 있으면 안 죽는다.
4. 오염된 스테이지 폴더는 지우지 말고 `__attempt1_loginnode_killed__<stage>` 로 옮긴 뒤
   `prepare --mode overwrite` 로 재생성한다 ([[feedback_never_delete_use_attempts]]).

관련: [[no_compute_on_login_node]] [[feedback_never_touch_running_calc]]
