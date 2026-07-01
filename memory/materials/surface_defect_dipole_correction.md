---
name: surface-defect-dipole-correction
description: "02-Cl-passv_6L_3x2x1_HSE06 DOS/Band 단계 dipole correction(LDIPOL/IDIPOL) 적용 여부 결정 (2026-07-01)"
metadata:
  node_type: memory
  type: project
  originSessionId: 0b838ed2-3a0f-4b92-a22c-131ab8936454
---

## 결정: q0는 dipole correction ON, 하전 상태는 OFF
Cl-passivation이 슬랩 한쪽에만 있는 비대칭 구조라 주기적 슬랩 이미지 간 인위적 dipole field가 발생함.

- **q0(중성)**: `LDIPOL=T, IDIPOL=3(z), DIPOL=<charge center>`를 01_G221-1shot(DOS)부터 켜서 WAVECAR/CHGCAR를 이어받는 02_Band(hybrid)까지 일관되게 적용 — sawtooth potential 보정으로 vacuum/band eigenvalue의 인위적 field artifact 제거
- **q+1 등 하전 상태**: dipole correction 끄기. 하전 슬랩은 compensating jellium background가 들어가 electrostatic potential이 이미 비물리적(발산)인 상태라, net charge=0을 가정하는 VASP dipole correction 알고리즘과 조합이 검증되지 않음 → 오히려 왜곡 위험

## 일관성 주의사항 (핵심)
- Potential alignment는 CLAUDE.md 기준 **bulk-PBAND 방식**(LOCPOT/vacuum 기준 아님)이라 dipole correction on/off가 alignment 자체엔 영향 적어 비교적 안전함
- 다만 **Falletta finite-size correction**(LOCPOT→cube 기반, [[surface_defect_gam_relax_spin_comparison]] 계열 워크플로우와 별개)은 실제 LOCPOT potential profile을 사용하므로, **q0 defect cell과 비교 대상 reference(pristine bulk/slab)의 dipole correction 설정이 서로 맞아야 함** — reference 쪽도 같은 처리(켜짐)인지 확인 필요

**Why:** 비대칭 슬랩의 인위적 dipole field는 q0 DOS/band 정확도에 영향을 주지만, 하전계에서는 dipole correction 자체가 검증되지 않은 조합이라 별도 처리 필요
**How to apply:** 12-Surace-defect_calculation 이하 DOS(01)/Band(02) 단계 INCAR 작성 시 charge state별로 LDIPOL 설정을 분기하고, finite-size correction용 reference potential 계산 시 defect cell과 동일한 dipole correction 설정을 맞출 것
