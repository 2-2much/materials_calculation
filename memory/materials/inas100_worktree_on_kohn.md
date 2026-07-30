---
name: inas100-worktree-on-kohn
description: InAs (100) 계산 트리 05·06 은 kohn 로컬 /home 에만 있다 — 그리고 4대 서버는 hostname 으로 구분이 안 된다
metadata: 
  node_type: memory
  type: project
  originSessionId: 1d14f4a1-4e13-4ddd-a483-26f07c486890
  modified: 2026-07-30T00:09:11.043Z
---

## (100) 작업 위치 = kohn (2026-07-30 확인)

```
kohn:/home/jaegwan97/materials/33-inAs/__Functional_Validation__/12-Surace-defect_calculation/
    05-100Cl_8L_p4x4_PBE-d/    15 GB   PBE-d 스크리닝
    06-100Cl_8L_p4x4_HSE-d/    20 GB   HSE06+PBE-d (AEXX=0.27) 본계산
```

⚠**`/home` 은 kohn 로컬 디스크(`/dev/sdb`, 33 TB, 81% 사용)다.** 공유 NFS 아님 —
`/mnt/hohenberg/byuid/jaegwan97` 에 (100) 트리 사본이 **없다**. 그리고 계산 폴더는
`.gitignore = *` 라 git 동기화 대상도 아니다. 즉 다음 것들은 **kohn 에서만 보인다**:
`TOMORROW.md`, `calc/`, `Initial_POSCARs/`, `__attempt*__` 아카이브, `DO_NOT_SUBMIT_YET.md`.
다른 서버에서 이어서 하려면 공유 마운트로 복사하거나 수동 이동해야 한다.

git 으로 오가는 것은 `memory/` 와 `.claude/` 뿐 → [[server_fs_git_sync_scope]]

## ⚠서버 4대는 hostname 으로 구분되지 않는다

```
hostname        -> tgm-master.hpc      (4대 전부 동일, 무용)
$HOSTNAME       -> tgm-master.hpc
ClusterName     -> tgmv2               (4대 전부 동일, 무용)
hostname -A     -> kohn.kaist.ac.kr    <- 이것만 실제 서버명을 담는다
```

`.claude/sync-memory.sh` 도 같은 방식으로 판별한다(KAIST FQDN → `hostname -s` → ClusterName).
그래서 `git log` 의 `Auto-sync: Claude Code session (kohn)` 태그가 **어느 서버에서
작업했는지 알려주는 신뢰 가능한 기록**이다. 세션 중에 `hostname` 을 보고 서버를
추정하지 말 것 — 반드시 `hostname -A | grep kaist.ac.kr` 를 쓸 것.

## SLURM 은 4대가 공유한다

kohn 에서도 같은 컨트롤러(`SlurmctldHost = tgm-master`, ClusterName `tgmv2`)에 제출된다.
파티션은 **`cascade`(36코어/노드, 10 노드)** 와 **`cascade2`(32코어/노드 = 2×16, 18 노드
중 2 drain)**. (100) 계산은 전부 cascade2, 잡당 4노드 = 128코어로 돌리고 있다.
`NCORE=18/NSIM=36` 은 cascade 전용 값이므로 cascade2 에서는 `NCORE=16/NSIM=32` 를 쓸 것
→ [[cascade_parallel_settings]] 는 cascade 기준임에 주의.

⚠기존 메모리 [[server_fs_git_sync_scope]] 의 "tgm-master=SLURM(g1/g2), kohn 등은
별도서버" 는 이 트리에는 맞지 않는다. kohn 에서 cascade/cascade2 로 직접 제출된다.

## 잡 이름으로 트리 구분

`runtime.yaml` 의 `slurm.job_name_prefix` 로 `PBEd-` / `HSEd-` 를 붙여 둔 상태다.
없으면 05 와 06 이 똑같이 `Cl_In_q0` 로 보여 실제로 혼동 사고가 났다
→ [[hse_slab_scf_settings]]
