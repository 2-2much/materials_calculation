---
name: server_fs_git_sync_scope
description: 서버(kohn/sham/bloch/tgm-master) 파일시스템 구조 + git 자동동기화가 계산폴더를 안 옮긴다는 사실
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7d923485-159f-4194-86b4-f3459f46a236
  modified: 2026-08-06T20:34:34.945Z
---

**핵심 함정**: `~/materials`의 `.gitignore`는 `*`(전부 무시) + `memory/`·`.claude/`·`CLAUDE.md`만 허용. 즉 **git 자동동기화(SessionStart pull / Stop push)는 메모리·Claude 설정만 옮기고, 계산 폴더(33-inAs 등)는 절대 git에 안 들어간다.** "Auto-sync" 커밋은 계산 데이터 백업이 아님.

**파일시스템(tgm-master 기준 확인, 2026-07-14)**:
- `/home`은 **로컬 xfs 디스크**(NFS 아님) → 서버마다 홈 분리. kohn/sham/bloch/tgm-master가 홈 공유 안 함.
- `/TGM/Apps/VASP`(VASP 바이너리·POTCAR)도 **로컬 nvme** → 서버마다 경로 다를 수 있음. run.sh의 BIN 경로·POTCAR 소스 경로는 서버 의존적.
- `/mnt/hohenberg/byuid/jaegwan97`(→ `byname/정재관`)만 **공유 NFS, 쓰기 가능** → 서버간 파일 전달 통로. `research/`, `scripts/`(Defect_Package 포함), `papers/` 등 있음.

**서버간 계산폴더 이동 방법**: git 아님. (1) `/mnt/hohenberg` 공유마운트 경유, 또는 (2) 수동 복사/rsync. tgm-master→kohn 직접 SSH는 키 없어 막힘(reverse는 미확인).

**tgm-master = SLURM 컨트롤러**(hostname tgm-master.hpc). 파티션 g1/g2(노드 n001~n064, 12코어/노드). kohn(143.248.13.145)은 이 SLURM에 없는 **별도 서버** → 자체 실행모델(자체 SLURM 또는 직접 mpirun). "자리 꽉차면 kohn/다른 서버로" 이동하는 이유.

계산폴더 이동 시 POTCAR을 폴더에 번들해두면 /TGM 의존 제거되어 편함. 관련: [[kp_slabcc_nacl_reproduction]], Defect_Package 위치는 [[defect_package_repo]].

⚠⚠**2026-08-07 재정정 (sham에 SSH로 직접 확인)**: **4대는 SLURM을 공유하지 않는다.**
kohn과 sham은 서로 다른 SLURM 클러스터다 — 둘 다 자기를 `tgm-master`/`tgmv2`라 부르지만
파티션이 완전히 다르다.
```
kohn  sinfo -s -> cascade(n001-010, 10노드) / cascade2*(n011-028, 18노드)
sham  sinfo -s -> g1(n001-062, 62노드)      / g2*(n067,073,076,079-082, 7노드)
```
노드 이름까지 `n001~`로 겹치므로 노드명으로도 구분 불가. 2026-07-30의 "4대가 공유한다"는
kohn 안에서만 본 결론이었다. **잡을 어디에 던졌는지는 파티션 이름으로 판별할 것**
(cascade계열=kohn, g계열=sham).

⚠**2026-08-07: `/mnt/hohenberg` NFS는 sham에 마운트되어 있지 않다.** sham의
`findmnt -t nfs`는 비어 있고 `/mnt/hohenberg/byname`은 mountpoint가 아니다.
`/mnt/hohenberg/byuid/jaegwan97 -> ../byname/정재관` 심링크만 남은 **빈 로컬 껍데기**다.
즉 "공유 NFS 경유 파일 전달"은 **kohn에서만 되고 sham에서는 안 된다** — sham과의 파일
교환은 rsync/scp를 써야 한다. 원인 규명 안 됨(마운트 누락인지 의도적인지 미확인).

머신 구분: 4대가 **같은 디스크 이미지 클론**이라 `hostname`뿐 아니라 `/etc/machine-id`까지
동일하다(`dc59a035...c3`). 구분되는 것은 `hostname -A`의 KAIST FQDN과 `hostname -I`의
첫 IP(kohn 143.248.13.145 / sham 143.248.247.45 / bloch 143.248.247.246), 그리고
`$SSH_CONNECTION`뿐이다.

서버간 SSH는 이제 열려 있다 → [[ssh-access-between-servers]]

⚠**2026-07-30 정정**: "tgm-master=SLURM(g1/g2), kohn 등은 별도서버" 는 (100) 트리에는
맞지 않는다. kohn 에서 같은 컨트롤러(SlurmctldHost=tgm-master, ClusterName=tgmv2)의
`cascade`/`cascade2` 파티션으로 직접 제출된다. 서버 4대가 SLURM 을 공유한다.
그리고 **hostname 으로는 4대를 구분할 수 없다**(전부 `tgm-master.hpc`) — `hostname -A`
의 KAIST FQDN 만 실제 서버명을 담는다. 상세: [[inas100_worktree_on_kohn]]
