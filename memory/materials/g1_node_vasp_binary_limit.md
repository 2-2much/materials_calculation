---
name: g1_node_vasp_binary_limit
description: "g1 노드는 Sandy Bridge(AVX만) — VASP 6.5.x/6.4.1은 illegal instruction으로 즉사, 6.4.3/6.4.2/6.3.2/5.4.4만 동작. slabcc는 OMP_NUM_THREADS=12로 SLURM 제출"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 9576900b-ea8f-420e-9daf-cd578b563a18
  modified: 2026-07-22T12:00:11.477Z
---

## g1 파티션 하드웨어
`Intel Xeon E5-2630 @2.30GHz`, **12코어/노드, 31GB, AVX만 (AVX2/AVX-512 없음)**. 노드 15개 가용(n021 drain, n015 down 제외).
g2는 별개이며 프로젝트 표준 6.5.1이 거기서는 돈다. cascade는 36코어([[cascade_parallel_settings]]).

## VASP 바이너리 호환성 (2026-07-22 실측, 8원자 bulk Si로 전수 테스트)
| 바이너리 | g1 |
|---|---|
| `5.4.4.pl2/vasp.5.4.4.pl2.std.x` | **OK** |
| `6.3.2/vasp.6.3.2.std.x` | **OK** |
| `6.4.2/vasp_std` | **OK** |
| `6.4.3/vasp_std` | **OK** |
| `6.4.1/vasp.6.4.1.wan90v3.std.x` | ✗ Program Exception |
| `6.5.0/vasp.6.5.0.std.mpi.x` | ✗ Program Exception |
| `6.5.1/...std.x` (프로젝트 표준) | ✗ **illegal instruction 즉사** |

증상: 시작 직후 전 rank가 `Caught signal 4 (Illegal instruction)` + `forrtl: severe (168)`. OUTCAR 0바이트, 백트레이스가 libucs만 가리켜 원인 오인하기 쉬움. **입력 문제로 착각하지 말 것 — ISA 불일치다.**
→ g1에서는 **6.4.3/vasp_std** 사용.

## slabcc를 g1에서 돌릴 때
⚠**로그인 노드(tgm-master)에서 직접 실행 금지** — 거기 `nproc=1`, `OMP_NUM_THREADS=1`이라 slabcc가 단일 스레드로 기어감(변형 1개에 20분 → SLURM 12스레드로 2~3분).
제출 관례(프로젝트 `run_SLABCC.sh` 템플릿):
```sh
#SBATCH --partition=g1 --nodes=1 --ntasks-per-node=12 --mem=30G
module purge; module load compiler/2023.1.0; module load mkl/2023.1.0
OMP_NUM_THREADS=12 ~/bin/slabcc/bin/slabcc
```
module load가 빠지면 MKL/iomp5 런타임을 못 찾을 수 있다.

## 대형 슬랩 relax 속도 (540원자 Si 슬랩 실측)
`LREAL=.FALSE., EDIFF=1E-6, ALGO=Normal` → SCF 1회 **900초**(이온스텝당 73.5분, 총 ~20h).
`LREAL=Auto, EDIFF=1E-5, ALGO=Fast, KPAR=기약k점수` → **140초 (6.4배)**.
relax만 완화하고 **statics는 엄격 설정 유지**하면 E_f에 영향 없음(기하는 EDIFFG가 결정).

관련: [[si_db_kp_reproduction]], [[slurm_jobname_distinct]], [[server_fs_git_sync_scope]]
