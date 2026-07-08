---
name: in_i_2_adatom_ejection
description: In_i_2/q0 (03-InCl3-passv)는 안정 결함 아님 — interstitial In이 3.76Å 튕겨나가 Cl층 위 저배위 adatom으로 배출. 음의 E_form은 In이 금속기준으로 회귀한 신호. 내일 재검토 TODO
metadata: 
  node_type: memory
  type: project
  originSessionId: 128f0b2e-1225-49fa-96e0-d9a67bd6705e
---

12-Surace-defect_calculation/03-InCl3-passv_6L_4x2x1_PBE-d, defect **In_i_2/q0** (Gam-relax, 힘 수렴 EDIFFG -0.01).

**증상**: interstitial In(atom49)이 이완 중 초기 frac_z 0.615(격자 내부) → 최종 0.719(Cl passivation 층보다 위)로 **3.76 Å 튕겨나감**(다른 원자는 최대 0.74 Å). 최종 최근접 이웃 = As86 **3.09 Å**, Cl **3.21 Å** → 정상 결합(In–As≈2.6, In–Cl≈2.4) 대비 전부 무결합. 즉 In이 격자에서 배출되어 Cl-passivated 표면 위 **저배위 In adatom**으로 떠 있음. "Cl에 붙었다"는 시각적 인상은 실제 결합 아님(3.2Å).

**형성에너지**: In-rich **−0.20 eV(음수)**, As-rich +0.29 eV (results/DFE_plots/DFE_at_EF0_summary.csv). 
⚠️해석: 음의 E_form = "In interstitial이 안정" 이 아니라, **In이 결함 대신 거의 금속 In 기준상태(μ_In metal)로 회귀** → 결함형성 비용 소멸의 신호. 이 표면에서 In_i는 존재 못하고 adatom으로 배출된다는 뜻. −0.20 eV 값 자체는 약결합 adatom이라 fragile(진공두께/lateral셀/PBE-d dispersion/초기배치에 민감).

**내일 TODO (맑은 정신)**:
1. ISPIN/magmom 확인 — In⁰ adatom open-shell 가능(In_i 자성 애매 이력, cf [[surface_defect_spin_screening_full]])
2. 이 adatom이 saddle인지 진짜 local min인지 판정
3. In이 실제 3-fold hollow/bridge에 앉아 In–As(~2.7)/In–Cl(~2.5) 결합 만드는 배치에서 재이완 → 더 낮은 min 탐색

관련: [[cqd_ntype_origin_goal]] μ-diagram에 이 fragile 값 올리기 전 검증 필요. [[incl3_cl_as_in_unbound]]와 유사 패턴(ideal 배치→표면종 이탈).
