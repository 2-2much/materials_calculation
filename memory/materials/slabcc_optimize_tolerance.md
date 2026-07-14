---
name: slabcc_optimize_tolerance
description: slabcc optimize_tolerance는 목표 RMSE 임계값이 아니라 옵티마이저(BOBYQA/NLOPT) 상대수렴 tolerance. RMSE>tol에서 멈춰도 정상(local min 수렴)
metadata: 
  node_type: memory
  type: reference
  originSessionId: 55454a3e-4350-4b63-a808-a64f68435f75
---

slabcc `optimize_tolerance`(예 0.05)는 **목표/최대 RMSE 값이 아님**. NLOPT BOBYQA 옵티마이저의
**상대 수렴 tolerance**(스텝 간 목적함수=RMSE 개선율). "스텝 간 RMSE가 상대적으로 tol보다 적게 개선되면
= local minimum 도달"로 판단해 종료. 따라서 **최종 RMSE가 tol보다 커도(예 0.089 ≫ 0.05) 정상 종료**임 —
RMSE를 tol 아래로 내리라는 뜻이 아니다.

남은 RMSE(~0.089)는 **모델(단일 등방 Gaussian)이 DFT 퍼텐셜을 재현할 수 있는 물리적 한계(residual)**.
tol을 더 조여도 스텝만 더 돌 뿐 residual은 거의 안 줄음. 표면결함은 Directional RMSE가 z방향(면수직)에서
면내보다 3배↑(anisotropy≈3.3) 흔함 → 등방 Gaussian 한계 신호. residual을 줄이려면 tol이 아니라
**모델**을 손봐야: `charge_trivariate=yes`(비등방 σ) 또는 Gaussian 다중.

관련: [[slab_correction_workflow]] [[vertical_scan_slabcc_scpc]] [[scpc_debug]].
