---
name: jcc_tableII_reproduction
description: "JCC(Zhang2023) Table II 전 재료 δE0 재현 — BN −1 빼면 13행 RMS 41 meV. ★논문의 GeS/BN만 ±q가 비트 동일 → q² 대칭으로 적어 넣은 정황"
metadata:
  type: project
---

2026-09-15. 트리 `~/materials/__JCC_Reproduction__/12-TableII_materials` (**kohn에서 실행**,
tgm-master 사본에는 00-relax 와 도구만 있다). 호스트 셀만 필요 — 결함 셀 없음.

## 셀 설정은 논문 원문과 전부 일치 (zhang2023 본문에서 재확인)
WSe2 Lz=30 6×6 / GeS·black phosphorene·black arsenene Lz=20 6×6 / BN Lz=30 6×6 /
(3,3) BNNT **Lx=Ly=25, alatt=9**.  → 잔차는 기하 탓이 아니다.

## 재현 품질 (16행: WSe2 ±1±2, phos ±1, arse ±1, GeS ±1±2, BNNT ±1, BN ±1)
| 대상 | 행 | 평균 차 | RMS | 최대 |
|---|---|---|---|---|
| BN −1 제외 | 15 | +43 meV | 72 meV | 210 meV |
| GeS ±2 까지 제외 | 13 | +25 meV | **41 meV** | 65 meV |

절대오차가 전 재료 0~65 meV로 **평평**하다 — 재료·q 의존 구조가 없다.
BN 도너의 49 meV(기울기 3.2%로 이미 규명)와 같은 노이즈 바닥. 남은 후보 = QE+NC 70Ry vs VASP+PAW 400eV.

## ★논문 Table II 의 ±q 대칭성 — "논문이 적어 넣었다" 가설의 정황 증거
논문 값의 ±q 차: WSe2 4.0/10.0 · phosphorene 16.0 · arsenene 1.0 · BNNT 24.0 meV
**그런데 GeS 0.0, BN 0.0 meV (비트 동일)**. GeS 는 |q|=1,2 둘 다 0.0 이고 0.557/0.140 = 3.979 ≈ 4.
→ **논문이 GeS·BN 의 −q(그리고 GeS 의 q=2)를 따로 계산하지 않고 δE0 ∝ q² 에서 환산해 적었을 가능성.**
   = [[jcc_acceptor_vacuum_ghost_state]] 2026-09-09 절의 후보 (a). ⚠정황이지 증명 아님.
우리 실측 비는 GeS 4.50/4.44, WSe2 4.19(논문도 4.07 실측) → **δE0/q² 는 정확한 상수가 아니다.**
우리 GeS ±2 는 논문에 없는 정보다.

## How to apply
- **판정 문턱 함정**: analyze.py 의 재현/어긋남이 절대 0.1 eV 고정이라 |q|=2 행에 불리하다.
  GeS 는 상대오차로 보면 ±2(20/38%)가 ±1(30/44%)보다 **오히려 낫다** — "GeS ±2 어긋남"은 문턱 아티팩트.
  2026-09-15 에 상대오차 열을 추가했다.
- **그림 버그 수정**: `pal` 6번째가 BN 고정색(#d03b3b)과 같아 재료 6개일 때 phosphorene 이 BN 과
  같은 빨강이 됐다. BN 은 pal 을 소비하지 않도록 바꿨다.
- δE0 를 새 재료에 쓸 때는 **게이트 w(frontier 밴드 ion 투영 합)를 반드시 같이 본다** — 아래 참조.

관련: [[jcc_acceptor_vacuum_ghost_state]], [[jcc_dE0_charge_symmetry]], [[jcc_dE0_koopmans_janak]]
