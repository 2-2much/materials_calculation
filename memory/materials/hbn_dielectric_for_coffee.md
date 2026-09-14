---
name: hbn_dielectric_for_coffee
description: "h-BN 단층의 CoFFEE용 유전율 — 셀평균(Kumagai)을 슬랩내부로 되돌리는 환산과 그 3중 역검증"
metadata:
  node_type: memory
  type: reference
---

⚠⚠ **2026-09-14 중요 정정 — 단층에는 `Slab` 프로파일을 쓰면 안 된다.**
CoFFEE User Guide §4-3 이 "두께를 정의하기 애매한 그래핀·**단층 BN**용" 으로 `Gaussian`
프로파일을 따로 둔다. 아래 Slab 환산은 **MoS2 처럼 두께가 정의되는 계**에만 유효하다.
실측: Slab 으로 w=2.5/3.33/5.0 A (적분량 보존) -> E_lat 대용이 +0.005/+0.020/+0.062 eV 로
갈린다. 모델 전하 sigma(1 A)가 슬랩 두께와 비슷해 '두께는 게이지' 논리가 깨지기 때문.
단층 h-BN 용 Gaussian 진폭은 [[jcc_coffee_correction_tree]] 에 있다 (A_par 9.4768 /
A_perp 3.1428, sigma_eps 0.783 A).

**문제**: CoFFEE 의 2D 슬랩 모델은 **슬랩 내부** ε∥·ε⊥ 와 Width 를 요구한다. 그런데 DFPT/논문이
주는 값은 대개 **셀 평균**이다. 그대로 넣으면 안 된다.

**환산** (슬랩 폭 w, 셀 높이 L, 진공 ε=1):
- ∥ (병렬 축전기): `ε∥_ave = 1 + (w/L)(ε∥_slab − 1)`
- ⊥ (직렬 축전기): `1/ε⊥_ave = 1 + (w/L)(1/ε⊥_slab − 1)`

**w 규약**: CoFFEE 배포 MoS₂ 예제가 `Width = 11.40454 bohr = 6.035 Å` = **벌크 층간거리**를 쓴다.
같은 규약으로 h-BN 은 `w = 3.33 Å`(벌크 h-BN c/2).

**★3중 역검증 (2026-09-13)** — 이 환산이 옳다는 독립 근거:
| 대상 | 환산 결과 | 독립 기준 | 일치 |
|---|---|---|---|
| MoS₂ ε∥ | 15.1 | CoFFEE 예제 `Epsilon1_a1 = 15.0` | ✓ |
| MoS₂ ε⊥ | 6.29 | 벌크 2H-MoS₂ ε∞⊥ ≈ 6.2 | ✓ |
| h-BN ε∞∥ | 4.84 | 벌크 h-BN ε∞∥ = 4.95 | ✓ 2% |
(MoS₂ 셀평균은 Kumagai Table I: ε∞∥_ave 5.19, ε∞⊥_ave 1.34, ε0∥_ave 5.26)

⚠ CoFFEE 배포 MoS₂ 예제의 `Epsilon1_a3 = 2.0`(⊥)은 위 환산값 6.29 와 **안 맞는다**. ∥ 은 맞는데
⊥ 만 안 맞으므로 예제 쪽 값의 출처가 다르다고 보는 게 맞다 — 예제를 ⊥ 규약의 근거로 삼지 말 것.

**h-BN 단층 값** (출처 = Kumagai, PRB 109, 054106 (2024) Table I, Lz=20 Å 슬랩 셀평균
ε∞∥ 1.64 / ε∞⊥ 1.12 / ε_ion∥ 0.29 / ε_ion⊥ 0.01 / ε0∥ 1.93 / ε0⊥ 1.12):
- **ε∥_slab = 6.59** (정적, 이온 포함) · **4.84** (ion-clamped)
- **ε⊥_slab = 2.81** (이온 기여 0.01 이라 정적·clamped 동일)
- Width = 3.33 Å = 6.293 bohr

⚠ **Zhang(JCC) 논문은 h-BN 유전율을 주지 않는다.** 본문이 "the difficulty in defining ε⊥" 라고
명시하며, JCC 의 장점 자체가 ε 를 요구하지 않는 것이다. "논문 값"을 JCC 에서 찾지 말 것.

⚠ Kumagai 는 h-BN 에 **가우시안형** ε(z) 프로파일(σ_ε = 0.783 Å)을 쓴다. CoFFEE 의 슬랩 모델은
**erf 계단형**이라 함수형이 다르다. 폭·평활도를 옮길 때 주의.

관련: [[coffee_setup_and_arange_bug]], [[coffee_vs_slabcc_eiso_target]], [[jcc_dHf_lz_validation]]
