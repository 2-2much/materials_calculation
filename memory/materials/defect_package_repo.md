---
name: defect_package_repo
description: "Defect_Package 정본 위치 + GitHub 배포(2-2much/Defect_Package, private) + scripts/·example/ 2폴더 구조"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 57d09abc-dc4b-4d3d-8be0-c86f99fef821
---

Defect 계산 패키지의 정본 git repo: `/mnt/hohenberg/byuid/jaegwan97/scripts/Defect_Package/`
(심링크 해석 시 `/mnt/hohenberg/byname/정재관/scripts/Defect_Package`). tgm-master에서 마운트로 직접 쓰기 가능.

## ⚠️ 최신 상태 (2026-07-16): GitHub 배포 + 패키지 재구성 (이 아래 옛 "원격 없음" 전제 supersede)
- **GitHub 원격 생성**: `https://github.com/2-2much/Defect_Package` (**private**, org=2-2much, materials와 동일). 정본에 `origin` 연결·push 완료. 이제 다른 서버/계산노드에서 `git clone`/`git pull`로 배포. (이전 "로컬 only 원격 없음" 무효.)
- **2폴더 구조로 재구성**(커밋 c79e3c6): 추적=`scripts/`(코드, 그대로 실행) + `example/`(복사용 템플릿: config/, correction_DFE.sh, correction_slab.sh, defect_colors.yaml, lattice_2_PBE-d_const.sh, plot_DFE.sh, README_CHARGED/SLAB_CORRECTION.md). 루트엔 개요 README.md + .gitignore.
- **untrack + gitignore**(per-system, 배포 안 함): `inputs/`, `Initial_converged_POSCARs/`, **`POTCAR`**(라이선스). 디스크엔 남김.
- **LICENSE=MIT**(저작권자 Jaegwan Jung, 2026) 추가. **requirements.txt** 추가(PyYAML + correction 방법: bulk=Falletta-Wiktor-Pasquarello FWP, slab=Komsa slabcc).
- ✅ **POTCAR 히스토리 스크럽 완료**(2026-07-16, `git filter-branch --index-filter 'git rm --cached --ignore-unmatch POTCAR'` + refs/original 삭제 + reflog expire + gc → force-push). origin/master POTCAR 커밋 0, 전체 오브젝트 잔존 없음 확인. ⚠GitHub는 force-push 후에도 unreachable 옛 커밋 blob을 자체 GC 전까지 직접 SHA로 접근 가능할 수 있음(POTCAR=비밀 아닌 라이선스 파일·private라 저위험). data 디렉토리(inputs/Initial_converged_POSCARs)는 사용자 결정으로 히스토리에 **잔존**(POTCAR만 제거).
- ⚠️사고&복구: allowlist gitignore 테스트 정리 중 `rm -rf ... POTCAR`로 워킹트리 실파일(457089B) 실수 삭제 → filter-branch refs/original(gc 전)에서 `git cat-file -p <old>:POTCAR > POTCAR`로 복구, gitignore라 재추적 안 됨. 교훈: 테스트 임시파일명이 실파일과 겹치지 않게, rm 대상 명시적으로.
- **사용 모델(2026-07-16 확정, 커밋 1a17657)**: **clone 안에서 바로 계산**. `cp -r example/config config && cp example/*.sh example/defect_colors.yaml .`로 편집용 사본 만들고(이 사본·inputs/·POTCAR·calc/·results/ 전부 gitignore), scripts는 `git pull`로 갱신. helper `.sh`는 cwd=clone루트 기준 상대경로(`scripts/`,`config/`)라 루트에서 실행하면 수정 없이 동작. 여러 시스템=clone 여러 개.
- **allowlist `.gitignore`**: `/*`로 전부 무시 후 `!/scripts/ !/example/ !/README.md !/.gitignore`만 재포함(+ `__pycache__/`,`*.pyc` 등 junk). ⚠추적할 새 top-level 파일 추가 시 `!/<name>` 라인 필요. 핵심 원리: **.gitignore는 미추적 파일만 막음** → 편집하는 config는 추적 템플릿(example/config)과 **다른 경로(config/)**여야 pull 충돌·템플릿 오염 없음.
- **패키지 개선**: clone에서 `scripts/`·`example/` 편집→commit→push. ⚠example/config를 시스템값으로 고쳐 push 금지(공유 템플릿 오염).
- **README 재작성 완료**: clone-and-run 워크플로우, "반드시 바꿀 값" 체크리스트(μ/vbm/gap in plot_DFE.sh, vasp_bins·slurm in runtime.yaml, defects.yaml, lattice const, POTCAR), stale참조(Gamma_relax/MP_static/Initial_POSCARs/run_case.sh/POTCAR_info) 제거. 남은 감사 항목: config INCAR가 01_Mid-point_relax 단일단계, surface config 미포함, requirements.txt/LICENSE 없음, __Hold__ 보관폴더 노출.
- **계산폴더 scripts 심링크 사고 해소**(커밋 53d6e42, 01-Cl-passv_6L_3x2x1): scripts 심링크→실복사 후 계산폴더 자체 git에 추적. 앞으로 scripts 갱신은 clone/pull 또는 scoped fetch(`git fetch <정본> HEAD && git checkout FETCH_HEAD -- scripts`).

## (이하 옛 기록, 히스토리 참고용 — "원격 없음"은 위에서 무효화됨)
- ~~로컬 git only, 원격(GitHub) 없음~~ → 2026-07-16 GitHub private 배포로 대체.
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
