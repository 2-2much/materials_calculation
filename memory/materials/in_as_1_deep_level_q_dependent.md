---
name: in_as_1_deep_level_q_dependent
description: "04-InCl3 In_As_1은 charge state별로 성격이 갈린다 — q+1만 deep localized(스핀분열 빈 ↓준위), q0의 IPR 2.03×는 host 노이즈, q-1은 shallow CB 전자"
metadata: 
  node_type: memory
  type: project
  originSessionId: 640e3ab2-68c1-49e1-b49b-8fbed2a39915
  modified: 2026-07-22T05:53:47.294Z
---

`04-InCl3-passv_6L_4x2x1_HSE06/calc/In_As_1` (2026-07-22 분석). **하나의 결함이 아니라 전하상태별로 성격이 다르다.**

## q+1 = 진짜 deep localized (확정)
`01_Spin-gam-relax` 스핀분해: b512 ↑ E=−1.3147 occ=1.0 1/IPR=57.9(1.05×, VB 공명) / **b512 ↓ E=−0.9326 occ=0.004 1/IPR=12.5 = pure VBM의 4.84×, CBM의 8.41×**.
- exchange splitting **0.382 eV** (배경 밴드 이동 0.08~0.16의 2~5배)
- 원자투영 **In49 16.0 + In38 12.4 + In36 12.2 = 40.6%** → In 3배위 dangling bond (In_As antisite 화학과 일치)
- 위치: ↓ VB edge(b511=−1.332) 위 **0.40 eV**, CB(−0.146) 아래 0.79 eV → 갭 하부 1/3 in-gap
- mag=0.9943, **EENTRO=−0.0018≈0** → 수렴된 open-shell (스머링 가짜 아님, [[spin_magnetism_ipr_predictor]] 통과)
- E_relax=0.112 eV (bound 문턱 0.10 초과)
→ **점유 ↑는 VB 공명, 빈 ↓만 갭으로 밀려 올라오는 타입. 전자를 빼야 준위가 드러나므로 q0 스크리닝으로는 안 잡힘.**

## q0 = 근거 아님 (경계 오탐에 가까움)
frontier b512 IPR 2.03×는 **pure 슬랩 자체 점유밴드의 90퍼센타일(2.02×) 수준**. pure b499=2.84×, b501=2.50×이고 같은 셀 b510(frontier 아님)이 2.94×로 더 국소적. 결함 궤도가 b508~b512에 12~22%씩 분산된 VB 하이브리드. **"q0 IPR 2.03×라 deep"이라고 쓰지 말 것.**

## q-1 = shallow (deep 아님)
b513 ↑↓ E=0.319 occ≈0.50/0.50, 1/IPR=103 → **1.02× CBM**. mag=0.0010, EENTRO=−0.0564(=2×0.0282, 양채널 반점유 지문), E_relax=0.024. 추가전자는 host CB로 들어감 → **q−1에 model-charge 보정은 category error, shallow-limit 작도로.** [[slabcc_delocalized_defect_policy]]

## slabcc — q+1 **해결 완료**(2026-07-22), q−1은 정당한 거부
최초 55611/55612 둘 다 `[critical] model charge fairly delocalized`로 중단했으나 원인이 달랐다. 진단·조치는 [[slabcc_charge_truncation_guard]].
- **q+1 = 위양성이었음.** SLABCC_CHARGE_TOLERANCE=1e-3로 재실행(job 55622, `retry_qp1_tol/`) → 완주.
  **E_corr = +0.057932 eV** (dV=−0.040742, E_per=0.310607, E_iso=0.327797, σ_opt=3.034 bohr=1.61Å, RMSE 0.0843 V, 선형피팅오차 0.0025). ⚠보정은 정렬항 −q·dV(+0.041)가 지배, 이미지항은 0.017뿐.
  ⚠모델전하의 13.6%가 슬랩 밖(진공)에 있음(전하가 상부 계면 z=0.617 근처라 자연스러우나 기록해둘 것). 전위오차 이방성 5.25(z축 RMSE 최대).
- **q−1 = 진짜 비국소**, 재시도 무의미. 누락 1.95e-2(2%)=q+1의 134배. shallow-limit 작도로.
- `slab_corrections.csv` 갱신 완료(q+1=done+E_corr, q−1=rejected-delocalized).

## 참고
보정·ΔV정렬 없는 날것 ε(+1/0) ≈ VBM+0.17 eV (E(0)−E(+1)=−0.9963, pure VBM=−1.1612). KS 준위 VBM+0.40과 자릿수는 맞으나 **E_corr·정렬 빠져 인용 금지**. 관련: [[ipr_gate_tool]], [[bandfilling_measured_from_dos]], [[next_steps_2026_07_22]]
