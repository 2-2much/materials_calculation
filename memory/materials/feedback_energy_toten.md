---
name: feedback_energy_toten
description: "★에너지는 항상 free energy TOTEN 을 쓴다 (2026-09-24 사용자 결정, 모든 트리 공통). energy(sigma->0) 로 바꾸자고 제안하지 말 것"
metadata:
  type: feedback
---

**규칙:** OUTCAR 에서 에너지를 읽을 때는 `free  energy   TOTEN`(이온 스텝 끝 줄)을 쓴다.
새 스크립트·README·INCAR 주석 모두 이 기준으로 쓴다.

**Why:** 2026-09-24 사용자가 22-mu_reference_GaAsQD 에서 "TOTEN 을 쓰는 게 맞다", 이어서
"앞으로도 free energy TOTEN 을 사용할 것이다" 라고 명시. (MP smearing 금속에서는 F 가 변분량.)

**How to apply:**
- 파싱 정규식: `free  energy   TOTEN\s*=\s*(-?\d+\.\d+)` 의 마지막 값 (SCF 줄 `free energy    TOTEN` 과 공백 배치가 다름)
- 이 결정은 [[energy_column_sigma0_vs_toten]] 의 옛 권고(σ→0)를 **대체**한다. 옛 문서는 편향 크기
  기록(홀수 전자 셀 −σ/(2√π))으로만 참고하고, 컬럼 선택 근거로 인용하지 말 것.
- 스크립트를 짤 때 sigma->0 을 기본값으로 두지 말 것.
