---
name: inas100_acetate_tree_09
description: 09-100AA 트리 — 아세테이트는 dimer가 아니라 trench를 가로지르는 bidentate. pure 이완 결과와 CB 대칭화
metadata: 
  node_type: memory
  type: project
  originSessionId: 7fd23945-c8fb-4696-b74d-fae8b95beb6a
  modified: 2026-08-11T03:34:43.280Z
---

`12-Surace-defect_calculation/09-100AA_8L_par4x3_PBE-d/`. 2026-08-11 생성.
07(Cl-only) 슬랩에서 Cl 6개를 떼고 **아세테이트(CH₃COO⁻) 6개**로 패시베이션한 트리.
162 atoms = In_d 48 / As 48 / H.75 24 / C 12 / O 12 / H 18. NELECT = 1020(짝수).

## ★ 흡착 모드 — dimer 위가 아니라 dimer 사이 골(trench)

LDA 참조 CONTCAR(`Initial_POSCARs/Previous_LDA/`)를 뜯어서 확인한 것. 카르복실 두 O가
**같은 dimer의 두 In이 아니라, 이웃한 두 dimer의 마주보는 In**에 하나씩 붙는다.
dimer row 방향으로 `In–O–C(–CH₃)–O–In` 사슬. LDA 6유닛이 서로 0.013 Å 안에서 동일했다.
→ 표면 In 12개가 **전부** 배위된다. 07은 dimer당 하나가 맨몸으로 남았다
([[inas100_ligand_site_vs_electron]]의 "전자1/자리2"를 카르복실레이트가 정확히 만족).

trench 짝(1-idx, 짧은 O–In → 긴 O–In): 8→31, 16→39, 24→47, 32→7, 40→15, 48→23.
아세테이트 원자 인덱스(unit u=0..5): C_methyl 121+2u, C_carboxyl 122+2u,
O_short 133+2u, O_long 134+2u, H 145+3u·146+3u·147+3u.

## pure 이완 결과 (00_Gam-relax, PBE-d, Γ-only)

`calc/pure/q0/00_Gam-relax/CONTCAR` = **이 트리의 기준 기하. defect cell은 전부 여기서.**
E(pure) = **−690.39308907 eV**. 270 스텝 / 90분 / fermi 32코어.

- 흡착 모드 유지. 6유닛 전부 동등(0.01 Å 이내), 각 O의 2nd-nearest In은 3.5 Å 이상.
- **In–In dimer 2.903 → 3.048 Å (+0.145)** — 두 In이 모두 O 배위를 받아 dimer 결합 의존이 줄었다.
- **top In 버클링 0.262 → 0.124 Å** — 07처럼 한쪽만 올라오지 않고 평평해진다.
- O–In 2.224 / 2.401 Å, trench In–In 5.869 → 5.71 Å, 진공 12.64 Å.

## Γ점 밴드 — 비대칭이 사라진다 (총 무게는 안 줄어든다)

Γ 갭 0.966 eV (07은 0.958 — 사실상 같다). 전도대 가장자리를 두 In 부분격자에 원자당 사영:

| | 07 (Cl) 맨몸:Cl-capped | 09 (acetate) In_long:In_short |
|---|---|---|
| LUMO / +2 / +3 | 1.60 / 2.13 / 1.70 | 0.98 / 1.01 / 0.98 |

07은 전도대 바닥이 맨몸 In에 쏠려 있고([[inas100_dimer_row_chain]]) 09는 그 비대칭이 완전히
사라진다. ⚠ **하지만 top-In 총 무게는 오히려 늘었다(07 14~28% → 09 35~40%).**
아세테이트는 전도대를 표면에서 밀어낸 게 아니라 표면 In을 균등하게 만든 것이다.
사슬 밴드가 실제로 죽었는지는 분산이 필요 → stage 03(Band)을 켜야 판정된다. Γ-only PBE 한 점으로
결론 내지 말 것.

## 함정

- ⚠ **ENCUT=400.** 표준 C·O PAW의 ENMAX가 400이라 07의 300으로는 안 된다.
  → **07/09 총에너지 직접 비교 금지.** 08(400)과도 POTCAR 세트가 달라 섞지 말 것.
- ⚠ **μ_acetate 없음.** E_f를 쓰려면 ENCUT=400·같은 POTCAR로 고립 분자 계산이 필요하다.
  그전까지는 트리 내부 총에너지 차만 읽을 것.
- POTCAR 순서 `In_d As H.75 C O H`, 전부 `2.POTPAW.PBE.54.RECOMMEND`.
  `species_aliases`에 `H.: H.75` 필요(CONTCAR가 H.75를 H.로 자름).
- 초기구조는 **Cl 상태로 이완된 슬랩** + 강체 아세테이트라 이완이 270스텝이나 걸렸다.
  메틸 회전 때문에 CG 끝단이 길다(130~200스텝에서 max|F| 0.03~0.13 진동).
  재이완할 일 있으면 IBRION=1(RMM-DIIS)로 끝단 처리가 빠르다.
- stages.yaml은 지금 **00만 활성**. defect 세트 만들 때 01/02/03 다시 켤 것
  ([[stages_yaml_dos_band_contamination]] 주의).

실행 환경은 [[fermi_node_setup]]. 관련: [[inas100_par4x3_defect_set_07]],
[[inas100_MA_copassiv_tree_08]], [[inas100_par4x3_sheared_cell]], [[cqd_ntype_origin_goal]]
