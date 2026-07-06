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
