---
name: inas100_as_in_termination_competition
description: As_In(As-rich) E_f=−0.40 eV는 μ_Cl 무관 → 점결함이 아니라 종단상 경쟁 신호. In-종단 (100):Cl은 As-rich 코너에서 유효한 기준면이 아니다
metadata: 
  node_type: memory
  type: project
  originSessionId: 6bd9a490-f3df-4628-92f5-b8648d42fb89
  modified: 2026-08-06T01:15:55.985Z
---

2026-08-06. `05-100Cl_8L_p4x4_PBE-d/results/raw_energies.csv`(00_Gam-relax, q0, PBE-d).

## 사실

**E_f(As_In) = +0.58 eV (In-rich) / −0.40 eV (As-rich).**
Δn = {In:−1, As:+1} 이므로 **Δn_Cl = 0** → μ_Cl을 어떻게 잡든 이 음수는 안 사라진다.
[[cl_as_negative_eform_reference_slab]]의 판별 규칙대로, 이건 **기준 슬랩 문제**다.

## 왜 종단상 경쟁인가

CONTCAR 이완 결과: As가 **맨(bare) In 자리**로 들어가서
- **As–As 2.50 Å 두 개** + In 2.79 Å 하나 (3배위)
- Cl 없음, In–In dimer 없음
- EIGENVAL: **갭 깨끗(0.845 eV), 갭준위 없음**

As–As 2.50 Å 쌍은 실험 InAs(100) **As-rich (2×4) β2 재구성(As-dimer)** 의 씨앗 그 자체다.
즉 "결함이 자발적으로 생긴다"가 아니라 **As-rich 코너에서 In-종단 (100):Cl 표면이 애초에
안정한 종단이 아니다**를 계산이 말하고 있는 것. (실험: In-rich → c(8×2)/(4×2) In-dimer,
As-rich → (2×4) As-dimer. 우리는 In-종단만 만들었다.)

## 조치 (택1)

1. **μ 창을 In-rich 쪽으로 제한**하고 캡션에 명시. InCl₃ 전구체 합성은 어차피 In-rich라
   실용적으로 이게 답이다. In-rich에서는 +0.58 eV로 멀쩡하다.
2. 정공법: **As-종단 (100) + 리간드 슬랩**을 비교군에 넣어 γ(μ_As) 교차점을 구한다.
   그래야 "어느 μ 창에서 어느 종단이 기준면인가"를 말할 수 있다.

⚠ 그림에 As-rich 패널을 그대로 두면 "As_In이 자발적으로 생긴다"로 오독된다.
음수의 정체는 종단 선택이지 점결함 열역학이 아니다.

관련: [[inas100_ligand_site_vs_electron]] [[inas100_mu_cl_convention_cl2]]
[[cl_as_negative_eform_reference_slab]] [[inas100_8ml_thickness_verdict]]
