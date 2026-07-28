---
name: server_fs_git_sync_scope
description: 서버(kohn/sham/bloch/tgm-master) 파일시스템 구조 + git 자동동기화가 계산폴더를 안 옮긴다는 사실
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7d923485-159f-4194-86b4-f3459f46a236
  modified: 2026-07-28T08:36:09.953Z
---

**핵심 함정**: `~/materials`의 `.gitignore`는 `*`(전부 무시) + `memory/`·`.claude/`·`CLAUDE.md`만 허용. 즉 **git 자동동기화(SessionStart pull / Stop push)는 메모리·Claude 설정만 옮기고, 계산 폴더(33-inAs 등)는 절대 git에 안 들어간다.** "Auto-sync" 커밋은 계산 데이터 백업이 아님.

**파일시스템(tgm-master 기준 확인, 2026-07-14)**:
- `/home`은 **로컬 xfs 디스크**(NFS 아님) → 서버마다 홈 분리. kohn/sham/bloch/tgm-master가 홈 공유 안 함.
- `/TGM/Apps/VASP`(VASP 바이너리·POTCAR)도 **로컬 nvme** → 서버마다 경로 다를 수 있음. run.sh의 BIN 경로·POTCAR 소스 경로는 서버 의존적.
- `/mnt/hohenberg/byuid/jaegwan97`(→ `byname/정재관`)만 **공유 NFS, 쓰기 가능** → 서버간 파일 전달 통로. `research/`, `scripts/`(Defect_Package 포함), `papers/` 등 있음.

**서버간 계산폴더 이동 방법**: git 아님. (1) `/mnt/hohenberg` 공유마운트 경유, 또는 (2) 수동 복사/rsync.

**⚠ 2026-07-28 정정 — kohn ≡ tgm-master, 같은 기계다.** `getent hosts kohn` = **143.248.13.145** = tgm-master의 IP이고, `ssh kohn`으로 들어가면 `hostname`이 `tgm-master.hpc`로 나온다. 이전 기록의 "kohn은 SLURM에 없는 별도 서버"는 **틀렸다**. 따라서 kohn 홈 = tgm-master 홈 = 같은 `/home/jaegwan97`이고, 둘 사이에 옮길 것이 없다. 별도 서버는 **sham(143.248.247.45)·bloch(143.248.247.246)** 뿐.

**tgm-master(=kohn) = SLURM 컨트롤러**. 파티션은 **cascade(36코어/노드, 10노드)** 와 **cascade2(32코어/노드, 191GB, 18노드)** — 옛 기록의 g1/g2·12코어는 현행 아님. 병렬 설정은 [[cascade_parallel_settings]].

**fermi = 192.168.100.201**, tgm-master가 게이트웨이인 **내부망(192.168.100.x, 계산노드와 같은 대역)** 호스트. kohn 홈에서 `ssh fermi`로 붙는다(사용자 표현 "proxy 경유"). 라우팅은 열려 있으나 **키 인증 미설정** — `Permission denied (publickey,password)`로 막히므로 비대화형 사용 전에 `ssh-copy-id fermi` 1회 필요. cascade2가 자기 VASP 잡으로 꽉 찰 때 VASP 무관한 후처리(CoFFEE 모델 계산 등)를 돌릴 대피처.

계산폴더 이동 시 POTCAR을 폴더에 번들해두면 /TGM 의존 제거되어 편함. 관련: [[kp_slabcc_nacl_reproduction]], Defect_Package 위치는 [[defect_package_repo]].
