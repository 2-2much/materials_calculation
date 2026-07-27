---
name: inas100_slab_generation
description: "InAs(100) 슬랩 세트 생성(02-100slab) — 극성면이라 dangling bond 2개/원자, (110) 6L↔8ML 대응, Cl 피복률 0.75ML가 electron counting으로 확정"
metadata: 
  node_type: memory
  type: project
  originSessionId: 60429d6d-24fe-4d48-bad7-63259cb37cb9
  modified: 2026-07-27T01:17:18.312Z
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

## Cl / acetate 피복률 = **0.75 ML** (electron counting 으로 확정)

표면 In 1개당 Cl 몇 개를 붙일지는 임의 선택이 아니다.
In–Cl 2전자 결합에서 In 이 3/4 e → Cl 이 5/4 e 를 내야 하고, Cl 에 7 − 5/4 = 5.75 e 만
남는데 lone pair 는 6 e 여야 한다 → **Cl 하나당 0.25 e 부족**.
반대로 안 채운 In dangling bond 는 3/4 e 를 갖고 있어 **0.75 e 과잉**.

| 피복률 | 1×1 당 수지 | |
|---|---|---|
| 2 Cl/In (1.0 ML) | −0.50 e | metallic |
| 1 Cl/In (0.5 ML) | +0.50 e | metallic |
| **3 Cl / 2 In (0.75 ML)** | 3(−0.25) + 1(+0.75) = **0** | **autocompensated** |

→ **1×1 에 Cl 을 꽉 채우면 반드시 금속이 나온다.** (2×1) 이상이 필수.
monodentate acetate 도 X-type 1전자 공여체라 counting 동일(bidentate bridging 은 다름).
이 제약이 결함 supercell 크기를 사실상 결정한다: (110) 3×2(13.13×12.38 Å) 대응은
(100) 3×3(13.13×13.13 Å) 인데 짝수 방향이 필요하므로 **4×2 또는 4×4** 검토.

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
