---
name: defect_package_repo
description: "Defect_Package git repo 위치(로컬 only, 원격 없음)와 계산 폴더가 clone 아닌 복사본이라는 점"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 57d09abc-dc4b-4d3d-8be0-c86f99fef821
---

Defect 계산 패키지의 실제 git repo: `/mnt/hohenberg/byuid/jaegwan97/scripts/Defect_Package/`
(심링크 해석 시 `/mnt/hohenberg/byname/정재관/scripts/Defect_Package`). tgm-master에서 마운트로 직접 쓰기 가능.

- **로컬 git only, 원격(GitHub) 없음** → push 없이 로컬 커밋으로 관리.
- repo는 아직 **bulk defect** 버전(config에 `INCAR_01.Mid-point_relax`, defect명 As_In/V_As 등).
- 계산 폴더 `12-Surace-defect_calculation/02-Cl-passv_6L_3x2x1_HSE06/`는 이 repo를 **clone하지 않고 파일만 복사**해 쓰다가 surface defect 워크플로우로 분화됨 → repo와 자동 동기화 안 됨(수동 복사 필요).
- 2026-07-06: generic 스크립트 3개(`generate_surface_defect.py` 신규, `prepare_defect_workflow.py` 하전셀 dipole 태그 제거, `plot_DFE_from_raw_energies.py`)를 repo에 커밋(5730796). kpt_scan 스크립트 2개는 PROJ 절대경로 하드코딩·Cl-As_In 전용이라 제외.
- **아직 repo에 안 올린 것**: surface용 config(INCAR/KPOINTS의 00.Gam-relax/01.Spin-gam-relax/02.G221-DOS/03.Band stage, surface defects.yaml). InAs-surface 특화값 검토 후 별도 결정 예정.

## 운용 모델 (2026-07-14 결정): 개발 ≠ 계산 폴더 분리
- **문제였던 것**: 계산 폴더 `01-Cl-passv_6L_3x2x1`가 `.git`을 가진 채 origin=Defect_Package를 추적 → `git pull` 시 계산 전용으로 dirty해진 config/inputs/plot과 upstream 커밋이 겹쳐 merge 실패. (상위 `materials` repo는 `.gitignore=*`로 이 폴더를 통째 무시하므로 중첩 `.git` 자체는 무관/정상.)
- **조치**: 이 폴더에서 `git remote remove origin` → 여기서 `git pull`이 더 이상 merge 안 함. 복구는 `git remote add origin /mnt/hohenberg/byuid/jaegwan97/scripts/Defect_Package/`. ⚠이 조치는 **bloch의 이 복사본에만** 적용(계산 폴더는 git 동기화 대상 아님 → 다른 서버 복사본은 각자 처리).
- **패키지 개발 흐름**: 정본 repo(`/mnt/hohenberg/.../Defect_Package/`, 이미 clean·최신, 원격 없음)에서 **직접 edit + git commit**. clone/push 불필요(로컬 repo라 commit이 곧 배포). 별도 sandbox 원하면 clone.
- **계산 폴더로 스크립트 반영**: 손으로 라인 복붙 금지. `scripts/`는 순수 패키지 코드여야 하므로 (A) 계산폴더 `scripts/`를 정본 `scripts/`로 **symlink**(zero-copy, 항상 최신·재현성은 주의) 또는 (B) `cp -f <PKG>/scripts/*.py <calc>/scripts/` **한 방 복사**.
- ⚠계산폴더 `plot_DFE_from_raw_energies.py`에 계산-로컬 수정 12줄 존재 → symlink/cp 전에 이게 패키지에 올릴 개선인지(→upstream) 계산전용인지 판별 필요. plot_DFE.sh의 μ/vbm/stage는 계산전용 값이므로 패키지에 안 올림.

## 커밋 컨벤션 & 워크플로우 (2026-07-14 확정): 로컬 커밋만, push 안 함
현재 상태: 브랜치 `master`, tree clean, 커밋 5개(최신 5a10665). `git remote -v` 비어있음 = 원격 없음(`.git`은 존재 ≠ remote 존재). 사용자 결정: **원격 없이 로컬에서만 체계적 커밋, push 하지 않음**.
- **커밋 메시지 규칙**(기존 커밋 톤 유지): 제목=영어 명령형 한 줄 ~72자, 접두어 `Add`/`Fix`/`Support`/`Refactor`/`Remove`/`Update`. 본문(선택)=한 줄 비우고 *왜* 바꿨는지(논문·파라미터 근거 명시). **원자적 커밋**(논리 단위별 분리), 커밋 전 항상 `git diff` 확인.
- **명령어**: cwd가 매 호출 리셋되고 repo가 작업디렉토리 밖이라 `cd` 대신 **`git -C /mnt/hohenberg/byuid/jaegwan97/scripts/Defect_Package ...`** 사용. 순서: `status`→`diff`→`add <파일명시>`(add . 금지)→`diff --cached`→`commit -F -`(heredoc으로 제목+본문)→`log --oneline -3`.
- **미결정**: `Co-Authored-By` 트레일러를 이 로컬 repo에도 넣을지 사용자에게 물어봄(답 대기). 다음 세션: **/clear 후 플랜모드로 패키지 업그레이드** 진행 예정 — 무엇을 업그레이드할지는 플랜모드에서 정함.

## ⚠️ 사고 & 진짜 원인 (2026-07-15): scripts 심링크가 compute 노드에서 dangling → seed 즉사 → 체인 데드락
- **증상**: 01-Cl-passv_6L_3x2x1 잡 제출 후 각 defect charged 체인의 **첫 잡(seed)이 Elapsed 0초·ExitCode 2 FAILED** (std.err=`python3: can't open file .../scripts/resolve_initial_poscar.py: No such file`). `afterok`라 뒤 잡 전부 Dependency/DependencyNeverSatisfied 데드락. scancel+재제출해도 **동일하게 재발**(2회).
- **진짜 원인(확정)**: 계산폴더 `scripts`가 **심링크** → `/mnt/hohenberg/byuid/jaegwan97/scripts/Defect_Package/scripts` (Jul 14 14:44 생성, 운용모델 "A안 symlink"). `/home`은 로컬 `/dev/sda`, `/mnt/hohenberg`은 NFS. **로그인 노드(tgm-master)**는 NFS 마운트되어 심링크 정상(그래서 로그인에서 `--help` 테스트는 통과) 하지만 **compute 노드(n033-036,060-064)는 /mnt/hohenberg 미가시** → `scripts` 심링크 dangling → 파일 못 찾음. `calc`는 실제 디렉토리(/home)라 std.out은 정상 기록됨(그래서 "FS 가시성 아님"으로 오판했던 것). ⚠앞서 "동기화 지연/파일 부재"로 적었던 진단은 틀림.
- **교훈**: SLURM이 실행하는 경로(scripts 포함)는 **compute 노드가 볼 수 있어야 함 = /home 로컬 실제파일**. 정본 repo(/mnt/hohenberg)로의 **symlink(A안)는 SLURM에서 금지**. 반드시 **실복사(B안)**: `rm scripts && cp -r /mnt/hohenberg/byuid/jaegwan97/scripts/Defect_Package/scripts scripts`. cf. [[server_fs_git_sync_scope]](/home·/TGM 로컬, /mnt/hohenberg만 NFS).
- **복구 절차**: (1) scripts 심링크→실복사, (2) 막힌/실패 잡 scancel, (3) `bash scripts/run_joblist.sh calc/joblist.txt submit-defect-chains` 재제출. run_case.sh는 멱등(stage_finished=OUTCAR "General timing and accounting")이라 완료된 q0/Cl-As_In q+1은 수초 스킵. **2026-07-15 밤 미적용, 사용자 "내일" 처리 예정.**
