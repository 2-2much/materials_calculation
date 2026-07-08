---
name: incl3_cl_as_in_unbound
description: 03-InCl3-passv Cl-As_In q0 결과 — Cl이 As_In에 결합 안 하고 표면 In으로 감(bound complex 아님). complex 중심→독립 donor 스캔으로 재정렬 권고
metadata: 
  node_type: memory
  type: project
  originSessionId: be2e35fe-68fd-4740-909f-1cf615f9ce7d
---

**03-InCl3-passv_6L_4x2x1_PBE-d의 Cl-As_In q0 결과 해석 (2026-07-08)**

모델 구성(원자수): pure=Cl 12(=InCl3 passivation, In_L 4 : Cl 12 = 1:3). As_In=Cl 12. Cl-As_In=Cl **13**(passivation 12 + defect Cl 1개). 즉 defect는 "As_In antisite에 Cl 원자 1개 추가".

초기구조: As_In q0 CONTCAR 위에 Cl을 As_In 바로 위 수직(Cl–As≈2.0Å)으로 삽입. **최종(CONTCAR)**: As_In(As001)은 antisite 자리 거의 유지, 그러나 **Cl(Cl013)은 As_In에서 떨어져 표면 In으로 이동(In–Cl 2.41Å = 전형 In-Cl 결합)** → 사실상 InClx 재형성.

**결론**: "Cl–As_In complex"는 bound state가 아님(=As_In + In에 붙은 Cl 두 독립 defect). Cl은 강전기음성 음이온이라 In(양이온)에 붙는 게 화학적으로 옳음 → 계산 오류 아님, 올바른 물리. (같은 패턴 [[adispersion_scan_pbed]] ideal 배치→desorption.)

**defect 설계 권고**: complex를 여기저기 배치 스캔하는 것보다(대부분 같은 In-Cl basin으로 흘러감) **독립 donor 후보로 재정렬** — As_In 단독, In_i(석출 In), Cl_i/Cl_As 각각 계산 후 CTL을 μ-diagram에서 비교. 이번 구조도 버리지 말고 전자준위(DOS/band) 확인: As_In이 CBM 근처 donor 유지 & Cl 비활성이면 "As_In=n-type origin, Cl=passivant 재형성" 스토리. 상위목표 [[cqd_ntype_origin_goal]]. ⚠사용자가 ~/papers 논문 정리 후 defect 리스트 확정 예정.
