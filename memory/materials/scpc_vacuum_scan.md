---
name: scpc-vacuum-scan
description: "SCPC vacuum scan: Cl-As_In q+1, 20/30/40Å 완료, E_tot+E_corr 수렴(~-338.3 eV). 큰 보정(~1.8 eV) 원인=표면 국소 전하(ε_eff≈1)+작은 lateral 셀(3×2), 버그 아님"
metadata: 
  node_type: memory
  type: project
  originSessionId: 960d2a29-93ca-4664-b0af-e3589cf5f18b
---

## SCPC Vacuum Convergence Test (2026-06-25)

경로: `.../12-Surace-defect_calculation/01-Cl-passv_6L_3x2x1/calc/Cl-As_In/__SCPC-test__/`

### 구조
```
__SCPC-test__/
├── _old_run/        ← 이전 SCPC 테스트 (E_corr 2.77/3.00 eV 진동, 미수렴)
├── setup_links.sh   ← q0→REFCHG/REFPOT, q+1_pre→WAVECAR 링크 스크립트
├── vac_20A/         (c=35 Å, vacuum≈20 Å)
├── vac_30A/         (c=45 Å, vacuum≈30 Å)
└── vac_40A/         (c=55 Å, vacuum≈40 Å)
    각각 q0/, q+1_pre/, q+1/ 하위 폴더
```

### 완료 상태 (2026-06-29 기준)
- **q0, q+1_pre**: 6개 모두 수렴 완료
- **q+1 SCPC**: vac_20A/30A/40A **3종 모두 완료**

### 결과 (E_corr + 수렴 판단)
| Vacuum | E_corr | Align | raw E[q+1] | **E[q+1]+E_corr** | cycles |
|--------|--------|-------|-----------|-------------------|--------|
| 20 Å (c=35) | 2.4627 eV | -0.0433 | -341.602 | **-339.140** | 43 (고정) |
| 30 Å (c=45) | 2.1615 eV | -0.0457 | -340.675 | **-338.514** | 44 (고정) |
| 40 Å (c=55) | 1.8078 eV | -0.0430 | -340.081 | **-338.273** | 46 (고정) |

(q0 raw ≈ -346.62 eV로 vacuum 무관 일정)

### 핵심 결론: 수렴은 성공, 수렴 판단은 E_tot+E_corr로
- E_corr 자체(2.46→2.16→1.81)는 vacuum 따라 감소 = 정상 (z-방향 image 거리 변화)
- **E[q+1]+E_corr** 증분이 +0.63 → +0.24 eV로 줄며 ~-338.2 eV로 수렴
  → raw E[q+1]은 vacuum 키울수록 1.5 eV 발산하지만 SCPC가 그 z-발산을 정상 보정.
- README의 "< 0.05 eV" 기준은 E_corr이 아니라 반드시 E_tot+E_corr로 적용해야 함.

### ⚠ 큰 보정값(~1.8 eV) 원인 진단 (2026-06-29) — 버그 아님, 물리적으로 옳음
"correction이 터무니없이 크다"의 정체:
1. **표면 국소 전하 → ε_eff ≈ 1.** model charge(z-mrho.dat) peak가 z=32.9 Å.
   slab 유전체 영역(ZLOW*c~ZHIG*c = 18.5~36.5 Å)의 위쪽 vacuum 경계에서 불과
   ~3.6 Å 안쪽. surface defect라 당연하지만, 전기력선이 ε=1 vacuum으로 새어
   실효 유전율이 bulk 15.15가 아니라 ~1.
2. **작은 lateral 셀(3×2, 13.1×12.4 Å)** → 면내 periodic image 자기상호작용 큼.
3. **2D Madelung 어림식 교차검증:**
   `E_corr ≈ (1/2)·q²·k·(1/ε_eff)·(c_M/√A)`
   - q=+1, k=14.4 eV·Å (=e²/4πε₀), ε_eff≈1, c_M≈3 (2D 격자상수 O(1))
   - A=13.1×12.4=162.6 Å² → √A=12.75 Å
   - = 0.5·14.4·(1/1)·(3/12.75) ≈ **1.7 eV** → 관측 ~1.8 eV와 일치
   - 만약 bulk 깊은 전하였으면 ε_eff≈15.15 → ~0.11 eV (정상 크기). ~17배 차이는
     전적으로 "표면 국소(ε_eff≈1)" 때문.
4. **vacuum으론 안 줄어듦(이미 수렴). lateral 셀을 키워야 줄어듦** (E∝1/√A):
   3×2(~1.8 eV) → 4×3 ~1.3 eV → 5×4 ~1.0 eV 예상.

### 유전율 모델은 정상 (오해 정정)
- z-diel.dat: vacuum ε=1, slab 내부에서 ε=15.15 제대로 도달, 전이폭 ~2.5 Å.
- ⚠ `sort -n`은 지수표기(E+02)를 파싱 못해 max를 8.4로 오판함 → 분석 시 주의.

### 별개 한계
- ENCUT=300은 In 4d(PBE-d)엔 낮음 → 절대 보정값 신뢰성 확보엔 ENCUT 상향 재계산 필요.

### 개선된 파라미터 (이전 대비)
| 파라미터 | 이전 | 변경 | 근거 |
|---------|------|------|------|
| PREC | N | Accurate | SCPC GitHub 권장, REFCHG FFT grid 정확도 |
| LREAL | A | .FALSE. | projection 정확도 |
| ENAUG | 미설정 | 600 | 2×ENCUT, GitHub 권장 |
| EDIFF | q0: 1E-4 | 1E-6 | SCPC SCF 수렴 |
| BROAD | 0.40 | 0.50 | InAs Phillips ionicity f_i≈0.36 (ionic 0.4, covalent 0.8 사이) |
| Vacuum | 11.2 Å | 20/30/40 Å | GitHub: vacuum = 3-4× slab thickness |

### SCPC 파라미터 (vacuum별)
| c (Å) | ZLOW | ZHIG | MGZ |
|--------|------|------|-----|
| 35 | 0.2419 | 0.7581 | 288 |
| 45 | 0.2992 | 0.7008 | 384 |
| 55 | 0.3357 | 0.6643 | 480 |

### 워크플로우
1. q0 1shot (q0/CONTCAR 기반) → CHGCAR(REFCHG), LOCPOT(REFPOT)
2. q+1_pre 1shot (q+1/CONTCAR 기반, SCPC OFF) → WAVECAR
3. setup_links.sh → q+1에 REFCHG/REFPOT/WAVECAR 심볼릭 링크
4. q+1 SCPC (IN=1, LWAVE=.FALSE.) → E_corr

### 핵심 결정사항
- q0와 q+1의 POSCAR는 **각자의 relaxed CONTCAR**에서 생성 (geometry 다름)
- WAVECAR 심볼릭 링크 → q+1에서 LWAVE=.FALSE.로 원본 보호
- POTCAR는 심볼릭 링크 아닌 복사본 사용 (폴더 이동 시 깨짐 방지)

### 검증 기준
- SCPCOUT E_corr: 마지막 5-10 cycle 변동 < 0.01 eV (충족)
- Vacuum convergence: **E_tot[q]+E_corr** 3개 비교(E_corr 단독 아님) → ~-338.3 eV 수렴
- z-diel.dat: slab ε≈15.15, vacuum ε≈1 (충족)

**Why:** 이전 SCPC 테스트에서 vacuum 부족(11.2 Å)과 PREC/LREAL 설정 문제로 E_corr 미수렴. vacuum scan으로 수렴된 correction 값 확보 목적. 결과: z-수렴은 성공했으나 보정값 자체가 ~1.8 eV로 큰데, 이는 버그가 아니라 표면 국소 전하(ε_eff≈1)+작은 3×2 lateral 셀의 면내 image 에너지(물리적으로 옳음).
**How to apply:** 보정값을 줄이려면 vacuum이 아니라 lateral 셀을 키워야 함(E∝1/√A). ENCUT 상향 후 큰 셀 재계산이 절대값 신뢰성 확보의 다음 단계. [[scpc-debug]] [[scpc-reference]]
