---
name: inas111-slab-generation
description: InAs(111)A 슬랩 생성기(03-111slab) 기하 규약 + bare p2x2는 NELECT 홀수라 (2x2) In-vacancy 재구성이 필요하다는 판정
metadata: 
  node_type: memory
  type: project
  originSessionId: f5c1c286-303c-4cef-b4bf-6b89adb7c5ce
  modified: 2026-08-13T10:37:04.289Z
---

2026-08-13, bloch `~/materials/33-inAs/__Functional_Validation__/10-Primitive-slab/01-Slab_generation_PBE-d/01-PBE-d-lat/03-111slab/`
에 `make_111slab.py` + README 작성. (110)/(100) 생성기와 같은 footing(PBE-d a0=6.189842,
As–H 1.52 Å, `H.75`, 아래 고정영역 상수).

**기하 규약** — (111)은 (100)처럼 극성면이지만 쌓임이 불균등하다. In-As 이중층 안은
3결합으로 촘촘하고 이중층 사이는 수직결합 1개라 멀다. 벽개는 결합 1개 자리에서 →
**표면 원자당 dangling bond 1개**. 그 방향이 정확히 ±[111]이라 pseudo-H는 수직으로 붙인다.
- 면내 1×1 = 60° 육방, a = a0/√2 = 4.376879 Å, 면당 원자 1개
- d_BL = a0/√3 = 3.573707 / 이중층 내부 h = a0√3/12 = 0.893427 / 이중층 사이 = a0√3/4 = 2.680280 (= In–As 결합)
- ABC offset: 원자면 m에 대해 `unit(m) = floor((m+1)/2) mod 3`, offset = unit/3·(A1+A2)
- 두께 = (n_BL−1)·d_BL + h. **4 BL = 11.615 Å**(2×2에서 36원자, (110) 6L·(100) 8ML 대응)

**교차검증**: LDA a0를 넣고 6BL을 재생성해 선례 `111bare_p2x2.vasp`와 대조 →
아래 3 이중층 Δ=0.0000 Å, 격자벡터 1e-10 일치. 위쪽 Δ≤0.037 Å은 선례가 이완된 구조라서.
pseudo-H만 0.039 Å 차 — 선례는 As–H 1.5588, 우리 규약은 1.52.

**⚠ 함정 2개**
1. 60° 육방 = **비직교** → slabcc/CoFFEE 하전보정 불가 ([[inas110_bare_par3x2_pure_cell]]의 전단셀과 같은 제약).
2. **bare (111)A는 NELECT 홀수** (2×2 4BL = 291). 표면 In 4개×3/4 e = 3 e가 남는다.
   → bare를 결함 reference로 쓰면 안 됨([[hse_1shot_pitfalls_and_q0_results]]·(100) README §2와 같은 함정).
   해법 = 실험적으로 알려진 **(2×2) In-vacancy 재구성**(표면 In 4개 중 1개 제거) → 278, 짝수.
   ★p2×2를 고른 것 자체가 이 재구성을 담는 최소 셀이라는 뜻. 생성기엔 아직 미구현.

**How to apply**: `python3 make_111slab.py --bilayers 4` (기본 2×2, 진공 15 Å, 아래 2 이중층+H 고정).
하전 결함이면 `--vacuum 40`. k-point는 육방이라 **Γ-centered 필수**(MP는 육방 대칭을 깬다).
