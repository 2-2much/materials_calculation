---
name: fermi_node_setup
description: "fermi 서버에서 VASP 돌리는 법 — SLURM 없음, kohn 홈이 /mnt/home으로 보임, ulimit -s 8MB가 SIGSEGV 원인"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7fd23945-c8fb-4696-b74d-fae8b95beb6a
  modified: 2026-08-11T02:27:00.348Z
---

`fermi`는 kohn/sham/bloch와 별개의 계산 서버다. cascade가 꽉 찼을 때 도피처.
2026-08-11에 09-100AA 트리 pure relax를 여기서 돌리며 확인했다.

**하드웨어**: AMD EPYC 9124 2소켓 = **32코어**(HT 없음, 16코어/소켓), RAM 1.5 TB.
→ `NCORE=16`, `NSIM=32`, `mpirun -np 32`. (cascade는 36코어/노드 → NCORE=18)

**⚠ SLURM이 없다.** `sbatch`/`squeue`/`sinfo` 전부 없음. 대기열이 아니라 `mpirun`을
직접 띄우고 `setsid nohup`으로 detach해야 한다. [[no_compute_on_login_node]]의
"로그인 노드에서 계산 금지" 규칙은 여기 해당 없음 — fermi는 계산 노드 그 자체다.
자원 경합은 `pgrep -c vasp_gam`으로 눈으로 확인할 것.

**⚠ 파일시스템은 kohn과 공유된다.** fermi의 `/mnt/home`이 `tgm-master.hpc:/home`
NFS 마운트이고, 이것이 **kohn의 `/home`과 같은 디스크**다(marker 파일로 양방향 확인).
```
kohn : /home/jaegwan97/materials/...
fermi: /mnt/home/jaegwan97/materials/...   # 같은 파일
```
→ 파일 복사 필요 없음. 대신 **같은 계산 폴더에 cascade 잡과 fermi 프로세스를 동시에
띄우면 서로 파일을 뭉갠다.** fermi로 옮길 때 대기 중인 SLURM 잡을 반드시 `scancel`할 것.
([[server_fs_git_sync_scope]]의 "홈은 로컬 xfs, 서버간 공유 안 함"은 fermi에는 해당 없음)

**VASP**: `/opt/vasp/6.6.1/{vasp_gam,vasp_std,vasp_ncl}` (6.5.1, 6.6.0도 있음).
cascade의 6.5.1과 **다른 빌드**이므로 [[g1_node_vasp_binary_limit]] 원칙대로
새 바이너리는 짧게 한 번 돌려보고 쓸 것. 총에너지를 cascade 결과와 섞지 말 것.

**환경**: Intel oneAPI. `source /opt/intel/oneapi/setvars.sh` 안 하면 MKL/`libimf.so`가
`not found`로 뜨고 `mpirun`도 PATH에 없다. `module`은 없다.

## 함정 2개 (둘 다 여기서 실제로 당함)

**1. `ulimit -s`가 8192 KB → VASP가 "entering main loop" 직후 전 랭크 SIGSEGV.**
`forrtl: severe (174)` 스택트레이스만 잔뜩 나오고 원인 메시지가 없어서 오해하기 쉽다.
셋업(NIONS/NELECT/POTCAR)은 전부 정상 출력된 뒤 죽는다. 고치는 법:
```bash
ulimit -s unlimited
export OMP_STACKSIZE=512m
```
RAM 1.5 TB라 스택 제한할 이유가 없다.

**2. `setvars.sh` + `set -euo pipefail` = 빈 로그로 즉사.**
setvars.sh가 unset 변수를 읽어서 `set -u`에 걸리고 non-zero 반환 → `set -e`가 스크립트를
죽인다. 로그가 **0바이트**라 원인이 안 보인다. strict flag 켜기 **전에** source할 것.
같은 맥락으로 `cmd > log 2>&1; rc=$?`도 `set -e` 아래서는 `rc=` 줄에 도달 못 한다.
`|| rc=$?`로 받을 것.

**참고 스크립트**: `12-Surace-defect_calculation/09-100AA_8L_par4x3_PBE-d/calc/pure/q0/run_fermi.sh`
— 위 함정을 다 처리해둔 실행 템플릿. 다른 case로 복사할 땐 `CASE_DIR`만 바꾸면 된다.

관련: [[ssh_access_between_servers]], [[cascade_parallel_settings]], [[slurm_jobname_distinct]]
