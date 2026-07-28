---
name: server_fs_git_sync_scope
description: 서버(kohn/sham/bloch/tgm-master) 파일시스템 구조 + git 자동동기화가 계산폴더를 안 옮긴다는 사실
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7d923485-159f-4194-86b4-f3459f46a236
---

**핵심 함정**: `~/materials`의 `.gitignore`는 `*`(전부 무시) + `memory/`·`.claude/`·`CLAUDE.md`만 허용. 즉 **git 자동동기화(SessionStart pull / Stop push)는 메모리·Claude 설정만 옮기고, 계산 폴더(33-inAs 등)는 절대 git에 안 들어간다.** "Auto-sync" 커밋은 계산 데이터 백업이 아님.

**파일시스템(tgm-master 기준 확인, 2026-07-14)**:
- `/home`은 **로컬 xfs 디스크**(NFS 아님) → 서버마다 홈 분리. kohn/sham/bloch/tgm-master가 홈 공유 안 함.
- `/TGM/Apps/VASP`(VASP 바이너리·POTCAR)도 **로컬 nvme** → 서버마다 경로 다를 수 있음. run.sh의 BIN 경로·POTCAR 소스 경로는 서버 의존적.
- `/mnt/hohenberg/byuid/jaegwan97`(→ `byname/정재관`)만 **공유 NFS, 쓰기 가능** → 서버간 파일 전달 통로. `research/`, `scripts/`(Defect_Package 포함), `papers/` 등 있음.

**서버간 계산폴더 이동 방법**: git 아님. (1) `/mnt/hohenberg` 공유마운트 경유, 또는 (2) 수동 복사/rsync. tgm-master→kohn 직접 SSH는 키 없어 막힘(reverse는 미확인).

**tgm-master = SLURM 컨트롤러**(hostname tgm-master.hpc). 파티션 g1/g2(노드 n001~n064, 12코어/노드). kohn(143.248.13.145)은 이 SLURM에 없는 **별도 서버** → 자체 실행모델(자체 SLURM 또는 직접 mpirun). "자리 꽉차면 kohn/다른 서버로" 이동하는 이유.

계산폴더 이동 시 POTCAR을 폴더에 번들해두면 /TGM 의존 제거되어 편함. 관련: [[kp_slabcc_nacl_reproduction]], Defect_Package 위치는 [[defect_package_repo]].
