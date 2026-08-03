---
name: precfock_fast_policy
description: "PRECFOCK=Fast는 ~2배 빠르고 셀 하나의 에너지는 거의 같지만 오차가 화학종마다 달라 상쇄되지 않음 — Δn=0이면 안전, Δn≠0 절대 E_f는 기준상까지 같은 footing 필요"
metadata: 
  node_type: memory
  type: project
  originSessionId: c112f7c9-ad4a-4a61-8428-865a9d3d4938
  modified: 2026-08-03T16:31:49.153Z
---

2026-08-04, 사용자 관측: **PRECFOCK=Fast가 Normal 대비 약 2배 빠르고 에너지 차이는 작다.**
→ 다른 폴더의 defect 계산에는 Fast를 쓰겠다는 방침.

## ⚠ 이 프로젝트는 같은 판단을 했다가 되돌린 적이 있다
2026-07-22에 기준상 세트를 **전부 Normal로 통일하고 fast 세트를 폐기**했다([[mu_reference_phases]]).
이유는 "fast가 부정확"이 아니라 **오차 크기가 화학종마다 달라 상쇄되지 않는다**는 것:

| fast → Normal | ΔE |
|---|---|
| H₂ | **+31.0 meV** |
| HCl | **+14.0 meV** |
| Cl₂ | **+3.8 meV** |

(참고: Cl₂ 자체 계산은 원래 fast로 돌렸었다 — [[cl2_hse06_calc]]. 그게 폐기된 세트다.)

## 판단 기준 = "Fast냐 Normal이냐"가 아니라 **"한 footing이냐"**
`E_f = [E(defect) − E(pure)] − Σnᵢμᵢ + q(E_VBM+E_F) + E_corr`
- **대괄호 항**: 같은 셀·거의 같은 조성 → PRECFOCK 오차 대부분 상쇄. **Fast 안전.**
- **Σnᵢμᵢ 항**: μ는 기준상(Cl₂/HCl/InCl₃/In metal)에서 오고 그건 **Normal로 고정**돼 있다.
  결함 셀만 Fast로 가면 **Δn≠0 결함에서 상쇄 안 되는 오차**가 남는다.

**→ 운용 규칙**
- ✅ Fast: Δn=0 결함([[dncl_zero_vcl_clas_set]] 류), 구조 이완, 밴드/DOS/IPR 분석,
  동일 설정 내 서열 비교, 스크리닝
- ⚠ Fast 금지(또는 기준상까지 Fast로 새로 갖출 것): **Δn≠0 결함의 절대 E_f**.
  기존 Normal μ 세트(μ_Cl, μ_H, μ_In)를 그대로 가져다 쓰면 footing이 깨진다.
- 새 폴더가 **자체 기준상까지 전부 Fast**면 자기정합이라 문제없다. 섞는 게 문제다.

## 미측정 — 채택 전에 이것 하나는 재고 갈 것
위 수치는 전부 **작은 분자** 기준이다. **100~130원자 슬랩에서 PRECFOCK이 E_f를 얼마나
움직이는지는 측정된 적이 없다.** 대괄호 항의 상쇄가 실제로 얼마나 잘 되는지가 관건.
검증은 싸다: **pure 슬랩 1개 + 결함 1개를 두 설정으로 single-point 4번** 돌려 E_f 차이를 본다.
차이가 ≲10 meV면 Δn≠0에도 Fast 전면 채택 가능.

관련: [[hse_slab_scf_settings]](ALGO=Damped 처방), [[pbe_then_hse_workflow_plan]],
[[cl_as_negative_eform_reference_slab]](μ footing이 깨졌을 때 나타나는 증상)
