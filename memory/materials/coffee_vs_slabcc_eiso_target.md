---
name: coffee_vs_slabcc_eiso_target
description: "slabcc와 CoFFEE의 E_isolated는 표적 환경이 다르다 — slabcc는 슬랩 두께를 함께 키워 isolated surface, CoFFEE는 두께 고정으로 isolated slab"
metadata: 
  node_type: memory
  type: project
  originSessionId: b7156945-528e-49f3-88ff-00d1d5ec26f1
  modified: 2026-08-22T07:06:25.115Z
---

**두 코드는 같은 FNV/Komsa–Pasquarello 계열이고 모델 전하 규약도 동일**하다(양쪽 다 `q/(σ√2π)³·exp(−r²/2σ²)`, σ는 bohr) → slabcc가 맞춘 σ를 CoFFEE에 환산 없이 이식 가능. E_periodic도 잘 맞는다.

**그러나 E_isolated의 정의가 다르다.** `slabcc_model.cpp:514 extrapolate()`:
- `change_size()`가 interfaces를 `L0/L_new`로 되곱해 **절대 위치**를 보존한 뒤,
- `interfaces(sorted(1)) = interfaces(sorted(0)) + slab_thickness`(분율)로 되돌려 **슬랩 두께를 셀과 함께 키운다**(주석도 "increase the slab thickness"). 전하는 가장 가까운 계면에서 같은 절대 거리로 이동.
- ⟹ α→∞ 극한에서 반대편 표면이 무한히 멀어짐 = **isolated surface** 표적.

CoFFEE는 (배포판 MoS₂ 예제 관례대로) `Width`·`Centre`를 고정하고 셀만 α×α×α로 키운다 ⟹ **isolated slab**(두 표면을 실제 두께로 유지) 표적.

**우리 계에 무엇이 맞나**: 04-InCl3 슬랩은 위 InCl₃ / 아래 pseudo-H의 **비대칭 슬랩**이고 DFT 셀이 표현하는 물리계도 그 슬랩이다 → 표적은 **isolated slab** = CoFFEE 쪽. Komsa–Pasquarello 원논문이 bulk/isolated surface/isolated slab 중 고르라고 한 바로 그 지점인데 slabcc는 surface 쪽으로 **하드코딩**되어 있다(입력으로 못 바꿈).

**정황 증거**: slabcc의 E_iso가 진공 케이스마다 0.3743→0.3523 eV로 22 meV 흘렀다 — 두께가 케이스별로 달리 커지니 표적이 케이스마다 미세하게 다른 셈. CoFFEE의 α 시리즈는 두께가 고정이라 단일 값으로 수렴해야 한다.

**★E_iso 외삽을 어디서 끊느냐 — 정량화**(2026-08-03, MoS₂ 자체 수렴 스캔 10점: α=4~80, 우리 값 α=80=0.6180이 README 0.618과 일치). 레시피를 **큰 α 3점·2차**로 고정하고 상한만 바꾸면:
`α≤10 → −103 meV / α≤20 → −78 / α≤40 → −40 / α≤60 → −13 / α≤80 → 기준(0.6675)`. **전부 한 방향(과소)** 이고 E_lat에 1:1 전달된다.
- 원인 진단자: **doubling 당 증분이 안 줄어든다**(10→20 +28.2, 20→40 +29.6, 40→80 +30.6 meV). 실제로 α=8~80 전 구간이 `E = 0.4278 + 0.0434·ln α`에 **잔차 2.1 meV**로 맞는다 — 로그는 극한이 없으므로, 다항식 절편은 "데이터 밖에서 곧 꺾인다"는 **미검증 가정**에 기대고 있다. α≤80까지 다 써도 점 선택에 따라 0.6405~0.6675로 **27 meV** 벌어진다.
- 규칙: 점 개수가 아니라 **먼 영역에 점이 여러 개** 몰려야 한다. `[40,60,80]`=기준, `[20,40,80]`=−8, 그런데 `[4,20,80]`은 α=80을 포함하고도 **−27 meV**(먼 쪽 기울기가 결정 안 됨). 작은 α 7점(`[4..20]`)은 −52.
- ⚠**우리 In_As_1 수렴 스캔은 α=8까지뿐이고 꼭대기 증분이 −24 meV/doubling으로 아직 안 줄고 있다** → 같은 편향 의심. 절대 α는 계마다 다르니 옮기지 말고 **증분 진단자**를 쓸 것. 이제 α=12·16 추가가 수 분이면 되므로(고유분해 솔버) 확인 가능. 다만 이 오차는 σ·ε·슬랩이 같은 전 케이스에 **공통 상수**라 CTL·진공수렴 판정 등 차이를 보는 곳에서는 상쇄된다.

⚠ **buggy 값 인용 금지**: 2026-07-28 이전 CoFFEE 숫자는 [[coffee_setup_and_arange_bug]]의 np.arange 버그 영향을 받을 수 있음. 관련: [[slabcc_correction]], [[dfe_p1_vacuum_asrich_fixed]], [[vacuum_scan_vbm_reference_trap]]
