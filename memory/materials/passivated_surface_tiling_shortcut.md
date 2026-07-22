---
name: passivated_surface_tiling_shortcut
description: "패시베이션된 청정 표면의 이완 기하는 lateral 타일링으로 정확히 전용 가능 — 큰 셀 pristine relax를 건너뛰어 98% node-hour 절약. 검증 RMS 0.003Å, k-mesh 접힘이 엄밀성 근거"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 9576900b-ea8f-420e-9daf-cd578b563a18
  modified: 2026-07-22T12:00:43.675Z
---

## 주장
**완전 패시베이션된 청정 표면**의 이완 기하는 작은 lateral 셀에서 한 번만 구하고 **옆으로 타일링**하면 큰 셀의 참 최소점을 정확히 준다. 큰 셀 pristine relax는 같은 해를 비싸게 재계산하는 것일 뿐.
도구: `slabcc_Si-DB/tile_relaxed.py`, `run_case.sh <case> <seed>`.

## 엄밀성 근거 2개
1. **buckling = 0.** 완전 monohydride면 dangling bond가 전부 채워져 Jahn-Teller형 buckling 구동력이 사라짐 → 대칭 dimer, 엄격한 2×1 주기. 실측: 셀 내 두 dimer의 결합길이·z·Si-H 길이·각도가 **기계 정밀도(1e-15 Å)까지 동일**, buckling 정확히 0. (청정 Si(001)의 c(4×2)/p(2×2)는 **passivation 안 된 표면** 얘기라 무관. 3×1은 dihydride 상이라 무관.)
2. **k-mesh 접힘이 정확히 등가.** 2×2셀 Γ 6×6×1(기약 16점) = 4×4셀 3×3×1(4점×접힘4) = 6×6셀 2×2×1(4점×접힘9). 큰 셀 문제를 병진대칭 부분공간으로 제한하면 작은 셀 문제와 **문자 그대로 동일**. → 근사가 아니라 엄밀.

## 정량 검증 (Si(001)-(2×1):H, 독립 이완한 4×4를 대조군으로)
이완된 2×2(vac_2_2_2) ×(2,2) 타일 vs 독립 수렴한 4×4(alpha2):
| | RMS | MAX |
|---|---|---|
| 전체 176원자 | **0.0029 Å** | 0.0070 Å |
| Si 부분격자 144 | **0.0002 Å** | 0.0005 Å |
| (참고) 이완 자체 진폭 | 0.0899 Å | 0.157 Å |
→ 차이는 이완 진폭의 **3%**, 잔차는 거의 전부 H(가장 무른 자유도). 두 구조는 같은 EDIFFG=−0.02 분지 안의 구분 불가능한 점.

## 전제 조건 (하나라도 어기면 무효)
- **슬랩 두께·진공·c가 정확히 일치**해야 함. 두께가 다르면 실제로 어긋남(5층 dimer 2.4462 vs 9층 2.4482 Å, 0.002Å). → 이완은 **두께 종류 수만큼만** 수행.
- lateral이 정수배일 것. 양면 dimer 수직성은 면내 복제가 적층을 안 건드리므로 자동 보존.
- 검증은 **공짜**: 어차피 돌리는 pristine static의 `TOTAL-FORCE`에서 자유원자 max|F| < EDIFFG인지만 확인.

## ⚠결함 이완에는 적용 불가
결함은 원자를 빼는 순간 병진대칭을 깨므로 타일링 논거가 **전혀** 적용되지 않는다. 게다가 DB Si 변위가 셀 의존적: 2×2/5층 **0.2227Å** vs 2×2/9층 **0.1918Å** (14% 차이). 유효 강성 ~4 eV/Å²이라 0.03Å 오차 = 잔여력 0.12 eV/Å ≫ 0.02 → static으로 못 때움.
**씨앗(seed)으로만** 쓰고 반드시 EDIFFG까지 재이완할 것. 이온스텝은 7~8 → 3~4로 줄어듦.

## 절약 실적 (540원자 Si 슬랩)
| | 현행 | 타일링 |
|---|---|---|
| pristine relax | ~20 h wall / ~200 node-h (73.5분/이온스텝 ×10노드) | 2~3 h / ~3 node-h (60원자 seed 1노드) |
→ **wall 17~18h, node-hour 98% 절약.**

InAs 슬랩(Cl/InCl3 passivation)에도 같은 논리가 적용 가능 — 단 passivation이 불완전하거나 표면 재구성이 2×1보다 큰 주기를 가지면 전제가 깨지므로 buckling·dimer 동등성부터 실측할 것.

관련: [[si_db_kp_reproduction]], [[g1_node_vasp_binary_limit]]
