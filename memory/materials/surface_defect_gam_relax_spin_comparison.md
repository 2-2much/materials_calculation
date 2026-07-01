---
name: surface-defect-gam-relax-spin-comparison
description: "02-Cl-passv_6L_3x2x1_HSE06 Cl-As_In/q0 00_Gam-relax(non-mag) vs 01_Spin-gam-relax(spin) 비교, PRECFOCK 기본값 확인, projected magnetization 해석 (2026-07-01)"
metadata:
  node_type: memory
  type: project
  originSessionId: 0b838ed2-3a0f-4b92-a22c-131ab8936454
---

## 폴더 구조 (모든 defect 공통)
- `00_Gam-relax` — ISPIN=1 non-magnetic, **PRECFOCK 미지정 = 기본값 Normal**
- `01_Spin-gam-relax` — ISPIN=2, PRECFOCK=Fast로 지정됨 (00과 PRECFOCK 다름 → 직접 비교 불가)
- `01_Spin-gam-relax_PRECFOCK=N` — ISPIN=2, PRECFOCK=Normal (00과 PRECFOCK 일치 → **이게 올바른 비교 대상**)
- 위 폴더들은 Cl-As_In 외 다른 defect(As_In, V_Cl-Cl_As 등)에도 동일 패턴으로 존재하나, PRECFOCK=N 버전은 현재 Cl-As_In(q0, q+1)에만 있음

## Cl-As_In/q0 에너지 비교 (올바른 조합: PRECFOCK 통일)
- `00_Gam-relax` (ISPIN=1, PRECFOCK=Normal 기본값): E0 = −423.16429 eV
- `01_Spin-gam-relax_PRECFOCK=N` (ISPIN=2, PRECFOCK=Normal): E0 = −423.33535 eV
- **ΔE = −171 meV (spin-polarized가 더 안정) ← 이 값이 정답, PRECFOCK=Fast 버전(−134 meV)은 00과 비교 불가하므로 폐기**

## Projected magnetization이 작게 나오는 이유 (OUTCAR 분석)
- OSZICAR: `mag = 1.0000` (셀 전체 적분 moment, S=1/2)
- OUTCAR magnetization table 합: `tot = 0.639 μB` (PAW sphere 내부만 적분)
- 차이(~0.36 μB)는 PAW sphere 바깥(interstitial/vacuum)에 분포 → **delocalized shallow acceptor state의 정상적 특징이지 오류 아님**
- 원자별 분포: atom 62(0.146), 64(0.134), 97(0.070), 91(0.034), 93(0.031), 36(0.065)에 상대적 집중, 나머지는 0.001~0.01 수준으로 넓게 퍼짐. p-orbital 성분이 s보다 훨씬 큼(예: atom62 p=0.126 vs s=0.020) → 표면 p-like acceptor state 그림과 일치
- 이전 spin test(ISPIN=2 single-point) 결과의 atom 62/64/97 집중 패턴(0.137/0.130/0.078)과 정성적으로 일치 → [[surface-defect-spin-test]]

## 결론
- Total moment가 정수(1.0 μB)로 수렴 + ΔE=−171 meV(수렴 noise 대비 훨씬 큼) → **실제 자성 ground state, 작은 per-atom 값에도 불구하고 유효**
- Cl-As_In/q0 본계산은 ISPIN=2로 진행 확정

**Why:** formation energy 계산 전에 non-mag/spin 비교가 PRECFOCK 불일치로 왜곡되어 있었음. 00의 기본값이 Normal임을 확인해 올바른 짝을 찾음
**How to apply:** 다른 defect도 00_Gam-relax와 스핀 비교 시 반드시 `01_Spin-gam-relax_PRECFOCK=N` (또는 PRECFOCK=Normal로 새로 생성한) 폴더와 비교할 것. PRECFOCK=Fast 버전과 00을 직접 비교하지 말 것
