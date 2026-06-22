---
name: surface-defect-poscar-generation
description: Cl-passivated InAs (110) 6L 3x2x1 slab에서 5종 surface defect POSCAR 생성 완료 및 스킬 제작
metadata: 
  node_type: memory
  type: project
  originSessionId: 8e59eb16-e97c-4e8c-98e6-c7584c17d589
---

2026-06-22에 pure slab으로부터 5종의 surface defect POSCAR을 생성했다.

**Why:** Cl-passivated InAs (110) 표면의 defect formation energy 계산을 위한 초기 구조 준비.

**How to apply:** 새 defect을 추가하거나 기존 defect을 수정할 때 이 작업 내역과 스크립트를 참조.

## 생성된 Defects

| Defect | 조작 | 대상 원자 | 결과 (In, As, Cl) |
|--------|------|----------|-------------------|
| In_As | As028→In 치환 (antisite) | As028 (0.583, 0.507, 0.700) | 37, 35, 12 |
| V_In | In028 제거 + Cl 채움 | In028 (0.417, 0.627, 0.714) | 35, 36, 13 |
| V_As | As028 제거 + Cl 채움 | As028 (0.583, 0.507, 0.700) | 36, 35, 13 |
| In_i | In interstitial (Td_In site) | (0.4167, 0.500, 0.630) | 37, 36, 12 |
| As_i | As interstitial (Td_In site) | (0.4167, 0.500, 0.630) | 36, 37, 12 |

## Interstitial 위치 결정

Grid search로 subsurface 영역 (z∈[0.620, 0.720])에서 최적 void 위치를 탐색:
- **Td_In site** (z=0.630): d_min=2.705 Å, 4개 In 이웃 (In028, In033, In031, In016) — 선택됨
- **Td_As site** (z=0.713): d_min=2.608 Å, As+Cl 이웃 — 표면 근처라 detach 우려로 미사용
- 기존 In_i/In_i2 (z=0.730)는 표면 위 adatom 위치였고, relaxation 시 detach됨

## 관련 파일

- `scripts/generate_surface_defect.py` — POSCAR 생성 도구 (substitute, vacancy, interstitial)
- `config/defects.yaml` — 5종 defect 항목 추가됨 (reference_neighbors 포함)
- `materials/.claude/commands/make-surface-defect.md` — `/make-surface-defect` 스킬
- 기존 In_i2는 그대로 유지 (참고용)

## Vacancy 설계 결정

V_In/V_As에서 단순 vacancy 대신 빈 자리에 Cl을 배치:
- delta_atoms: {In: -1, Cl: +1} (V_In), {As: -1, Cl: +1} (V_As)
- Cl이 vacancy site를 채우고, 기존에 bonded였던 Cl은 relaxation에서 rearrange

Related: [[defect-calc-folder-structure]]
