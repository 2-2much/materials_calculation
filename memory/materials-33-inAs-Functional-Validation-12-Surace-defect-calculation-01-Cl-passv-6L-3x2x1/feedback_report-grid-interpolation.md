---
name: report-grid-interpolation
description: slabcc z-profile 데이터 비교 시 DFT/model grid 크기가 다르므로 반드시 보간 필요
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3bcb2332-9234-404e-a9db-748447fab7e5
---

slabcc 출력의 DZPOT(DFT)와 MZPOT(model)는 z-grid 포인트 수가 다름 (예: 224 vs 336점).

**Why:** 직접 뺄셈하면 z위치가 안 맞아서 residual이 엉뚱한 값이 됨. 실제로 z=5 A에서 residual이 0.25 V로 보이는 버그 발생했었음.

**How to apply:** `np.interp(z_dft, z_model, v_model)` 등으로 model을 DFT grid에 보간한 후 비교/차감해야 함. charge 데이터(DZCHG/MZCHG)도 마찬가지.
