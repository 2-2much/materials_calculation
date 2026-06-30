---
name: chgdiff-kpt-scan
description: Cl-As_In CHG-DIFF k-point 수렴 테스트 결과 및 vaspkit 314 사용법
metadata: 
  node_type: memory
  type: project
  originSessionId: 61a330f6-78ae-4639-bb0d-d1b84669063d
---

## 경로
`12-Surace-defect_calculation/02-Cl-passv_6L_3x2x1_HSE06/calc/Cl-As_In/__CHG-DIFF__/kpt_scan/`

## CHG-DIFF 분해 정의
- N@N = q0/CHGCAR, P@P = qp1/CHGCAR, N@P = q0_Pgeom/CHGCAR
- delta_total = P@P − N@N (이온화 + 구조 이완 전체)
- delta_elec  = P@P − N@P (순수 전자적 이온화, hole 국소화 probe)
- delta_geom  = N@P − N@N (순수 구조 이완, integral=0)
- 항등식: delta_total = delta_elec + delta_geom (잔차 ~1e-12 확인)

## k-point 수렴 결론 (2026-06-30)
| mesh | hole 국소화 (r<5Å) | 비고 |
|------|:-:|------|
| k1x1x1 | 29.2% | 수렴 안 됨, 국소화 과소평가 |
| k2x2x1_G | 32.4% | 중간 |
| k2x2x1_MP | 34.6% | 수렴 |
| k1_bald | 34.5% | 수렴, k2x2x1_MP와 동일 |

**→ 본계산 k-point: k2x2x1_MP 또는 k1_bald 사용**

**Why:** k1x1x1은 Γ-only sampling으로 surface band를 제대로 sampling 못해 결함 준위의 실공간 분포가 퍼져 보임.

## 분석 스크립트
- `scripts/chgdiff_kpt_scan.py` — pymatgen 기반, 4개 mesh 전체 처리
  - H./H1 pseudo 원소명 파싱 오류 → 임시파일에서 X로 치환하는 워크어라운드 적용
  - 출력: `analysis/planar_z_*.dat`, `cumulative_r_*.dat`, overlay PNG 6장, `integral_summary.txt`

## vaspkit 314 (CHG-DIFF 재생성)
- `CHGDIFFs/make_chgdiff.sh` — 12개 파일 일괄 생성
- **긴 경로 사용 시 vaspkit이 파싱 실패** → 각 mesh 디렉토리 안에서 상대경로로 실행해야 함
  ```bash
  cd $SCAN/$mesh
  printf "314\nqp1/CHGCAR q0/CHGCAR\n" | vaspkit
  ```
- vaspkit 출력: CHGDIFF.vasp (현재 디렉토리에 생성)

## cumulative_r_elec 해석
- 더 음수 = 결함 반경 r 이내에서 전자밀도 감소량 큼 = hole이 결함에 더 국소화
- "전자 덜 국소화" = "hole 덜 국소화" — 동일한 물리의 두 표현
