---
name: stages_yaml_dos_band_contamination
description: stages.yaml의 02/03(DOS/Band) 주석을 푼 채 prepare하면 모든 신규 하전 case에 std 다중 k 단계가 딸려 들어가 잡이 3h→10h+ 로 불어난다
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a36501db-d568-4425-8924-3511e61d9a67
  modified: 2026-07-22T11:16:57.833Z
---

`config/stages.yaml`의 `02_G221-DOS`·`03_Band` 블록을 **주석 해제한 상태로 `prepare_defect_workflow.py`
를 돌리면, 그때 만들어지는 모든 case에 DOS(4-k)+Band(20-k) HSE 단계가 자동으로 붙는다.**
Γ-only 하전 스윕(00/01/01_opt만 원하는 경우) 잡 하나가 **~3시간 → 10시간+** 로 불어난다.

**Why:** prepare는 stages.yaml에 살아있는 모든 스테이지를 case마다 생성하고 `run_case.sh`를
그대로 재생성한다. DOS/Band는 특정 defect의 q0에만 필요한데 stages.yaml은 **전역**이라,
한 목적으로 켜두면 이후 다른 목적의 prepare가 전부 오염된다. 2026-07-22에 실제로 발생했고
제출 직전 검증에서 잡았다.

**How to apply:** DOS/BAND 제출이 끝나면 **즉시 02/03을 다시 주석 처리**한다. 다시 필요하면
주석만 풀고 해당 case에 `--mode missing-stage`로 재prepare. 제출 전 항상
`grep -oP 'run_stage "\K[^"]+' <case>/run_case.sh` 로 **스테이지 목록을 눈으로 확인**할 것.

## 함께 쓰는 prepare 모드 선택

- **`--mode new-only`** — 기존 case를 **통째로 skip**(run_case.sh도 재생성 안 함).
  이미 SLURM에서 돌고 있는 q0를 건드리지 않고 새 charge 폴더만 만들 때 필수.
- **`--mode missing-stage`** — case는 유지하되 없는 스테이지를 채우고 **run_case.sh는 재생성**.
  기존 INCAR/KPOINTS/POTCAR은 존재하면 덮어쓰지 않으므로 **수동 편집(ISTART 등)이 보존된다.**
- **`--mode overwrite`** — INCAR까지 덮어쓴다. 수동 편집이 날아가므로 주의.

⚠ 이미 제출된 잡은 SLURM이 제출 시점에 배치 스크립트를 스풀하므로, 이후 run_case.sh를
고쳐도 영향받지 않는다(= 안전하게 재생성 가능).
⚠ `joblist.txt`는 prepare가 매번 덮어쓰며 **이미 실행 중인 case도 포함**한다. 그대로
`run_joblist.sh ... submit` 하면 같은 디렉토리에 **중복 잡**이 붙는다. 제출 전 `squeue`와
대조해 필터링할 것. → [[slurm_jobname_distinct]] [[server_fs_git_sync_scope]]
