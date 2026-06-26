---
name: cl2-hse06-calc
description: "Cl2 분자 HSE06 이완 계산 (12-HSE06-Gamma), AEXX=0.27, LHFSKIP, VASP 6.5.1, 2026-06-26 submit"
metadata: 
  node_type: memory
  type: project
  originSessionId: 812cd4f3-de52-4c7a-9645-51849dcce7e5
---

## Cl2 분자 HSE06 이완 계산 (2026-06-26)

경로: `33-inAs/__Ligands_and_Chemicals__/05-Cl2-molecule/12-HSE06-Gamma/`

### 구조
```
12-HSE06-Gamma/
├── ENCUT300/   (job 52423, 완료)
└── ENCUT400/   (job 52424, 제출됨)
```

PBE CONTCAR (`11-PBE-Gamma/ENCUT{300,400}/CONTCAR`) → POSCAR로 사용

### INCAR 주요 설정
| 항목 | 값 |
|------|-----|
| AEXX | 0.27 |
| LHFCALC | .TRUE. |
| HFSCREEN | 0.2 |
| PRECFOCK | fast |
| LHFSKIP | .T. |
| ALGO | Normal |
| NCORE | 6 |
| NSW | 1000, IBRION=1, EDIFFG=-0.015 |

VASP 바이너리: `/TGM/Apps/VASP/VASP_BIN/6.5.1/vasp.6.5.1.dftd4.wan90.beef.plugin.lhfskip.gam.x`

### ENCUT300 결과 (job 52423)
- 3 이온 스텝 만에 수렴 (PBE CONTCAR 출발점이라 이미 최적화 근접)
- Step 1: NELM=100 도달 (SCF 미수렴), F=-5.3863 eV
- Step 2: F=-5.3950 eV (dE=-8.69×10⁻³)
- Step 3: F=-5.3953 eV (dE=-3.12×10⁻⁴) ← 수렴
- **최종 에너지: -5.3953 eV**

### LHFSKIP + ALGO=Normal 선택 이유
LHFSKIP은 이온 이동 시 HF 교환을 건너뛰고(PBE force로 이완) 마지막 step에만 HF 포함. 따라서 실질적 SCF는 PBE 수준에서 돌아 ALGO=Normal로도 안정 수렴. ALGO=All은 HSE 완전 이완(LHFSKIP 없을 때) 권장.

**Why:** InAs 화학 포텐셜 계산에서 Cl₂ 분자의 HSE06 에너지가 필요 (AEXX=0.27은 InAs bulk 계산과 동일한 mixing parameter).
**How to apply:** ENCUT400 완료 후 두 값 비교하여 ENCUT 수렴 확인 후 μ_Cl₂ 계산에 사용.
