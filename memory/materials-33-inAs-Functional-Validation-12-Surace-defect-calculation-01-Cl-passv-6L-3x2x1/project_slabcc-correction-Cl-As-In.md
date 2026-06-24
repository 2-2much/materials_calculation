---
name: slabcc-correction-cl-as-in
description: slabcc finite-size correction 시도 결과 — Cl_As_In(q+1) surface defect에서 charge delocalization으로 Gaussian 모델 부적합 판정
metadata: 
  node_type: memory
  type: project
  originSessionId: 3bcb2332-9234-404e-a9db-748447fab7e5
---

Cl_As_In (q=+1) surface defect에 대해 slabcc correction을 시도했으나, Gaussian charge model이 부적합하다는 결론.

**Why:** DFT charge difference (q+1 - q0)가 slab 전체에 oscillatory하게 분포 (양/음 진동). 46.5%의 excess charge가 vacuum 영역에 존재. Surface shallow defect 특성상 Bloch-like state에 charge가 퍼져 positive-only Gaussian으로 재현 불가.

**How to apply:**
- Single Gaussian: RMSE warning 발생하지만 E_correction=0.079 eV 산출 (신뢰도 낮음)
- Multi-Gaussian (3개): critical error 발생 — discretization error가 grid 크기와 무관하게 수렴하지 않음. Single보다 더 나쁜 결과
- 결과 파일: `calc/Cl-As_In/_chgcar_diff_/outputs_single_gaussian/` (single), `outputs/` (multi)
- 이 defect에는 Falletta correction 등 다른 방식 검토 필요
- 관련 보고서: `calc/Cl-As_In/_chgcar_diff_/slabcc_correction_report.pdf`

[[defect-calc-folder-structure]]
