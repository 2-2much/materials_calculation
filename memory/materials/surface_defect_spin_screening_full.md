---
name: surface-defect-spin-screening-full
description: "02-Cl-passv_6L_3x2x1_HSE06 전 defect 00_Gam-relax(non-mag) vs 01_Spin-gam-relax_PRECFOCK=N(spin) 스크리닝 완료 결과 (2026-07-01)"
metadata:
  node_type: memory
  type: project
  originSessionId: 0b838ed2-3a0f-4b92-a22c-131ab8936454
---

## 전체 defect 스핀 스크리닝 결과 (PRECFOCK=N으로 통일, [[surface-defect-gam-relax-spin-comparison]] 방식)
ΔE = E0(spin) − E0(nonmag), OSZICAR 마지막 줄 기준

| Defect/charge | ΔE (meV) | mag (μB) | 판정 |
|---|---|---|---|
| V_Cl-Cl_In/q0 | −268.1 | 1.00 | 강한 자성 ground state (최대) |
| Cl-As_In/q0 | −171.1 | 1.00 | 강한 자성 ground state |
| In_i_Td_In/q0 | −7.0 | 0.50 | **애매 — moment 있는데 안정화 미미, 재확인 필요** |
| In_As/q0 | −4.0 | ~0.00 | 비자성 |
| Cl-As_In/q+1 | −3.1 | 0.00 | 비자성 |
| V_Cl-V_As/q0 | −1.0 | ~0.00 | 비자성 |
| V_Cl-Cl_As/q0 | −0.8 | 0.0045 | 비자성 (기존 미결정 상태 해소) |
| pure/q0 | −0.6 | 0.00 | 비자성 |
| In_i_Td_As/q0 | −0.5 | 0.006 | 비자성 |
| As_In/q0 | −0.3 | 0.00 | 비자성 |
| V_Cl-V_In/q0 | −0.1 | 0.00 | 비자성 |
| As_i_Td_In/q0 | +0.5 | 0.025 | 비자성 |

## 결론
- **100 meV 이상 강한 안정화 + 정수 moment(1.0 μB) = V_Cl-Cl_In/q0, Cl-As_In/q0 둘뿐**. 둘 다 donor-acceptor 보상쌍(compensated pair) 구조 → 홀수 전자수 → open-shell radical (S=1/2) 패턴 공통. V_Cl-Cl_In은 V_Cl(도너성)+V_In(억셉터성) 조합으로 추정
- 나머지 defect는 짝수전자계로 ΔE가 대부분 1 meV 이하 → ISPIN=1로도 충분했을 것이나, 이미 전체 ISPIN=2로 통일하기로 결정함([[surface-defect-gam-relax-spin-comparison]])
- V_Cl-Cl_As는 이번 PRECFOCK=N 재실행으로 mag=0.0045 → 비자성으로 최종 확인(과거 old run의 미신뢰 문제 해소)
- **In_i_Td_In/q0는 예외적 케이스**: mag=0.50 μB로 뚜렷한 moment가 있는데 ΔE=−7 meV로 안정화가 미미함. 자성/비자성 solution이 거의 축퇴되어 있거나 SCF 미수렴 가능성 — 재확인 필요

**Why:** DOS/Band 본계산 전 spin-polarization이 유의미한 defect만 별도로 추적/검증할 필요
**How to apply:** V_Cl-Cl_In/q0, Cl-As_In/q0는 확실한 자성 defect로 formation energy/electronic structure 해석 시 반드시 고려. In_i_Td_In/q0는 본계산 진행 전 SCF 수렴 재확인 권장
