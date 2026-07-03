---
name: vclclas_atom95_fatband
description: "V_Cl-Cl_As/q0 03_Band fatband — atom 95(passivation Cl) spin up=dw 동일, 순 스핀 없음"
metadata: 
  node_type: memory
  type: project
  originSessionId: a19a1dd4-de23-4e4c-a6b5-fa331294948d
---

V_Cl-Cl_As/q0 03_Band(02-Cl-passv_6L_3x2x1_HSE06) fatband 분석 (2026-07-03).

셀 구성: In 1-36, As 37-71, H1 72-77, H. 78-83, Cl 84-95 (총 95원자). atom 95 = 마지막 passivation Cl. E-fermi=1.0810 eV, ISPIN=2, zero-weight k점 18, 450 밴드.

**결과: atom 95 projected fatband의 spin up과 down이 수치적으로 완전히 동일** (max proj weight 0.659, weight>0.05 밴드점 164개, 두 스핀 동일). 즉 passivation Cl(atom 95)은 순 스핀 성분(net moment)을 갖지 않음. 이 결함의 자성 mid-gap 상태는 defect 주변 원자(As 등)에 국소화되어 있음.

**Why:** V_Cl-Cl_As 자성 여부/국소화 위치를 확인하려 atom 95로 fatband을 봤으나, passivant Cl은 자성과 무관함을 확인. 자성 원자를 찾으려면 OUTCAR 원자별 magnetic moment로 어느 원자가 스핀을 담는지 봐야 함.

**How to apply:** fatband으로 스핀 국소화를 보려면 자성 담는 원자(defect As)를 먼저 특정한 뒤 그 원자로 재작도. 결과 파일: `.../V_Cl-Cl_As/q0/03_Band/zeroband_atom95_updw.png`(up/dw 나란히), zeroband_up.png, zeroband_dw.png. 도구는 [[zeroband_fatband_tool]]. 스핀 스크리닝 방침 [[surface_defect_spin_screening_full]].
