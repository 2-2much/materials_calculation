---
name: scpc-vacuum-scan
description: "SCPC vacuum convergence test: Cl-As_In q+1, c=35/45/55 Å, PREC=A LREAL=F BROAD=0.50, 2026-06-25 submit"
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

### 완료 상태 (2026-06-26 기준)
- **q0, q+1_pre**: 6개 모두 수렴 완료
- **q+1 SCPC**: vac_20A, vac_30A 완료 / vac_40A 진행중 (job 52416)

### E_corr 중간 결과
| Vacuum | E_corr | Potential Alignment | 수렴 |
|--------|--------|-------------------|------|
| 20 Å (c=35) | 2.4627 eV | -0.0433 eV | ✓ (43 cycles, 완전 고정) |
| 30 Å (c=45) | 2.1615 eV | -0.0457 eV | ✓ (44 cycles, 완전 고정) |
| 40 Å (c=55) | — | — | 진행중 |

20→30 Å 사이 E_corr 0.30 eV 감소 → vacuum이 커지면 이미지 전하 간 거리 증가로 E_corr 감소하는 것은 당연. README 기준(< 0.05 eV)은 E_corr 자체가 아니라 **E_tot(q)+E_corr** (보정 후 formation energy)로 판단해야 함.

### 올바른 수렴 판단 기준
- E_corr 자체가 vacuum에 따라 달라지는 건 정상 (셀 크기 변화)
- **E_tot(q, vac) + E_corr(q, vac)** 가 vacuum 독립적으로 수렴하는지 확인
- 40 Å 완료 후 formation energy 비교 필요

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
- SCPCOUT E_corr: 마지막 5-10 cycle 변동 < 0.01 eV
- Vacuum convergence: E_corr 3개 비교, 차이 < 0.05 eV이면 수렴
- z-diel.dat: slab ε≈15.15, vacuum ε≈1

**Why:** 이전 SCPC 테스트에서 vacuum 부족(11.2 Å)과 PREC/LREAL 설정 문제로 E_corr 미수렴. vacuum scan으로 수렴된 correction 값 확보 목적.
**How to apply:** SCPC 결과 확인 후, 수렴된 E_corr를 charged defect formation energy에 적용. [[scpc-debug]]
