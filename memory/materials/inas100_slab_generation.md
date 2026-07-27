---
name: inas100_slab_generation
description: "InAs(100) 슬랩 세트 생성(02-100slab) — 극성면이라 dangling bond 2개/원자, (110) 6L↔8ML 대응, Cl 피복률 0.75ML가 electron counting으로 확정"
metadata: 
  node_type: memory
  type: project
  originSessionId: 60429d6d-24fe-4d48-bad7-63259cb37cb9
  modified: 2026-07-27T03:06:21.530Z
---

2026-07-27. (110) 결함 계산을 (100) 으로 확장하기 위해 아래 pseudo-H 패시베이션 /
위 bare 인 (100) 슬랩 세트를 만들었다.
위치: `33-inAs/__Functional_Validation__/10-Primitive-slab/01-Slab_generation_PBE-d/01-PBE-d-lat/02-100slab/`
(`make_100slab.py` + `In-terminated_POSCARs/` + `As-terminated_POSCARs/` + `slab_manifest.csv` + README)

## (110) 과 결정적으로 다른 점 — 극성면

(100) 은 [100] 방향으로 **In 면과 As 면이 a0/4 = 1.5475 Å 간격으로 번갈아** 쌓인다.
(110) 처럼 한 층에 In+As 가 같이 있지 않다. 따라서:

- 표면 원자 1개당 dangling bond 가 **2개** → pseudo-H 도 **2개**
- **(110) 노트북 v2.6 의 "표면법선 방향으로 H 1개" 방식은 (100) 에 쓰면 틀린다.**
  실제 정사면체 방향 (0, ±a/2, −a0/4) 을 정규화해서 붙여야 한다.
- 1×1 셀은 면당 원자 **1개**, 면내 격자 a0/√2 = 4.3769 Å 정사각
  (= (110) 셀의 a축과 같은 길이)
- 면내 offset 4주기: j%4 = 0,1,2,3 → (0,0), (½,0), (½,½), (0,½)

두께 대응: **(110) 6L = 11.085 Å ↔ (100) 8ML(4BL) = 10.832 Å**.
생성 범위 4~16 ML (4.64~23.21 Å). ML 은 짝수여야 In:As = 1:1.

## ⚠ 1×1 (100) 배위수는 minimum-image 로 세면 안 된다

면당 원자가 1개뿐이라 **인접면 이웃 2개가 같은 원자의 두 이미지**다
(둘 다 정확히 a/2 = 2.1885 Å 떨어져 있어 MIC 가 하나만 고른다).
MIC 로 세면 모든 배위수가 정확히 절반(4→2, 2→1)으로 나와 멀쩡한 구조가 전부 불량 판정된다.
검산기는 면내 이미지 (−1..1)² 를 전부 순회해야 한다. 또 pseudo-H 끼리는 결합이 아니므로
H–H cutoff 를 0 으로 둬야 한다(안 그러면 이미지 H 를 결합으로 오인).

## 리간드 피복률 = **In-다이머당 1개** (다이머 분지가 이긴다)

⚠ **2026-07-27 정정.** 처음 electron counting 으로 "표면 In 당 1.5개(=dangling bond 의 3/4)"
를 냈는데, 그것은 **비재구성 표면 분지**였다. 실제 표면은 (2×1) In-다이머를 이루고
그러면 답이 3배 낮아진다. 두 분지 모두 실재하며 다이머 쪽이 안정하다.

**출전**: `~/papers/QDs_from_QnMSG/2017_ChemComm_Atomic models for anionic ligand passivation.PDF`
(Ko, Yoo, Kim — KAIST, 같은 연구실). InAs(100) 을 직접 다룬다. 본문 그대로:
> "It is not trivial to passivate the **1.5 DBs** of InAs(100) with typical monovalent anionic
> ligands. For this purpose, the surface **first needs a (2×1) reconstruction through the
> formation of In–In dimerization**. Then, as the In–In metal-bond will consume two electrons
> among 3 DBs, **one additional anion can passivate the remaining 1 DB** in the In–In dimer."

다이머 1개(표면 In 2개) + 리간드 1개 수지: 채울 상태 = 다이머결합 1 + In–Cl 1 + Cl lone pair 3
= 5개 = **10 e**. 쓸 전자 = In 2개가 벌크결합에 3/4씩 내주고 남긴 **3 e** + Cl **7 e** = **10 e**. 정확히 맞음.

**논문 정량값 (PBE, meV/Å²)** — 표면 안정화에너지 / bare 표면에너지:

| 계 | 값 |
|---|---|
| bare b(110) / b(100) / b(111) | 28 / 78 / 55 |
| **lp(100) (2×1) acetate (다이머 + 50%)** | **44** |
| cp(100) (2×1) amine–halide | 102 |
| **비다이머 150% coverage** (= 내 최초 계산 분지) | **24** ← steric hindrance 로 짐 |

⚠ 논문의 (100) 할라이드 계는 **amine–halide 공동 패시베이션**이다. **Cl 단독 (100) 은 논문에 없다.**
전자수지상 "perfectly passivated by single anions" 라 성립해야 하지만, Cl monodentate 는
다이머당 **빈 In dangling bond 를 1개 남기므로**(acetate 는 bidentate 로 두 자리를 다 채움)
갭 준위 생성 위험이 실재한다 → 직접 gap 을 확인해야 한다.

**논문 SI 계산조건이 우리 셋업과 일치**: PBE+PAW, In 4d¹⁰5s²5p¹(=In_d), 진공 ~15 Å,
"polar surface slabs 는 cation-rich 앞면 + pseudohydrogen 패시베이션한 anion-rich 뒷면의
**비대칭 슬랩**", 힘 0.020 eV/Å, ENCUT 400.

## 그 외 미리 잡아둔 것

- **bare 극성 1×1 은 금속인 게 정상**(닫힌껍질 불가). 실험 InAs(100) In-rich 가
  c(8×2)/(4×2) In-dimer 재구성하는 이유. bare 슬랩을 결함 reference 로 쓰면 안 되고
  리간드 붙인 뒤가 reference.
- **dipole**: 극성 + 위아래 비대칭이라 (110) 보다 쌍극자가 크다. 단
  [[surface_defect_dipole_correction]] 의 HSE dipole-ON SCF 미수렴 이력이 있으므로
  PBE-d 에서 먼저 확인할 것.
- **진공**: 기본 15 Å(두께 수렴용). 하전 결함은 40~50 Å 필요 → `--vacuum 40`.
- **pseudo-H 간 거리**는 1×1 dihydride 종단이라 lateral supercell 을 키워도 안 멀어진다.
  In-term(As–H 1.52 Å) 1.895 Å 무난 / As-term(In–H 1.70 Å) 1.601 Å 촘촘 → As-term 을
  쓰게 되면 In–H 를 ~1.6 Å 로 줄일 것.
- 주력은 **In-terminated**(top bare In). Cl⁻/acetate⁻ 가 X-type 음이온이라 양이온에 붙는다.

관련: [[cqd_ntype_origin_goal]] [[cl_as_negative_eform_reference_slab]] [[defect_states_02_clpassv]]
