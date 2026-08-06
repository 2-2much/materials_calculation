---
name: inas100_mu_cl_convention_cl2
description: "사용자 결정: μ_Cl은 일단 ½Cl₂(Δμ_Cl=0)를 쓴다. 재론 금지. 대신 '경계값'으로 읽어야 하고, InCl₃-pinned 값은 참고표로 보존"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6bd9a490-f3df-4628-92f5-b8648d42fb89
  modified: 2026-08-06T01:15:35.829Z
---

2026-08-06. 사용자 확인: **μ_Cl은 일단 ½Cl₂(기체)를 쓰기로 이미 합의했다.**
`05-100Cl_8L_p4x4_PBE-d/plot_DFE.sh --mu_Cl -1.78515` (= ½E(Cl₂), PBE-d) 이 현재 규약이다.

**Why**: ½Cl₂는 same-footing으로 재현 가능한 정의된 상한이다. InCl₃ 쪽은
solid ΔH_f를 아직 같은 footing으로 계산 안 했고(gas-monomer/solid 사이 0.55 eV 벌어짐),
기준을 바꾸면 이미 돌린 세트와 비교가 끊긴다. → **매번 "μ_Cl 틀렸다"고 다시 꺼내지 말 것.**
[[cl_as_negative_eform_reference_slab]]의 "04 배선 문제" 지적은 진단 도구로는 유효하나,
(100) 05 프로젝트의 **현재 채택 규약은 ½Cl₂**다.

**How to apply**: Δμ_Cl=0은 Cl-rich 극한이므로 E_f를 **경계값**으로 읽는다.
- Δn_Cl>0 결함(Cl_i, Cl_In, Cl_As, Cl-As_In): E_f의 **하한**(가장 싸게 나오는 값)
- Δn_Cl<0 결함(**V_Cl**): E_f의 **상한**(가장 비싸게 나오는 값)
- Δn_Cl=0 결함(**As_In, In_i, V_In, In_As, V_Cl-Cl_As**): **μ_Cl과 무관, 절대값 그대로 유효**
그림/발표에는 "Cl-rich limit (Δμ_Cl=0)"을 축이나 캡션에 명시할 것.

## 참고: InCl₃ pinning을 걸면 어떻게 되는가 (보존용, 채택 아님)

`results/raw_energies.csv`(00_Gam-relax, PBE-d, q0)에서 재계산. Δμ_Cl = −1.309(In-rich) /
−1.146(As-rich), gas-monomer InCl₃ 기준. solid 기준이면 −1.857 / −1.694.

| 결함 | Δn_Cl | In-rich (Δμ_Cl=0) | In-rich pin(gas) | As-rich (Δμ_Cl=0) | As-rich pin(gas) |
|---|---|---|---|---|---|
| Cl_In | +1 | −0.69 | +0.62 | −1.18 | −0.03 |
| Cl_i-In | +1 | −1.07 | +0.24 | −1.07 | +0.08 |
| Cl_i-As | +1 | −0.98 | +0.33 | −0.98 | +0.16 |
| Cl_As | +1 | −1.00 | +0.31 | −0.51 | +0.64 |
| Cl-As_In | +1 | −0.12 | +1.19 | −1.10 | +0.05 |
| **V_Cl** | −1 | 2.18 | 0.87 (solid 0.33) | 2.18 | 1.04 |
| **In_i_sub** | 0 | **0.16** | 0.16 | **0.64** | 0.64 |
| In_i_surf | 0 | 0.22 | 0.22 | 0.71 | 0.71 |
| **As_In** | 0 | **0.58** | 0.58 | **−0.40** | −0.40 |
| V_In | 0 | 1.01 | 1.01 | 0.53 | 0.53 |
| In_As | 0 | 0.55 | 0.55 | 1.52 | 1.52 |
| V_As | 0 | 1.09 | 1.09 | 1.58 | 1.58 |
| V_Cl-Cl_As | 0 | 0.61 | 0.61 | 1.10 | 1.10 |

**읽는 법**: Cl 추가 결함의 음수는 Cl-rich 극한의 산물이므로 "자발적 생성"으로 서술하면 안 된다.
μ_Cl과 무관하게 살아남는 결론은 두 개뿐 —
**In_i_sub가 0.16 eV로 가장 싸다**, 그리고 **As_In(As-rich)이 −0.40 eV로 음수**
(→ [[inas100_as_in_termination_competition]]).

⚠ 위 수치는 `00_Gam-relax`(ISPIN=1) 기준이라 발표 슬라이드(스핀/HSE 1shot 단계)와 수백 meV
어긋날 수 있다. 서열과 μ 의존성 구조는 같다.
μ 세트 자체는 [[mu_reference_phases]] (HSE06 footing) / plot_DFE.sh (PBE-d footing) 별개 관리.

관련: [[inas100_ligand_site_vs_electron]] [[cl_as_negative_eform_reference_slab]] [[mu_reference_phases]]
