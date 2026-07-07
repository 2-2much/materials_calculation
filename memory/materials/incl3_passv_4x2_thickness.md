---
name: incl3_passv_4x2_thickness
description: "03-InCl3-passv 4x2 슬랩 셀 구성(위 InCl3/아래 pseudo-H, 6층 11.3Å) + 두께 6L→5L 검토 진행상태·판단기준"
metadata: 
  node_type: memory
  type: project
  originSessionId: 7255c170-ba11-48f2-b865-733c28c90159
---

`12-Surace-defect_calculation/03-InCl3-passv_6L_4x2x1_PBE-d/inputs/pure/POSCAR` 셀 구성(2026-07-07 확인):
- **p(4×2), a×b = 17.51 × 12.38 Å, c = 30.26 Å, 총 128원자**
- **위(관심 표면, z≈20.5~22.8): InCl3 passivation** = In_L(4) + Cl(12), 비율 1:3
- **InAs 6 atomic layer** (z 7.66~18.57, 층간 ~2.18 Å, 두께 **11.3 Å**)
- **아래(인공 종단, z≈6.2~6.4): pseudo-H** = H1.25(As 댕글링용) + H.75(In 댕글링용), 8+8
- 하단 ~2층 Selective Dynamics로 고정(F F F)
- 이전 kohn 계산은 Cl-passivated **p(3×2) 6L**(두께 ~11 Å). 이번엔 lateral을 4×2로 키움.

**진행상태: 두께 6L→5L 축소 검토 중(미결정).** lateral 확장(+33% 원자)을 5L(≈9 Å)로 되돌려 옛 3×2-6L 대비 +11%로 비용 회수하려는 동기. (4/3)×(5/6)=1.11.

**판단기준(→ [[surface_defect_thickness_check_policy]]):** 두께는 lateral과 독립 수렴축이므로 5L을 가정으로 채택 금지. 위/아래 종단이 달라 슬랩 가로 dipole 있음 → 하전 결함 보정(bulk-PBAND 정렬)은 내부 bulk potential **plateau** 필요. 5L 채택 전 PBE-d로 pristine 5L vs 6L 비교: ①InCl3 표면에너지 ②LOCPOT planar-avg 내부 plateau 생존 여부(가장 결정적) ③표면층 In/As buckling. 5L이 ①③에서 6L을 ~10–20 meV 내 재현+②plateau 살아있으면 채택, 아니면 6L 유지. (110)은 non-polar·층당 stoichiometric이라 5L도 polarity/termination 문제 없음. 5L 생성 시 표면 2개는 그대로 두고 **내부 bulk 한 층만 제거**.

관련: [[surface_defect_1shot_band_workflow]], [[adispersion_scan_pbed]]
