---
name: inas100_pseudoh_lasph_footing
description: "(100) 슬랩 2대 함정: pseudo-H가 한 번도 이완된 적 없이 As-H=1.52 Å 씨앗값에 고정돼 있었고, (100) 트리 전체가 LASPH 없이 돌았다"
metadata: 
  node_type: memory
  type: project
  originSessionId: bc80c5b5-7478-4d31-a59b-c06425588c04
  modified: 2026-07-27T09:12:30.110Z
---

2026-07-27, `04-inplane_100_As_In-Cl/` 셋업 중 발견. 둘 다 (100) 트리 전반에 걸친 이월 사항.

## 1. pseudo-H 는 한 번도 이완된 적이 없었다

`make_100slab.py` 가 As–H = **1.520 Å 씨앗값**으로 놓고 `F F F` 로 고정한 뒤,
`02-Cl_arrangement_100` 도 `03-thickness_100_Cl-passv` 도 그대로 물려받았다.
풀어주니(2×2 8ML mono-A, 나머지 전부 고정) **1.520 → 1.559 Å (+0.039 Å)**,
H–H 최소는 1.895 → 1.849 Å. 8 이온 스텝.

왜 중요한가: 잘못 놓인 pseudo-H 는 **밴드 모서리**를 흔든다. 두께 판정에는 상수로
상쇄됐지만, 갭 근처 결함 준위를 읽는 계산에서는 곧바로 오염이다.
→ 이완 결과는 `04-inplane_100_As_In-Cl/00_H-relax/CONTCAR`.
   그 뒤 `01_Full-relax`(바닥 2면만 고정)까지 돌려 놓았고, 이것이 이후 타일링 소스다.

## 2. (100) 트리는 LASPH 없이 돌았다 ((110) 프로덕션은 켜져 있다)

`02-Cl_arrangement_100/INCAR0`, `03-thickness_100_Cl-passv/INCAR0` 둘 다 **LASPH 없음**.
반면 (110) a-dispersion 스캔·12-Surace 프로덕션은 `LASPH=.TRUE.`.

⚠ 그래서 00_H-relax 가 얻은 **−74.8 meV 는 "H 가 움직인 몫 + LASPH 를 켠 몫"이 섞인
값이다. H 이완 이득으로 인용하지 말 것.**

다행히 **기하는 거의 안 바뀐다**: LASPH 켠 채 전체(바닥 2면 제외) 재이완했더니
H-이완 구조 대비 **0.28 meV** 만 내려갔다(5 스텝). 즉 LASPH 는 사실상 상수 오프셋이고
자유원자 위치는 이미 최소점이었다. → 기존 (100) 기하는 재사용해도 되지만,
**에너지를 LASPH 있는 계산과 절대 섞지 말 것**(두께 판정 −7.6767 규칙과 같은 성격).

## 3. 부수: 8ML mono-A 2×2 참고값

E(01_Full-relax) = **−148.82720 eV** (LASPH on, EDIFF 1E-4/IBRION=1/ISIF=0, k 2×2×1,
NELECT 308, ISPIN=1). 비교: LASPH 없던 `02-Cl_arrangement_100/mono-A` = −148.72165.

관련: [[inas100_8ml_thickness_verdict]] [[inas100_slab_generation]] [[inas100_inplane_scan_todo]]
