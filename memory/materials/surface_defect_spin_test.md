---
name: surface-defect-spin-test
description: "InAs (110) Cl-passivated surface defect spin test 결과 (2026-06-30), Cl-As_In/q0 자성 ground state 확인"
metadata: 
  node_type: memory
  type: project
  originSessionId: 0b838ed2-3a0f-4b92-a22c-131ab8936454
---

## Spin test 결과 요약 (02-Cl-passv_6L_3x2x1_HSE06)
ISPIN=2 single-point at Gam-relax geometry (수렴 확인: "EDIFF is reached")

| Defect | mag (μB) | ΔE (meV) | 판정 |
|--------|----------|----------|------|
| pure/q0 | 0.0 | +48 | 비자성, ISPIN=1 OK |
| As_In/q0 | 0.0 | +43 | 비자성, ISPIN=1 OK |
| Cl-As_In/q+1 | 0.0 | +39 | 비자성, ISPIN=1 OK |
| Cl-As_In/q0 | **1.0** | **−125** | **자성 ground state → 본계산 ISPIN=2 필요** |
| V_Cl-Cl_As/q0 | −0.975 | +33 | 미결정 (MAGMOM seeding 없이 실행된 old run, 재실행 필요) |

ΔE = E(ISPIN=2, Gam-relax 구조) − E(ISPIN=1, Gam-relax 최종)

## Cl-As_In/q0 자성의 물리적 이유
As_In(+2e donor) + Cl(−1e acceptor) → 홀전자 1개 → S=1/2 → 1.0 μB
per-site magnetization: atom 62(0.137), 64(0.130), 97(0.078) μB에 집중

## V_Cl-Cl_As/q0 재판단 필요
- old run: MAGMOM 없이 실행 → VASP 기본값 전체 1.0 μB → 미신뢰
- atom 95(defect_atom_index)에 mag 거의 없음(-0.002), 전체 원자에 −0.01씩 분산 → artifact
- run_spin_test.sh 수정 후(atom 95=2.0 μB seed) 재실행 예정

## Spin test 스크립트
위치: `02-Cl-passv_6L_3x2x1_HSE06/run_spin_test.sh`
- CASES 순서: V_Cl-Cl_As → Cl-As_In/q+1 → Cl-As_In/q0 → As_In → pure
- MAGMOM: build_magmom_string(runtime.yaml) + vacancy type patch
- runtime.yaml magnetic_seed: defect_moment=2.0, neighbor_moment=0.5

**Why:** 본계산(1shot+band) 전 spin 영향 선확인 목적
**How to apply:** Cl-As_In/q0 본계산은 ISPIN=2로 설정해야 함. V_Cl-Cl_As는 spin test 재결과 보고 결정
