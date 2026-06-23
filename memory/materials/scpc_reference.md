---
name: scpc-reference
description: "SCPC Method GitHub README — INVCOR 가이드, REFCHG 그리드 호환 등 공식 문서 참조"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a4173c98-ddd1-4fc6-82ad-c08504f880c6
---

SCPC Method 공식 GitHub: https://github.com/aradi/SCPC-Method/tree/main/VASP

주요 참고 사항 (README 기준):
- **2.11**: INVCOR(IN) 설정 — pre-converged WAVECAR/CHGCAR 사용 시 INVCOR=1 필수, scratch면 3-8 권장. [[scpc-debug]]
- REFCHG/REFPOT은 neutral 계산에서 가져옴. **REFCHG의 FFT 그리드가 현재 계산과 일치해야 함** — PREC 변경 시 그리드가 달라져 "input conversion error" 발생 가능.

**How to apply:** SCPC 설정 관련 의문 시 이 GitHub README를 참조. PREC 변경 시 REFCHG/REFPOT도 동일 PREC로 재생성 필요.
