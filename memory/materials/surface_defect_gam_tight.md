---
name: surface-defect-gam-tight
description: "InAs (110) surface defect EDIFFG -0.02→-0.01 tightening 결과 — V_Cl-V_As 구조 재배열 확인, 1shot 검증 완료 (2026-06-25)"
metadata: 
  node_type: memory
  type: project
  originSessionId: d0d8276b-ba73-4bec-9a16-ab74deaab2ba
---

## 작업 내용
`12-Surace-defect_calculation/01-Cl-passv_6L_3x2x1/calc/` 내 12개 defect의 00_Gam-relax를 EDIFFG=-2E-2 → -1E-2로 tighten하여 continuation 계산.

**Why:** Force convergence를 더 타이트하게 하여 정확한 relaxed geometry 확보.

**How to apply:** 후속 01_Relax, 02_Band 단계 진행 시 새 CONTCAR 기반으로 진행해야 함. 특히 V_Cl-V_As는 반드시 -0.01 구조를 사용해야 함.

## 수렴 결과 (2026-06-25 확인)
- 12개 전부 "reached required accuracy"로 수렴 완료
- 10개 defect: max displacement < 0.11 Å, ΔE < 6 meV → -0.02에서 이미 충분히 수렴
- **In_As/q0**: max disp 0.77 Å, ΔE -24 meV, ionic 127 steps → 약간의 추가 relaxation
- **V_Cl-V_As/q0**: max disp **1.53 Å**, ΔE **-172 meV**, ionic 257 steps → 구조 재배열 발생
  - In#27이 0.87Å 상승, Cl#86/#88이 ~1Å씩 이동
  - 1shot (2×2×1 k-mesh) 검증: ΔE = **-177.5 meV** → 실제 안정 구조 확인 (spurious 아님)

## V_Cl-Cl_As DFE 이슈
- DFE가 -2.73 eV (In-rich), -1.97 eV (As-rich)로 매우 낮음 → 전자구조 분석 필요
- 1shot 계산 세팅 완료 (`01_1shot/`, `01_1shot_F002/`)

## 디렉토리 구조
- `00_Gam-relax_bak/` — 기존 -0.02 결과
- `00_Gam-relax/` — -0.01 결과 (현재 사용)
- `01_1shot/` — -0.01 CONTCAR 기반 1shot (2×2×1)
- `01_1shot_F002/` — -0.02 CONTCAR 기반 1shot (비교용)
