---
name: vclclas_atom95_fatband
description: "⚠정정: V_Cl-Cl_As/q0 atom 95는 passivation Cl이 아니라 Cl_As antisite. fatband up=dw(순 스핀 없음) 결과 자체는 유효하나 해석 대상이 뒤바뀌어 있었음"
metadata: 
  node_type: memory
  type: project
  originSessionId: a19a1dd4-de23-4e4c-a6b5-fa331294948d
---

V_Cl-Cl_As/q0 03_Band(02-Cl-passv_6L_3x2x1_HSE06) fatband 분석 (2026-07-03, **2026-07-17 정정**).

셀 구성: In 1-36, As 37-71, H1 72-77, H. 78-83, Cl 84-95 (총 95원자). E-fermi=1.0810 eV, ISPIN=2, zero-weight k점 18, 450 밴드.

**⚠ 2026-07-17 정정 — atom 95의 정체가 반대였다.**
- atom 95는 **Cl_As antisite**다 (z=17.971, 최상부 As층 z_max=18.18 안에 위치, In28/In30/In33와 2.638~2.767 Å 결합 = 3배위).
- **passivation Cl은 84–94**이고 z≈19.80~20.77로 표면 위에 떠 있다. 정상이면 12개인데 11개뿐인 것이 곧 V_Cl다.
- 즉 이 결함 = (passivation Cl 1개 빠짐) + (표면 As 자리를 Cl이 치환). 02_G221-DOS와 03_Band 모두 원자 순서 동일(좌표 1e-7 이내 일치)이므로 이 인덱싱은 두 단계에 공통.

**유효한 결과:** atom 95 projected fatband의 spin up/down이 수치적으로 완전히 동일(max proj weight 0.659, weight>0.05 밴드점 164개). 순 스핀 없음 — 이 사실 자체는 그대로다.

**정정된 해석:** "passivant Cl은 자성과 무관"이 아니라, **Cl_As antisite 자체가 스핀을 갖지 않는다**. 이것은 후속 COHP 분석([[vclclas_cohp_donor_evidence]])과 정합적이다 — Cl_As는 닫힌 껍질 이온성 Cl로 앉아 있어 미결합 라디칼이 없고, 따라서 자성이 생길 이유가 없다.

**Why:** 원자 인덱스를 z좌표/배위수로 확인하지 않고 "마지막 Cl = passivation Cl"로 넘겨짚어 14일간 해석이 뒤집혀 있었다. Cl 블록의 마지막 원소가 antisite로 들어가 있었다.

**How to apply:** 이 계열 슬랩에서 원자 지목 전 반드시 z좌표+배위수로 검증할 것 (passivation Cl은 z≈20, antisite는 z≈18에 In 3배위). 결과 파일: `.../V_Cl-Cl_As/q0/03_Band/zeroband_atom95_updw.png`. 도구는 [[zeroband_fatband_tool]]. 스핀 스크리닝 방침 [[surface_defect_spin_screening_full]], 결함 상태 정리 [[defect_states_02_clpassv]].
