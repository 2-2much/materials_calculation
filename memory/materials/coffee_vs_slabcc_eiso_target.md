---
name: coffee_vs_slabcc_eiso_target
description: "slabcc와 CoFFEE의 E_isolated는 표적 환경이 다르다 — slabcc는 슬랩 두께를 함께 키워 isolated surface, CoFFEE는 두께 고정으로 isolated slab"
metadata: 
  node_type: memory
  type: project
  originSessionId: b7156945-528e-49f3-88ff-00d1d5ec26f1
  modified: 2026-07-28T09:12:35.160Z
---

**두 코드는 같은 FNV/Komsa–Pasquarello 계열이고 모델 전하 규약도 동일**하다(양쪽 다 `q/(σ√2π)³·exp(−r²/2σ²)`, σ는 bohr) → slabcc가 맞춘 σ를 CoFFEE에 환산 없이 이식 가능. E_periodic도 잘 맞는다.

**그러나 E_isolated의 정의가 다르다.** `slabcc_model.cpp:514 extrapolate()`:
- `change_size()`가 interfaces를 `L0/L_new`로 되곱해 **절대 위치**를 보존한 뒤,
- `interfaces(sorted(1)) = interfaces(sorted(0)) + slab_thickness`(분율)로 되돌려 **슬랩 두께를 셀과 함께 키운다**(주석도 "increase the slab thickness"). 전하는 가장 가까운 계면에서 같은 절대 거리로 이동.
- ⟹ α→∞ 극한에서 반대편 표면이 무한히 멀어짐 = **isolated surface** 표적.

CoFFEE는 (배포판 MoS₂ 예제 관례대로) `Width`·`Centre`를 고정하고 셀만 α×α×α로 키운다 ⟹ **isolated slab**(두 표면을 실제 두께로 유지) 표적.

**우리 계에 무엇이 맞나**: 04-InCl3 슬랩은 위 InCl₃ / 아래 pseudo-H의 **비대칭 슬랩**이고 DFT 셀이 표현하는 물리계도 그 슬랩이다 → 표적은 **isolated slab** = CoFFEE 쪽. Komsa–Pasquarello 원논문이 bulk/isolated surface/isolated slab 중 고르라고 한 바로 그 지점인데 slabcc는 surface 쪽으로 **하드코딩**되어 있다(입력으로 못 바꿈).

**정황 증거**: slabcc의 E_iso가 진공 케이스마다 0.3743→0.3523 eV로 22 meV 흘렀다 — 두께가 케이스별로 달리 커지니 표적이 케이스마다 미세하게 다른 셈. CoFFEE의 α 시리즈는 두께가 고정이라 단일 값으로 수렴해야 한다.

⚠ **buggy 값 인용 금지**: 2026-07-28 이전 CoFFEE 숫자는 [[coffee_setup_and_arange_bug]]의 np.arange 버그 영향을 받을 수 있음. 관련: [[slabcc_correction]], [[dfe_p1_vacuum_asrich_fixed]], [[vacuum_scan_vbm_reference_trap]]
