---
name: zeroband_spin_parsing
description: zeroband.py 밴드플롯 --spin 옵션 및 collinear ISPIN=2 PROCAR 파싱 수정
metadata: 
  node_type: memory
  type: reference
  originSessionId: c6626a4c-f8e4-444e-ad3b-d96c2b28d963
---

`~/bin/zeroband.py` (PROCAR zero-weight k-point 밴드 플로터)의 `--spin` 옵션.

- `--spin 1`(기본)=spin up, `--spin 2`=spin down. SOC/noncollinear PROCAR는 `spin component 1~4` 선택.
- **collinear ISPIN=2 PROCAR 함정**: VASP는 up/down을 `"spin component"` 라벨 없이 **두 개의 연속된 `# of k-points` 블록**으로 저장(앞=up, 뒤=down). 원래 파서는 `spin component N` 라벨로만 스핀을 구분해서, 이 형식에선 `--spin 2`가 전부 NaN 에러, `--spin 1`은 뒤 블록이 앞을 덮어써 값이 뒤섞였음.
- **수정(2026-07-02)**: `spin component` 라벨이 없고 `# of k-points` meta 헤더가 2개 이상이면 collinear ISPIN=2로 판정(`has_meta_spin_blocks`), meta 헤더 만날 때마다 `current_spin`을 1→2로 증가시켜 블록별로 스핀 매핑. 이 형식에선 spin 1/2만 허용. 단일스핀/SOC 동작은 그대로.
- 검증: `--spin 1`==앞 블록, `--spin 2`==뒤 블록 (np.array_equal True), up≠dn(최대차 ~0.9 eV).

사용: `zeroband.py --spin 2 -o spin_dn.png` (원본 PROCAR 그대로, 수동 분리 불필요). 관련 계산: [[surface_defect_1shot_band_workflow]] 03_Band 단계.
