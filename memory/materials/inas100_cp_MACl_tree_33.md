---
name: inas100_cp_MACl_tree_33
description: 33-100MACl (sham) — 완전 co-passivated cp(100) 기준셀 구축. p(2x1) 시드이완 → par4x3 타일링. ★MA는 서 있는 배향(메틸 +x)이 최저, 누운 배향보다 52~71meV 낮다
metadata:
  type: project
---

2026-08-19. sham `12-Surace-defect_calculation/33-100MACl_8L_par4x3_PBE-d/`.
**(A) 완전 co-passivated 기준셀** — 6 In-dimer 전부에 Cl 1 + MA 1. 표면 In 전원 4배위
(In1+As2+L1) → **bare In 이 하나도 없다**. ChemComm 2017 SI Fig.S3(b) 의 cp(100)(2x1) 그 자체.
기준셀 (A)/(B) 논쟁의 결론은 [[inas100_MA_copassiv_tree_08]] 및 대화 참조: **(A)가 기준,
(B)=MA 하나 뗀 표면은 (A) 안의 V_MA 결함으로 흡수**. E_bind(MA, 첫 1개) = **+1.216 eV**
(08 pure/MA_i-In/mu_Ma 로 계산, 02_G221-DOS).

## 만든 순서 (`00-p2x1_seed_relax/`, 생성기는 그 안 `build/`)

1. **직사각 p(2x1) = 8.7537585 x 4.3768793 x 28.1243041 Å, 28원자**
   (In_d8/As8/H.75 4/Cl1/N1/C1/H5, NELECT 168 짝수, 고정 8 = pseudo-H4+하단As2+하단In2).
   par4x3 = p(2x1) 의 초격자, **S = [[2,0],[1,3]], det 6**. (t = a0/√2 = 4.3768793)
2. 시드: 08 `pure` CONTCAR(Cl-only, **ENCUT=400 이완**)가 par4x3 안에서 p(2x1) 주기성을
   0.0014 Å(a1=2t)/0.019 Å(a2=t) 로 만족함을 확인 → 08 `MA_i-In` 과 원자 인덱스 1:1
   (최대 변위 0.286 Å) → **MA 앵커 In23** 의 unit 21원자를 MA_i-In 좌표로 추출 + MA 7원자.
3. ⚠ **MA 를 그대로 얹으면 b축(4.377 Å) image 와 H···H 1.44 Å 충돌.** 08 은 6 dimer 당
   MA 1개뿐인 희박 배치라 방위가 자유로웠던 것. → In–N 축 회전 φ(3°) x 메틸 비틀림 θ(5°)
   스캔으로 min(d/(r_i+r_j)) 최대화. 극대 3개를 **전부 이완**했다.

| dir | φ/θ | 메틸 | E0 (eV) | ΔE |
|---|---|---|---|---|
| **orientA** | 63/115 | **+x (dimer row, 8.75 Å 주기) — 서 있음** | **−111.37654** | **0** |
| orientC | 333/0 | −y — 누움 | −111.32447 | +52 meV |
| orientB | 156/5 | +y — 누움 | −111.30613 | +71 meV |

★ 논문 Fig.S3(b) 는 MA 가 **눕혀져** 있는데, 완전 피복에서는 **서 있는 배향이 52~71 meV 유리**하다.
⚠ 세 잡 모두 EDIFFG −0.01 도달 전 사용자가 STOPCAR 로 정지(A 73스텝). 자유원자 최대 힘
≈0.07 eV/Å (MA 의 N). 에너지는 1e-4 eV/스텝로 평탄 → 서열은 견고하나 **절대값 인용 금지**.

## 계산 설정 (08 INCAR_00 기준, 셀이 작아 2개만 변경)
`LREAL=.FALSE.`(28원자에 real-space projection 부적절) / `KPOINTS 4x8x1 Γ-centred`
(p(2x1) Γ-only 는 par4x3 Γ-only 보다도 성김 — par4x3 Γ 는 p(2x1) BZ 의 6점으로 접힌다).
EDIFF 1E-6, EDIFFG −0.01. 나머지 동일. 바이너리 `6.3.2/vasp.6.3.2.std.x` (sham/g1 표준).

## ★ 타일링 — 절대 registry 보존이 핵심
`build/tile2.py <CONTCAR> <out> shift.json`. p(2x1) 셀을 만들 때 dimer 를 셀 중앙에 두려고
넣은 코스메틱 이동(shift.json)을 **타일링 때 정확히 되돌린다.** 안 되돌리면 05/07/08/09 와
registry 가 1.2~2.3 Å 어긋나 07 의 자리 대응표([[inas100_par4x3_defect_set_07]])를 못 쓴다.
검증: **고정원자(pseudo-H 24 + 하단 As 12 + 하단 In 12) 전부 08 pure 와 0.0000 Å 일치.**

`Initial_POSCARs/pure/POSCAR` = 168원자, In_d48/As48/H.75 24/Cl6/N6/C6/H30, **NELECT 1008**(짝수).
결합: In–In dimer 2.861 / In–Cl 2.466 / In–N 2.394 / N–C 1.479 / As–H.75 1.559 (07·08과 동일),
In–As 2.668~2.710. (2x1) 주기성 0.00000 Å. 진공 12.45 Å.
종 이름은 08/09 규약대로 **In_d, H.75** 를 그대로 씀 (07 은 In/H.75).

## 다음
config/ 구성(07·08 복사 + ENCUT 400 7종 POTCAR) → pure 를 par4x3 에서 재이완(Γ-only, family
설정 LREAL=A) → 결함 세트. 결함 정의는 **V_MA / V_Cl / V_In–V_MA / V_In@ligated** 네 개가 핵심.
가설 판정값은 `E_f(V_In–V_MA) − E_f(V_MA)` (μ_MA 가 정확히 상쇄되어 07 의 0.5 eV, 11/21 의
~2 eV 와 직접 비교 가능).
⚠ **μ_Cl 이 ENCUT=400 footing 으로 없다** — ½Cl₂ 한 번 돌리면 07/08/09/21/33 이 전부 풀린다.

관련: [[inas100_MA_copassiv_tree_08]] [[inas100_ligand_site_vs_electron]]
[[inas100_par4x3_defect_set_07]] [[inas100_par4x3_sheared_cell]] [[g1_node_vasp_binary_limit]]
[[inas100_mu_cl_convention_cl2]] [[cqd_ntype_origin_goal]]
