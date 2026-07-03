---
name: zeroband_fatband_tool
description: zeroband.py — hybrid band(zero-weight kpt) projected fatband 플로터 위치/사용법
metadata: 
  node_type: memory
  type: reference
  originSessionId: a19a1dd4-de23-4e4c-a6b5-fa331294948d
---

`~/bin/zeroband.py` — VASP hybrid-functional band 계산(KPOINTS에 explicit zero-weight k점 사용)의 원자/오비탈 projected fatband 플로터. 입력: PROCAR, KPOINTS, POSCAR(현재 디렉토리 기본값).

핵심 사용법:
- `zeroband.py --proj "95 all" --fermi 1.0810 --spin 1 -o out.png`
- weight==0 인 k점만 그림(hybrid SCF용 finite-weight k점은 자동 skip).
- `--spin`: collinear ISPIN=2 PROCAR → 1=up, 2=down (VASP가 두 개의 연속 "# of k-points" meta 블록으로 기록, spin label 없음). SOC → spin component 1-4.
- `--proj` 문법: `"ATOM_SPEC ORB ORB, ATOM_SPEC ORB"` 예) `"1 s px dz2, 2 s"`, `"1-8 s p, 9-16 p"`. atom index는 1-based. orbital 축약: `p`, `d`, `f`, `all`.
- Fermi는 OUTCAR `E-fermi`에서 읽어 `--fermi`로 전달(자동 아님).
- 기타: `--ylim EMIN EMAX`, `--scale`(마커크기), `--wmin`(최소 weight), `--colors`, `--labels`.

모듈 import도 가능(`import zeroband as zb`): read_poscar_lattice, read_kpoints, zero_weight_indices, build_kpath, read_procar, parse_projection_spec, compute_channel_weights → 커스텀 side-by-side 비교 그림 등에 활용. 관련 워크플로우 [[surface_defect_1shot_band_workflow]].
