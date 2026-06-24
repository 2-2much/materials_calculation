---
name: slabcc-correction-cl-as-in
description: "slabcc finite-size correction 3가지 시도 결과 — Cl_As_In(q+1) surface defect에서 Gaussian 모델 부적합 판정, 0.018~0.079 eV 범위"
metadata: 
  node_type: memory
  type: project
  originSessionId: 3bcb2332-9234-404e-a9db-748447fab7e5
---

Cl_As_In (q=+1) surface defect에 대해 slabcc correction 3가지 방식을 시도. 모두 신뢰할 수 없다는 결론.

**Why:** DFT charge difference (q+1 - q0)가 slab 전체에 oscillatory하게 분포 (양/음 진동). 46.5%의 excess charge가 vacuum 영역에 존재. Shallow defect 특성상 Bloch-like state에 charge가 퍼져 positive-only Gaussian으로 재현 불가.

**How to apply:**

3가지 시도 결과:
- [A] Single Gaussian (position optimized): E_corr=0.079 eV, sigma=0.108 A (point-like), charge leakage 46.5%. RMSE warning.
- [B] Multi-Gaussian (3개): critical error — discretization error가 grid에 무관하게 수렴 안 됨. 에너지 출력 없음.
- [C] Fixed Position (z=0.652, peak): E_corr=0.018 eV, sigma=2.353 A (very broad), leakage 1.4%. 수렴은 했으나 [A]와 4배 차이.

[A]와 [C]의 4배 차이(0.079 vs 0.018 eV)는 모델 민감도를 반영. 두 값 모두 unreliable.

결과 디렉토리:
- `calc/Cl-As_In/_chgcar_diff_/outputs_single_gaussian/` — [A]
- `calc/Cl-As_In/_chgcar_diff_/outputs_multi_gaussian/` — [B]
- `calc/Cl-As_In/_chgcar_diff_/outputs_fixed_position/` — [C]
- 6페이지 비교 보고서: `calc/Cl-As_In/_chgcar_diff_/slabcc_correction_report.pdf`

slabcc가 slab_center 기준으로 CHGCAR를 z-shift함 (shift = 0.5 - slab_center_z). VESTA에서 slabcc_D.CHGCAR를 열면 원래 좌표와 다르게 보임.

이 defect에는 Falletta correction 등 다른 방식 검토 필요.

[[defect-calc-folder-structure]]
