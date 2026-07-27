---
name: inas100_inplane_scan_todo
description: "다음 과제(별도 세션): InAs(100) Cl-passv 8ML 에서 As_In+Cl 결함의 in-plane 셀 수렴(p4x3/p4x4/p4x5). LDA+hybrid 선례가 b축 부족→밴드 분산을 보여줌"
metadata: 
  node_type: memory
  type: project
  originSessionId: 60429d6d-24fe-4d48-bad7-63259cb37cb9
  modified: 2026-07-27T08:28:52.261Z
---

2026-07-27 개시 예정. 두께(out-of-plane)는 8 ML 로 끝났고([[inas100_8ml_thickness_verdict]]),
다음은 **in-plane 셀 크기**다. 사용자가 "이전은 out-of-plane, 이번은 in-plane 이므로
**별도 세션**에서 하자"고 명시했다.

## 과제

PBE-d(In 4d 포함)로 **p4×3 / p4×4 / p4×5** 에 대해 **As_In + Cl 결함의 밴드 분산 수렴성**을
확인한다. 8 ML, Cl-passv(mono-alt), tetragonal 유지(**slabcc 때문에 직교 필수**).

## 왜 — LDA+hybrid 선례가 문제를 보여준다

위치: `33-inAs/02-LDA/defective_slab/` (nonmagnetic LDA relax + HSE band, 절대값 정확도는
낮지만 **밴드 분산 수렴성**을 보기엔 충분)

- `100AA_p4x3.vasp` — pristine, 갭 깨끗 (17.137 × 12.852 × 31.661 Å, 직교)
- `100AA_p4x3_As_In_surface.vasp` — 표면 As_In: **VBM 근방 bonding state 에 전자가 차고,
  CB 근처에 antibonding state** 발생
- `100AA_p4x3_As_In_surf_AA-passv.vasp` — 그 As_In 에 **X-type 리간드(acetate)가 달라붙자
  antibonding state 에 전자가 차면서 밴드가 갭 안으로 내려옴** ← n형 기원 후보
  ⚠ 단 이 폴더는 NELECT 홀수 + ISPIN 미지정 이력이 있으니 수치 인용 시 확인할 것
- **문제**: p4×3 tetragonal 에서 그 갭내 밴드가 **flat 하지 않다** — b축(12.85 Å)이
  전자를 담기에 부족해서 결함–결함 주기 상호작용이 분산으로 나타난다
- `100AA_parallel4x3_As_In_AA-passv.vasp` — 셀을 **평행사변형**(a=(17.137,0), b=(8.568,12.852))
  으로 바꾸니 CBM 근처에서 나름 flat 해짐
- 파동함수 등가면이 **(110) 방향으로 계속 이어진다** → 결함 상태가 **이방적**이고 표면
  [110] 사슬 방향으로 뻗는다. 평행사변형이 통했던 이유이자, 직교 셀에서는 **짧은 축(b)을
  키워야** 하는 이유.

⚠ 우리는 slabcc 를 써야 하므로 **평행사변형 해법을 쓸 수 없다** → b 를 3→4→5 로 키워
직교 셀에서 수렴시키는 것이 이번 스캔의 목적.

- `00-100AA_As_In_AA-passv_Cellsize_ConvgTest/` 폴더가 이미 있으나 **POSCARs/ 가 비어 있다**
  (사용자가 LDA 단계에서 시작만 해두고 안 돌린 것). k 파일은 있음:
  `KPATH.in_100`(Y-Γ-X-S), `KPOINTS_SCF`(Γ 2×2×1), `KPOINTS_GAM`

## 착수 전 확인할 것

- **"As_In + Cl" 의 의미** = As_In antisite 에 **추가 Cl** 을 붙인 것(위 AA-passv 대응)이
  맞는지 확정. 이전 플랜에는 "결함 셀의 Cl 개수를 pristine 과 동일 유지"(Δn_Cl=0 으로
  μ_Cl 소거 + 도너 미보상)로 적혀 있어 **의도가 갈린다**. 선례상 갭내 상태를 만드는 것은
  리간드가 붙은 쪽이므로 둘 다 필요할 수 있다.
- k-density 를 셀마다 일정하게 (p4×3 의 2×2×1 이면 p4×5 는 2×2×1 유지 여부 판단)
- 각 셀마다 **pristine 짝 동반**(형성에너지·밴드모서리 기준)
- ⚠ InAs 도너 a_B = 349 Å 이라 **어떤 셀에도 안 담긴다** — "도너 준위가 밴드구조에 안 보인다"
  는 미수렴이 아니라 정상 ([[shallow_donor_inas_supercell_limit]])
- `ipr_gate.py` 는 사용자가 kohn 에서 수정 → GitHub push 후 clone 예정 (대기 중)

관련: [[cqd_ntype_origin_goal]] [[inas100_slab_generation]] [[slabcc_delocalized_defect_policy]]
[[passivated_surface_tiling_shortcut]]
