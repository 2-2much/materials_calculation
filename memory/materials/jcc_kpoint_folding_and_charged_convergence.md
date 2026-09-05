---
name: jcc_kpoint_folding_and_charged_convergence
description: "★hBN 6×6 Γ-only는 primitive K를 0.2meV로 재현(접힘 확정). 그러나 하전 셀 총에너지는 k에 훨씬 민감 — Γ-only→2×2×1에서 δE₀가 22.5meV 이동(고윳값은 0.3meV). ⚠PROCAR 다중k 파싱 버그"
metadata:
  type: project
---

2026-09-05. `~/materials/__JCC_Reproduction__/01c-primitive_reference`, `01d-supercell_kmesh`

## ★접힘 규칙 (외워둘 것)
primitive k가 n×n 초셀 Γ로 접히려면 **k = (m/n)b₁+(m/n)b₂**. hBN의 K=(1/3,1/3)이므로
**m = n/3 → n이 3의 배수일 때만**. 6·9·12·18 ✅ / 4·5·8·16 ✗.
⚠ `KSPACING`으로 메시를 만들면 3의 배수가 안 나올 수 있다 — 00-lattice_a가 16×16이 되어
**K를 놓쳤고**(i=5.33) 그래서 "primitive VBM"이 초셀 Γ보다 60 meV 낮게 나왔다.

## 접힘은 정확하다 — Γ-only 고윳값 우려 해소
primitive 18×18(K 포함) vs 초셀 6×6 Γ-only: **ε_VBM 0.2 meV, ε_π* 0.1 meV 차이.**
Γ-only 초셀의 고윳값은 그 k에서 **정확한** 고윳값이고, SCF 밀도 오차도 고윳값에는 0.3 meV뿐.

## ★38 meV 준축퇴의 정체 (억셉터 문제의 뿌리)
primitive에서 **π* 최소는 K**(−0.2771), **NFE(interlayer) 최소는 Γ**(−0.2390),
K에서 NFE는 +7.40 eV로 한참 위. 6×6에서 **둘 다 Γ로 접혀 만나** 간격이 38.1 meV가 된다.
→ 초셀 아티팩트가 아니라 hBN 단일층+30Å 진공의 실제 물리. [[jcc_acceptor_vacuum_ghost_state]]

## ★★하전 셀 총에너지는 k에 훨씬 민감하다
Γ-only → 2×2×1 (=primitive 12×12, 둘 다 K 포함):
| | Γ-only | 2×2×1 | 차이 |
|---|---|---|---|
| ε_VBM / ε_π* | −4.9317 / −0.2770 | −4.9314 / −0.2769 | **0.3 / 0.1 meV** |
| E(N₀) | −633.4397 | −633.4418 | 2.1 meV |
| **δE₀(+1)** | −0.8940 | **−0.9165** | **22.5 meV** |
- 고윳값·중성에너지는 안 움직이는데 δE₀만 22.5 meV → **E(N₀−1)이 ~20 meV 변한 것**.
  하전 셀엔 분수점유 정공이 있어 k 분포에 직접 의존하기 때문.
- **두 종류의 k 의존성을 구분할 것**: k *위치*(01b, Γ→특수점) → δE₀ 8 meV.
  k *개수*(01d) → **22.5 meV**. 나는 전자만 재고 "k에 둔감"이라 말했는데 후자는 아니었다.
- 논문 −0.943 과의 49 meV 중 **절반이 이것으로 설명**된다(남은 26 meV = PAW vs NC 등).
  논문이 "single k-point"라 했으므로 **재현에는 Γ-only가 맞고**, 물리 정확도로는 메시가 낫다.
- ⚠**실무**: δE₀/형성에너지를 뽑을 때 **하전·중성 호스트를 같은 메시로** 계산할 것.
  02/04/05는 전부 Γ-only 단일 발판이라 내부 일관성 OK, 22.5 meV는 공통 오프셋이라
  **기울기(핵심 결과)에는 무영향**. 절대값 −0.894는 "Γ-only 값"이라 명시할 것.

## ⚠도구 버그 (2026-09-05 수정)
`jcc_tools.procar_weight`가 k점을 추적하지 않아 **마지막 k점 값만** 남기고,
`eigenval`은 **첫 k점만** 읽어 서로 다른 k를 섞었다. 단일 k 트리(01~05)는 무해했으나
01d에서 ε_NFE를 +0.52 eV, margin을 793 meV로 만들어 "억셉터가 살아났다"는 **오판을 냈다**.
(band 147: k=1에서 0.042(진공), k=2~4에서 0.532(시트))
→ `eigenval_all` / `procar_weight_all` 로 k-분해. `analyse()`는 **전 k점에서** 밴드끝을 찾고
전하 밴드는 (k,band) 쌍의 |Δocc| 최대로 식별. 단일 k 결과 불변 회귀 확인 완료.

관련: [[jcc_dHf_lz_validation]], [[jcc_acceptor_vacuum_ghost_state]], [[chgdiff_kpt_scan]]
