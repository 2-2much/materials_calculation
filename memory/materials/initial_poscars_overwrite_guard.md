---
name: initial_poscars_overwrite_guard
description: "⚠Initial_POSCARs 생성 전 기존 폴더 내용을 먼저 확인·백업할 것. materials의 .gitignore는 `*`라 덮어쓰면 git 복구 불가 (2026-08-10 사고)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 21521b3d-9090-4351-9826-e8574651dc0d
  modified: 2026-08-10T01:46:16.293Z
---

2026-08-10. 07-100Cl_8L_par4x3에 결함 세트를 생성하면서
`Initial_POSCARs/As_In/POSCAR`를 덮어썼다. 그 폴더는 **이름은 `As_In`인데 내용은
As_In+흡착 Cl(=05의 `Cl-As_In`, 127원자 완화 구조)** 이었다. 이름을 고친 뒤 생성하려던
계획이었는데 이름 변경보다 생성 스크립트가 먼저 돌았다.

**Why:** `~/materials/.gitignore` 1행이 `*` 라 계산 트리는 아무것도 추적되지 않는다.
`git checkout`/`git stash`로 되돌릴 수 없고, 로컬 백업도 없다. 복구 경로는 다른
서버(bloch/sham) 사본밖에 없었다.

**How to apply:**
1. POSCAR/CONTCAR을 쓰기 전에 **대상 경로 존재 여부와 조성(counts)을 먼저 읽는다.**
   폴더 이름이 아니라 조성·comment 줄이 그 파일의 정체다.
2. 존재하면 **이름 정리(mv)를 생성보다 먼저** 하거나, 스크래치패드에 사본을 뜨고 시작한다.
3. 이 저장소에서 "git이 되돌려 줄 것"이라고 가정하지 말 것 — memory/ 와 .claude/ 만
   추적된다 ([[server_fs_git_sync_scope]]).

관련: [[inas100_par4x3_defect_set_07]]
