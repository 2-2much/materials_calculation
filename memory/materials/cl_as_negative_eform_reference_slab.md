---
name: cl-as-negative-eform-reference-slab
description: "02/04 음의 형성에너지 — Δn_Cl로 원인이 갈린다. 02는 reference 슬랩이 바닥상태 아님(진짜), 04는 μ_Cl에 InCl3 구속 없음(배선)"
metadata: 
  node_type: memory
  type: project
  originSessionId: f4bfd3d3-c080-491a-b5ba-f0c4ca66ef42
  modified: 2026-07-20T05:29:41.448Z
---

2026-07-20. 02(Cl-passv)와 04(InCl3-passv) 모두 Cl이 As 자리를 차지하는 결함이 **음의 형성에너지**로
최저인데, **원인이 서로 다르다.** 판별 도구는 **Δn_Cl** — Δn_Cl=0이면 μ_Cl이 항등적으로 소거되므로
음수라도 μ_Cl 탓일 수 없다.

| 결함 | Δn_Cl | E_f(In-rich) | E_f(As-rich) | 진단 |
|---|---|---|---|---|
| 02 `V_Cl-Cl_As` | **0** | −1.078 | **−0.319** | 양 극한 모두 음수 → **(a) reference 문제 확정** |
| 04 `Cl_As_1` | +1 | −0.701 | +0.058 | μ_Cl 의존 |
| 04 `Cl_i-As` | +1 | −0.292 | −0.292 | **(b) μ_Cl 문제 확정** |

## 02 — reference 슬랩이 바닥상태가 아니다 (진짜 물리)
`V_Cl-Cl_As`는 delta_atoms {As:−1}, Cl 개수 불변(패시베이션 Cl 하나가 As 자리로 **이동**).
μ_As 허용 범위 **전체**에서 E_f<0이라 화학퍼텐셜로 못 없앤다. 에너지 분해:

```
pure → V_Cl-V_As + As + Cl   : +0.646 eV
Cl을 As 자리에 채움            : −1.724 eV
합계                          : −1.078 eV ✓
```
→ 패시베이션 Cl이 3배위 As 자리를 **1.72 eV 선호**. 원자수(96→95)·NELECT(744→739, Δ=−5=As ZVAL)
정합 확인되어 계산 오류 아님. **참이면 02의 모든 E_f가 ~+1.08 eV 이동한다.**
→ 조치: `V_Cl-Cl_As` 기하를 **새 pure reference 후보**로 재이완.

## 04 — μ_Cl에 InCl3 구속이 없다 (배선)
두 폴더 모두 **μ_Cl = −2.69764 = ½E(Cl₂) = Cl-rich 극한**을 In/As 조건과 무관하게 고정.
In이 있는 계에서는 `Δμ_In + 3Δμ_Cl ≤ ΔH_f(InCl₃)`가 걸려야 한다.
실험 ΔH_f(InCl₃,s) = −537 kJ/mol = **−5.57 eV**(추정, DFT 미계산) 기준:
- In-rich(Δμ_In=0): **Δμ_Cl ≤ −1.86 eV**
- As-rich: **Δμ_Cl ≤ −1.60 eV**

현재 Δμ_Cl = **0** → **허용 범위를 1.6~1.9 eV 위반.** 구속을 넣으면(추정)
`Cl_i-As` −0.29→+1.56, `Cl_As_1` −0.70→+1.15로 **04의 음수는 전부 해소되고 02의 음수만 남는다.**
04는 리간드가 문자 그대로 InCl₃이므로 부등식이 아니라 **등식**(공존상)이어야 한다.
CQD 합성이 InCl₃ 전구체 기반 = In-rich + Cl-rich라, 하필 연구 대상 조건에서 제약이 가장 강하다.

→ 조치: **InCl₃ 벌크 HSE06(AEXX=0.27) 1런**으로 same-footing μ_InCl3 확보.
그리고 In-rich/As-rich 2점이 아니라 **(Δμ_In, Δμ_Cl) 2D 안정영역 다이어그램**으로 확장.

## ⚠ μ_Cl provenance 구멍
−2.69764(=½×−5.39528)의 출처 계산이 `~/materials` 트리 어디에도 **없다**.
[[cl2_hse06_calc]] 메모에만 존재 → 재현 불가. Cl₂ HSE06 계산을 트리에 복원할 것.
(11-Surface toy의 Cl₂는 PBE라 무관.)

## 규모 참고
[[energy_column_sigma0_vs_toten]]의 smearing entropy 편향은 −1.078 → −1.050 eV로 **2.6%**만
움직여 음수를 설명하지 못한다.

관련: [[cqd_ntype_origin_goal]], [[defect_states_02_clpassv]]
