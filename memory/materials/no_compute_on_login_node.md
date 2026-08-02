---
name: no_compute_on_login_node
description: kohn=tgm-master는 SLURM 로그인 노드 — 계산은 sbatch로. CoFFEE 제출 레시피와 컴퓨트 노드 마운트 범위
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e2e681b6-093b-4a4f-ae4f-da18a9dc5ec4
  modified: 2026-08-02T19:42:28.160Z
---

**kohn.kaist.ac.kr = tgm-master.hpc = SLURM 로그인/마스터 노드다.** 여기서 `mpirun`을 직접 때리지 말 것. 2026-08-03 MoS₂ α=40(10랭크·13분·rank0 1.7GB)을 로그인 노드에서 돌리다 사용자에게 지적받고 kill 후 재제출했다.

**Why**: `cascade` 파티션에 idle 노드가 10대(n001–010, 36코어·191GB) 놀고 있는데 24코어 로그인 노드에 load 10을 걸었다. 실패 경로는 "이게 SLURM 클러스터인지 몰라서"가 아니라 **앞선 실행들이 초 단위여서 인라인으로 돌렸고, 작업 성격이 바뀐 시점(10랭크·10분+·GB급)에 방식을 재판단하지 않은 것**. 짧은 스모크 테스트 → 본계산으로 넘어가는 순간이 판단 지점이다.

**How to apply**: 몇 초짜리 스모크 테스트만 인라인. 랭크 여러 개 / 분 단위 / GB급이면 무조건 `sbatch`. 제출 스크립트 정본 = `11-Surface-defect_TOY-model/CoFFEE/run_coffee_slurm.sh`:

```bash
sbatch --job-name=<calc별로 구분> --chdir=<workdir> \
       .../CoFFEE/run_coffee_slurm.sh <case_dir> [<case_dir> ...]
```

**확인된 클러스터 사실 (2026-08-03, `srun` 프로브)**
- 컴퓨트 노드는 `/home/jaegwan97`을 **직접 마운트**한다 → 작업트리·conda python 복사 불필요.
- 컴퓨트 노드에 **`/mnt/hohenberg`는 없다**. 공유NFS를 쓰는 잡은 여기서 못 돈다 ↔ [[server_fs_git_sync_scope]] 보완.
- `/mnt/home/...` 경로는 **fermi 전용**(fermi는 SLURM 없이 kohn의 /home을 NFS 마운트). SLURM 잡에 쓰면 안 됨 — 프로덕션 `run_on_fermi.sh`가 그 경로를 쓰는 건 fermi 얘기다.

**⚠ SLURM 함정**: 배치 스크립트는 `/var/spool/slurm/job<id>/`로 **복사되어** 실행된다 → `$BASH_SOURCE`/`dirname $0`로 리포 경로를 유도하면 즉사한다(`can't open file '/var/spool/slurm/job55842/coffee.py'`). 실행 파일 경로는 **절대경로로 박을 것**.

CoFFEE 실행 특성은 [[coffee_setup_and_arange_bug]] 참조(랭크 상한 = 격자 첫 차원, rank0가 IFFT 독점). 잡 이름 규칙은 [[slurm_jobname_distinct]].
