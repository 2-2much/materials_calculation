---
name: vacuum_scan_vbm_reference_trap
description: 진공 수렴 스캔의 필수 항 — q·E_VBM(gauge)과 pure↔defect ΔV 정렬. 기준을 틀리면 오차가 2배 이상 과소평가된다. In_As_1 q+1은 13.5Å에서 +64meV 미수렴
metadata: 
  node_type: memory
  type: project
  originSessionId: 640e3ab2-68c1-49e1-b49b-8fbed2a39915
  modified: 2026-07-22T08:04:26.649Z
---

2026-07-22 `04-InCl3-passv.../__vacuum-scan_In_As_1_PBE-d__` (PBE-d, 2×2×1, optical R_q0, 진공 13.5/20/30/40/50Å).

## 함정 1 — q·E_VBM을 빼먹으면 안 된다 (내가 처음 저지른 실수)
VASP는 고유값을 **셀-평균 정전퍼텐셜** 기준으로 준다 → 진공을 늘리면 전 고유값이 통째로 이동.
실측 VBM 이동 −0.87/−0.86/−0.56/−0.39 eV인데 **gap은 0.41 eV로 불변** = 순수 gauge.
**`VBM(L) = −5.4315 + 144.855/L` 이 5점을 잔차 0.2meV로 재현**(2-파라미터) → 사실상 증명.
`E(q+1)−E(q0)+q·E_VBM`은 구성상 gauge-불변이라 상쇄는 우연이 아니라 항등식.
⚠이 항을 빼면 **수렴한 보정이 1eV/step 실패처럼 보인다**(dE_uncorr 0.30→1.27eV).

## 함정 2 — pure VBM은 pure 셀 영점에 있다 → ΔV 정렬 필수
정식: `E_f = E(D,q) − E(host) + Σnμ + q(ε_VBM^pure + ΔV_{D,host} + E_F) + E_corr`
세 기준의 결과(σ고정, 13.5Å 오차 vs L→∞):
| 기준 | 13.5Å | 50Å | L→∞ | 오차 |
|---|---|---|---|---|
| defect셀 HOMO(프록시) | 0.3389 | 0.3236 | 0.3100 | +29meV |
| pure VBM(정렬없음) | 0.2159 | 0.1816 | 0.1517 | +64meV |
| **pure VBM+ΔV(정답)** | **0.2776** | 0.2439 | **0.2135** | **+64meV** |
⚠**프록시는 오차를 절반 이하로 과소평가**한다. `VBM_pure−VBM_defcell`이 −0.1230→−0.1420(19meV 표류)이라
그 표류가 진짜 잔차를 상쇄해 가짜 plateau를 만든다. 상태별 이동량도 15~22meV 어긋남(순수 gauge 아님).

**ΔV 측정법**: 두 LOCPOT 평면평균 차, 창은 **슬랩 내부 하단**(결함 반대편, zmin+1.5~6.5Å).
결과 0.0617/0.0616/0.0608/0.0614/0.0623 = **진공무관 1.5meV** → 올바름의 지문.
⚠**진공 창은 쓰지 말 것**: 비대칭 슬랩+dipole OFF라 창 내 spread가 평균보다 큼(ill-defined).

## 결과 — 13.5Å은 부족하다
`E_f(L) = 0.2135 + 1.833/L` (잔차 ±3meV). **production 진공 13.5Å = +64meV 미수렴**, 50Å도 +30meV 잔존.
단조 수렴 −15.8→−11.7→−3.9→−2.3meV. ⏭잔차 일부는 pure 슬랩 자체 수렴일 수 있음(gap 0.5175→0.5274, 10meV) — **미분리**.
CTL 등 전하상태 *차이*에는 상당부분 상쇄되나 **절대 E_f 인용 시 주의**.

## slabcc 운용 교훈
- **E_corr는 수렴하지 않는 게 정상**(슬랩+jellium 캐패시터 항, 선형 발산 E_image→−∞). 수렴 판정에 쓰면 안 됨. 수렴해야 할 건 E_f뿐.
- E_image 음수 정당(작은 L에선 양수→큰 L에서 부호 반전).
- **σ를 고정해야 깨끗한 수렴이 나온다**. σ 자유면 목적함수가 σ에 평평해 BOBYQA가 방황(2.62→4.21→3.31 비단조). `optimize_tolerance=0.05`(production값)는 σ를 초기값1 근처에 묶어 최적화를 거의 안 함 — 해결책 아님.
- ⚠**σ가 0.96~4.21bohr로 4배 달라져도 E_f는 20meV 내 일치** = 보정은 σ에 둔감(강건성엔 好).
- jellium 기울기 공식은 **π q²/(6A)** (=0.0358eV/Å). `2π/(3A)`는 4배 틀림.

관련: [[slabcc_charge_truncation_guard]], [[charged_defect_vbm_ref]], [[in_as_1_deep_level_q_dependent]], [[cascade_parallel_settings]]
