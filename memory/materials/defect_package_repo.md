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
