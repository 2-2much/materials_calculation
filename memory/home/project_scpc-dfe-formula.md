---
name: scpc-dfe-formula
description: "SCPC correction 적용 시 DFE 공식 — pure cell VBM 사용, SCPC PA는 charged↔neutral만 포함"
metadata: 
  node_type: memory
  type: project
  originSessionId: 502cfb29-f0a7-42a5-acc6-ff69729e9d16
---

SCPC (Self-Consistent Potential Correction) 적용 시 DFE 공식:

E_f[X^q] = E_DFT[X^q] - E[pure] + Σn_iμ_i + q(ε_VBM^pure + E_F) + ΔE_SCPC + q·ΔV_SCPC

- ε_VBM: **pure cell** VBM 사용 (neutral defect cell이 아님)
- ΔE_SCPC: SCPC energy correction (SCPCOUT에서)
- ΔV_SCPC: SCPC potential alignment — **charged ↔ neutral defect 간 정렬만 포함**, pure cell과의 정렬은 미포함
- neutral defect은 순전하 없으므로 ΔV(neutral↔pure)는 수 meV 이하로 일반적으로 무시 가능

**Why:** SCPC에서 neutral defect cell은 전하 보정의 기준점이지, VBM 기준이 아님. E_F는 물질 고유 band edge로부터 측정하므로 pristine host VBM이 올바른 기준.

**How to apply:** DFE 계산 시 pure slab의 VBM을 [[inas-band-alignment-method]] bulk-PBAND 방식으로 결정. SCPC 보정값은 energy correction과 PA를 별도로 적용.
