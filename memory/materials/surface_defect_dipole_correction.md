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

## 구체 설정값 (2026-07-01, 02-Cl-passv_6L_3x2x1_HSE06)
- 슬랩 z범위(fractional): 0.2368~0.7992 → 슬랩 중심 z=0.518, 진공 중심 z≈0.018(11.3Å 진공)
- **q0 DOS/Band INCAR: `IDIPOL=3`, `LDIPOL=.TRUE.`, `DIPOL=0.5 0.5 0.518`** (DIPOL+0.5=1.018≡0.018로 불연속점이 진공 정중앙에 떨어짐). DIPOL 명시 안 하면 auto-center가 스텝마다 흔들려 수렴 방해 → 반드시 고정
- **하전(q+1) DOS/Band INCAR: LDIPOL/IDIPOL/DIPOL 전부 주석/삭제(OFF)**
- 적용 완료: q0 4개(As_In, Cl-As_In, pure, V_Cl-Cl_As)×2 stage + 템플릿 2개에 DIPOL 추가; Cl-As_In/q+1 2개 OFF. **단 pure는 실행 중(job 55132)이라 DIPOL 미적용(되돌림)** — 재실행 시 적용 필요

## ⚠️ 재생성 durability 함정 (중요)
- `scripts/prepare_defect_workflow.py`의 `INCAR.patch.json`은 **입력이 아니라 생성 결과 기록(output)**. 재생성 시 INCAR = template + config에서 새로 계산한 set_tags/delete_tags. **기존 patch.json 편집은 무시됨**
- 따라서 하전 dipole-off를 재생성에서 유지하려면 patch.json이 아니라 **prepare_defect_workflow.py의 render_stage_incar()에 charge-conditional 로직 추가 필요** (q 변수가 이미 scope에 있음, line 55). set_tags 계산 후 `if q != 0: LDIPOL/IDIPOL/DIPOL를 delete_tags에 추가`
- 현재 config 오버라이드 소스는 spin_mode(nonmag/magnetic)와 runtime incar_overrides(전역)뿐 — charge-conditional hook은 없음
- **✅ 완료(2026-07-01)**: `prepare_defect_workflow.py` line 96 부근(overrides 적용 후, apply_incar_patch 직전)에 `if q != 0: for tag in (LDIPOL,IDIPOL,DIPOL): set_tags.pop; delete_tags.append` 삽입함. py_compile 통과. 이제 재생성해도 하전셀 dipole OFF 유지. relax(00/01)는 dipole 라인이 없어 무해
- **참고**: run_case.sh는 실행 시 INCAR를 재생성하지 않고 기존 파일 그대로 사용 → 이미 손편집한 pending 잡 INCAR들은 그대로 적용됨. 재생성은 prepare_defect_workflow.py 재실행 시에만 발생
