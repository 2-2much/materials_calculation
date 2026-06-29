---
name: scpc-vacuum-scan
description: "SCPC Table II 재현 — vacuum 두께별 Cl-As_In (+1) formation energy 계산, VBM 추출 방법 정리"
metadata: 
  node_type: memory
  type: project
  originSessionId: 304c91bf-6cb3-4649-917f-986064730ef5
---

## SCPC vacuum scan 프로젝트 (2026-06-26)

SCPC 논문 (Deák 2021, PRL 126, 076401) Table II / Fig.S8 재현 목표.
Vacuum 두께별 Cl-As_In (+1) defect formation energy를 구하고, 이후 CKT 논문 Fig.8처럼 VBM & DFE vs vacuum 그래프 작성.

**Why:** SCPC correction의 vacuum convergence 검증. Bare (uncorrected)는 발산, SCPC는 수렴하는 패턴 확인.

**How to apply:** 아래 공식과 계산 현황을 기반으로 데이터 추출 및 플로팅 진행.

### Formation energy 공식 (SCPC-1 SC)

$$E_f = E_{tot}^{SCPC}[q+1] - E_{tot}[pristine] + \Delta\mu + 1 \cdot \varepsilon_{VBM}^{pristine}$$

- **E_tot[pristine]**: defect 없는 순수 slab의 total energy (각 vacuum별 필요)
- **ε_VBM**: **pristine slab의 EIGENVAL에서 추출** (각 vacuum 두께별로 다름)
- **Δμ**: chemical potential (CLAUDE.md 참조: μ_As, μ_In, μ_InAs)
- **E_corr = 0**: SCPC SC에서는 이미 total energy에 포함
- **주의**: SCPC-1의 "reference"는 δρ 계산용(REFCHG=q0)이지, DFE 공식의 reference가 아님

### VBM 관련 핵심 정리

- q0 VBM ≈ pristine VBM ≈ SCPC q+1 VBM (세 개 거의 같음, 큰 supercell에서)
- bare q+1 VBM만 jellium 때문에 shift됨 → 이것만 다름
- **DFE 공식에서는 항상 pristine VBM 사용** (SCPC-1이든 SCPC-2든 무관)
- SCPC-1/2 구분은 δρ 계산용 REFCHG 차이일 뿐, DFE reference는 항상 pristine

### 계산 현황

디렉토리: `~/materials/33-inAs/__Functional_Validation__/12-Surace-defect_calculation/01-Cl-passv_6L_3x2x1/calc/Cl-As_In/__SCPC-test__/`

| Vacuum | q0 E_tot (eV) | q+1 SCPC E_tot (eV) | 상태 |
|--------|--------------|-------------------|------|
| 20 Å | -346.631 | -341.602 | ✅ 완료 |
| 30 Å | -346.621 | -340.675 | ✅ 완료 |
| 40 Å | -346.613 | -340.081 | ✅ 완료 |

E-fermi (q0): 20Å=-1.5193, 30Å=-2.4053, 40Å=-2.9701 (absolute값은 vacuum에 따라 shift)

### Pristine slab 결과 (각 vacuum별)

| Vacuum | E_tot (eV) | VBM (eV) | CBM (eV) | Gap (eV) |
|--------|-----------|----------|----------|----------|
| 20 Å | -343.573 | -1.8605 | -1.6381 | 0.2224 |
| 30 Å | -343.553 | -2.7548 | -2.5410 | 0.2138 |
| 40 Å | -343.541 | -3.3244 | -3.1151 | 0.2093 |

### Bare q+1 (q+1_pre) 결과

| Vacuum | E_tot (eV) |
|--------|-----------|
| 20 Å | -344.686 |
| 30 Å | -343.477 |
| 40 Å | -342.542 |

### Formation Energy 결과 (E_f at VBM)

공식: E_f = E_tot[q+1] − E_tot[pristine] + Δμ + q·VBM(pristine)
Δμ = +μ_In − μ_As − μ_Cl, μ_Cl = E(Cl₂)/2 = -1.7852 eV

| Vacuum | VBM | DEFAULT In-rich | SCPC-1 In-rich | DEFAULT As-rich | SCPC-1 As-rich | E_corr |
|--------|------|----------------|---------------|----------------|---------------|--------|
| 20 Å | -1.8605 | 1.40 | 4.49 | 0.43 | 3.52 | 2.46 |
| 30 Å | -2.7548 | 1.70 | 4.50 | 0.73 | 3.53 | 2.16 |
| 40 Å | -3.3244 | 2.05 | 4.51 | 1.08 | 3.54 | 1.81 |

DEFAULT: vacuum 증가 시 ~0.65 eV 발산. SCPC-1 SC: ~0.03 eV 차이로 수렴.
SCPC 논문 Fig.S8 패턴과 일치하나, E_corr가 Madelung 추정 대비 ~5배 큼.

### Bare (uncorrected) 비교

Bare q+1 = q+1_pre 결과 사용 (SCPC OFF).
DEFAULT column 재현: E_f가 vacuum 커질수록 발산.

### 관련 논문 참조

- SCPC 본문: Table I (bulk diamond), Table II (NaCl slab surface)
- SCPC Supplementary: Fig.S8 (vacuum convergence 그래프), Table S4-S6
- 비교 노트: `~/papers/charged defect correction in slab/comparison_notes.md`

### CKT 계산

현재는 하지 않기로 결정. SCPC vs bare만 비교.

### 필요한 추가 계산

각 vacuum 두께 (20/30/40 Å)에 대해 **pristine (pure) slab 1shot 계산** 필요.
기존 pure slab은 ~11.2 Å vacuum에서만 존재: `calc/pure/q0/01_Relax/` (E_tot=-343.587 eV, E-fermi=-0.4034)

### 발견된 문제점 (2026-06-26)

1. **ZLOW/ZHIG 파라미터 오류**: vac_30A, vac_40A에서 ZLOW/ZHIG가 vac_20A 값 (0.2419/0.7581)으로 고정되어 있음. Vacuum이 커지면 slab의 fractional 위치가 바뀌므로 각 vacuum별로 재설정 필요:
   - vac_20A: 0.2421/0.7579 (현재 OK)
   - vac_30A: 0.2994/0.7006 (수정 필요)
   - vac_40A: 0.3359/0.6641 (수정 필요)

2. **E_corr가 비정상적으로 큼**: vac_20A (ZLOW/ZHIG 맞음)에서도 E_corr=2.46 eV. q=+1에 대해 Madelung 추정 ~0.5 eV 대비 5배 큼. 가능한 원인:
   - BROAD=0.50 → 논문 NaCl은 0.1 사용. 너무 큰 BROAD가 dielectric profile을 왜곡?
   - DIEL=15.15 (ε_0) → SCPC가 ε_∞=11.0을 원하는지 확인 필요
   - QTOT 부호 convention 확인 필요

3. **Chemical potential 부호**: Δμ = +μ_In - μ_As - μ_Cl (처음에 부호 반대로 적용했다가 수정)

4. **Charge spill 없음**: VESTA isosurface 확인 결과 charge 변화가 표면 상부 ~3층에 집중. Vacuum으로의 spill 없음.

### 다음 단계

- **SLABCC (slab용 Komsa-Pasquarello FN) a posteriori correction 먼저 적용**: vac_20A bare q+1에 SLABCC 돌려서 E_corr 산출 → SCPC E_corr (2.46 eV)와 비교하여 sanity check. SLABCC 바이너리: `~/bin/slabcc/bin/slabcc`. 주의: Falletta 스크립트는 3D bulk용이라 slab에 적용 불가.
- 참고 논문: Freysoldt & Neugebauer PRB 97, 205425 (2018), SLABCC 구현
- SCPC 파라미터 (BROAD, DIEL) 재검토 후 재계산
- vac_30A, vac_40A q+1 SCPC ZLOW/ZHIG 수정 후 재계산
- 보고서 PDF: `__SCPC-test__/SCPC_vacuum_scan_report.pdf` (vac_40A 추가 전 버전)
- 플롯: `__SCPC-test__/vacuum_scan_Ef.png` (3개 vacuum 포함)
- CHGCAR diff: `__SCPC-test__/vac_20A/_chgcar_diff_/` (bare/SCPC minus q0)
