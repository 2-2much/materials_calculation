---
name: defect-calc-folder-structure
description: Surface defect 계산 프로젝트의 표준 폴더 계층구조 — calc/config/inputs/scripts 패턴
metadata: 
  node_type: memory
  type: project
  originSessionId: 8e59eb16-e97c-4e8c-98e6-c7584c17d589
---

Surface defect formation energy 계산에서 반복적으로 사용하는 폴더 구조.

**Why:** 사용자가 새 defect 계산을 세팅할 때 이 패턴을 따르므로, 파일 생성/탐색/스크립트 작성 시 이 구조를 기준으로 해야 함.

**How to apply:** 새 계산 세팅, 스크립트 작성, 결과 분석 시 이 계층구조를 전제로 작업.

## 표준 구조

```
{project_root}/                        # e.g. 01-Cl-passv_6L_3x2x1
├── 01-build-1x1cell/                  # 1x1 unit cell 구축 (초기 구조 생성)
├── calc/                              # VASP 계산 결과 (본 계산)
│   ├── pure/q0/                       # pristine slab (reference)
│   │   └── 01_Relax/
│   ├── {defect_name}/                 # e.g. As_In, Cl-As_In, In_i, In_i2
│   │   ├── q0/                        # charge state q=0
│   │   │   ├── 01_Relax/              # structure relaxation
│   │   │   │   ├── 01-T1_STOPCAR/     # trial runs (optional)
│   │   │   │   └── 02-PCHARG/         # PCHARG restart etc.
│   │   │   └── 02_Band/              # band structure calculation
│   │   ├── q+1/                       # charge state q=+1
│   │   │   ├── 01_Relax/
│   │   │   └── 02_Band/
│   │   └── _chgcar_diff_/            # CHGCAR difference analysis (optional)
│   └── ...
├── config/                            # VASP 입력 템플릿
│   ├── INCAR/                         # INCAR 파일들
│   │   └── __Hold__/                  # 보류/백업 INCAR
│   └── KPOINTS/                       # KPOINTS 파일들
│       └── __Hold__/                  # 보류/백업 KPOINTS
├── inputs/                            # 초기 POSCAR (defect 구조)
│   ├── pure/
│   └── defects/
│       ├── {defect_name}/             # e.g. As_In, Cl-As_In, In_i
│       └── ...
└── scripts/                           # Python 분석/자동화 스크립트
```

## 핵심 패턴

- **calc/{defect}/{charge_state}/**: 계산 단계별 하위 폴더 (01_Relax → 02_Band)
- **charge state 표기**: `q0`, `q+1`, `q+2`, `q-1` 등
- **01_Relax 내 trial**: `01-T1_...` 등으로 시행착오 기록
- **__Hold__**: 아직 사용하지 않거나 보류 중인 설정 파일 보관
- **inputs/defects/**: calc에서 사용할 초기 POSCAR을 defect별로 정리
