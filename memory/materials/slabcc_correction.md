---
name: slabcc-correction
description: Cl-As_In CHG-DIFF slabcc correction 시도 결과 및 슈퍼셀 크기 문제
metadata: 
  node_type: memory
  type: project
  originSessionId: 6c179e72-1147-4c08-9f37-42aed4154b0d
---

## 경로
`12-Surace-defect_calculation/02-Cl-passv_6L_3x2x1_HSE06/calc/__CHG-DIFF__/slabcc/k221MP_elec/`

## slabcc.in 파라미터 (검증 완료)
- CHGCAR/LOCPOT: `kpt_scan/k2x2x1_MP/q0_Pgeom/` 및 `qp1/` (4개 파일 모두 존재)
- `charge_position = 0.416 0.558 0.743` → Atom 36 (As_In 결함, 1-indexed) 좌표와 소수점 3자리 일치
- `diel_in = 12.3` → InAs high-frequency dielectric constant (ε_∞, 의도된 값)
- `charge = q=+1` → NELECT(q0)=743, NELECT(qp1)=742로 확인
- `normal_direction = z`, `interfaces = 0.22 0.83`
- `optimize_maxsteps = 200`

## 실행 결과 (job 54968, 2026-06-30)
- **200스텝에서 미수렴** 종료
- 최종 RMSE: 0.0659 (계속 감소 중이었음)
- 최적화 후 sigma: `sigma_x ≈ 3.61 Å, sigma_y ≈ 0.95 Å, sigma_z ≈ 0.1 Å`
- critical 오류: `"Increasing the calculation grid size did not decrease the discretization error. Most probably the model charge is fairly delocalized!"`
  - 그리드 112→168→252→378로 확대해도 이산화 오차 수렴 안 됨

## 원인 분석
- slabcc는 CHGCAR가 아닌 **LOCPOT 차이**를 가우시안으로 fitting함
- CHGCAR 차이는 Atom 36 주변에 국소화되어 있으나, **쿨롱 포텐셜(1/r)은 장거리**
- 3×2×1 슈퍼셀(12.94 × 12.20 Å)에서 주기적 이미지 간격이 짧아 포텐셜이 중첩됨
- LOCPOT 차이가 셀 전체에 고르게 분포 → slabcc가 큰 sigma_x로 fitting 시도

## 슈퍼셀 크기 요약
- x ([-110] 방향): 12.94 Å = 3 unit cells × 4.31 Å
- y ([001] 방향):  12.20 Å = 2 unit cells × 6.10 Å
- sigma_x = 3.61 Å = 셀 폭의 **28%** → 이미지 간 가우시안 중첩 발생
- 시각화 스크립트: `kpt_scan/k2x2x1_MP/plot_supercell.py`
- 시각화 그림: `kpt_scan/k2x2x1_MP/supercell_visualization.png`

## 결론 및 다음 단계
**Why:** slabcc correction은 sigma ≪ cell 크기가 필요 (통상 σ < 10% of cell). 현재 28%로 의미 있는 보정값 불가.
**How to apply:** 4×3×1 이상 슈퍼셀이 필요하거나, Falletta method(z-CKT) 등 다른 보정 방법 적용 검토.
- [[chgdiff-kpt-scan]] — k-point 수렴은 k2x2x1_MP로 확인됨
