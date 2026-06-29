---
name: slurm_jobname_distinct
description: SLURM 잡 제출 시 jobname을 계산별로 구분되게 작성할 것
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3dcff5af-f03a-4d8d-98d9-519dc75d8cf3
---

SLURM 잡을 제출할 때 `--job-name` 을 계산을 구별할 수 있게 구체적으로 적을 것.
동일 이름(예: "ClAsIn_chgdiff")을 여러 잡에 쓰면 squeue에서 구분 불가.

**Why:** 사용자가 squeue로 진행상황을 볼 때 어느 calc인지 바로 알아야 함.

**How to apply:** mesh/charge/defect 등 식별자를 포함. 예: `cd-k2x2x1_G-qp1`
(접두사 cd=chgdiff, mesh, charge). 생성 스크립트(예: build_kpt_scan.py의 run_case_sh)에서
`f"cd-{name}-{cq}"` 처럼 동적으로 박는다. 이미 제출된 잡은 `scontrol update jobid=N name=...` 로 변경 가능.
