---
name: dncl-zero-vcl-clas-set
description: "04-InCl3 Δn_Cl=0 세트(V_Cl-Cl_As) 구축 완료 — μ_Cl 회피가 아닌 참조슬랩 검증이 목적, HSE neutral 6잡 확정"
metadata: 
  node_type: memory
  type: project
  originSessionId: 0d9c4228-ecec-42a3-8616-10c187b341a1
  modified: 2026-07-27T06:33:43.863Z
---

2026-07-27, `12-Surace-defect_calculation/04-InCl3-passv_6L_4x2x1_HSE06`.

Cl_As_1/Cl_As_2/Cl_i-As는 Δn_Cl=+1이라 μ_Cl을 탄다. 근처 passivation Cl을 하나 빼서
Δn_Cl=0으로 만든 complex 세트를 `Initial_POSCARs` + `config/defects.yaml`에 추가했다
(6개, charge_states=[0]). 상세 근거·인덱스·경고는 **defects.yaml 헤더 주석에 전부 기록**됨.

**⚠ 이 세트의 목적은 μ_Cl 회피가 아니다.** μ_Cl 문제는 [[mu_reference_phases]]의 InCl₃
pinning으로 이미 해결된다(계산 0, 선만 이동). Δn=0 조합의 진짜 값어치는 E_f가 곧
"passivation Cl → As 자리 이동" 반응에너지라는 것 → **E_f<0이면 결함이 아니라 InCl₃ 참조
슬랩이 바닥상태가 아니라는 뜻**([[cl_as_negative_eform_reference_slab]]의 02 병, −1.72 eV).
부호부터 볼 것. 또 Cl_As 단독(+2 도너)과 complex(+1 예상)는 **도너 세기가 다른 별개 결함**이라
편의로 갈아끼우면 안 된다.

**확정 6잡(HSE, neutral)**: V_Cl_br, V_Cl_te + near complex 4개
(Cl_As_1: br 4.13Å/te 6.15Å, Cl_As_2: br 3.92Å/te 3.89Å).
far 3개(Cl117/Cl125 제거)는 `test/`에 생성만 해두고 **보류** — 해리극한 검증은
V_Cl-Cl_As_1_te-near(6.15Å)가 사실상 대신해준다.
E_b = [E(complex)+E(pure)] − [E(Cl_As)+E(V_Cl)], μ 무관.

**⚠ Cl_As_2를 서열로 자르지 말 것**: antisite Cl116이 In_L114를 4배위로 과배위시켜 놓았고
(pure/Cl_As_1은 전부 3배위), near 제거가 그 과잉 리간드를 떼서 3배위로 되돌린다 →
E_b가 훨씬 클 수 있어 complex 서열이 뒤집힐 여지가 있다.

**⚠ `type` 선택은 slabcc 전하중심을 결정한다** (사용자가 잡아낸 함정).
run_charged_corrections.center_from_structure 분기:
antisite/interstitial → `coords[defect_atom_index-1]` 그대로;
**vacancy → reference_neighbors 좌표의 산술평균**이고 `defect_center_frac`은
평균의 unwrap seed로만 쓰인다(중심 아님). vacancy 분기는 빠진 원자가 배위껍질
**안쪽**에 있다고 가정 — 벌크 V_As/V_In은 맞지만 **표면 Cl 리간드는 껍질 바깥(진공쪽)**
이라 평균이 도달 못 한다. 실측 이탈: complex br 1.6/1.9Å, te 2.9/3.9Å, **V_Cl_te 2.32Å**.
→ complex 4개는 **`type: antisite` + `defect_atom_index: 116`** 으로 확정(도너가 Cl_As이고
V_Cl은 보상자이므로 물리적으로도 antisite가 전하중심). `reference_neighbors`에서 116을
빼고 vacancy의 In 이웃만 남겨 **slabcc 중심=antisite / MAGMOM 씨앗=저배위 In_L** 분리.
⚠ 남은 구멍: **V_Cl_br/V_Cl_te는 여전히 vacancy 평균이라 1.27/2.32Å 어긋남**.
q0에선 무해하나 하전 가면 손봐야 함(center_from_structure가 defect_center_frac을
문자 그대로 쓰도록 패치하는 게 최소 수정).

⚠ `type: complex`는 존재하지 않는 enum — get_defect_center_frac에서 ValueError 즉사.
⚠ 6개 전부 홀수전자(Cl −7e, Cl_As +2e) → 01_Spin-gam-relax 필수, mag→0은 정상
([[spin_magnetism_ipr_predictor]]). E_f(0)엔 band-filling 선행
([[bandfilling_measured_from_dos]]), DFE는 [[shallow_limit_dfe_construction]].

도구: `test/make_V_Cl.py` (index 기반 순수 vacancy, F F F 원자 제거 거부 가드 포함).
pure의 Cl orbit은 spglib(Pm) 확인 결과 **정확히 2개** — bridging 117–124, terminal 125–128.
Cl_As_1/2에서도 antisite가 116으로 들어가 passivation Cl은 117–128 번호를 유지한다.
