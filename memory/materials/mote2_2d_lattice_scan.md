---
name: mote2-2d-lattice-scan
description: MoTe2 단층막 04-BM_fit — 2D엔 bulk modulus 없음. c 고정 면내 a 스캔 + E(a) 최소점. 수렴값 k9x9x1/ENCUT500/vac15~20
metadata: 
  node_type: memory
  type: project
  originSessionId: 34560bc0-fd0a-419b-85d0-d053b02a7602
  modified: 2026-09-03T04:40:08.736Z
---

`~/materials/moTe2/01-Convergence_test/` (2026-09-03).

## 수렴값 확정
- k-point: **Γ-centered 9×9×1** (수렴한계 대비 0.007 meV). MP 금지 — 육방정 대칭을 깸(k=2에서 280 meV 이탈)
- **ENCUT=500 eV** (700 대비 0.098 meV). Mo_sv ENMAX=242.68
- **vacuum 15 Å** (최소 12). 10 Å 이상 추세 없음, 산포 0.574 meV

## ⚠ ENCUT 곡선 요철은 구조 이완 탓이 아니다
Te z가 10개 런 전부 3.83666 Å로 **동일**(NSW=500이 켜져 있었지만 힘이 이미 EDIFFG 미만이라 안 움직임). 진짜 원인:
1. `PREC=Normal` — FFT 격자가 ENCUT에 따라 계단식 점프(14,14,60 → 24,24,100). aliasing은 변분적이지 않음
2. `EDIFF=1E-4`가 너무 헐거움 — 정지 시점에 아직 +0.08 meV/스텝 드리프트 중
3. 300 eV 점의 2.4 meV 이탈은 위 둘로 **완전히 설명 안 됨**(300/350은 격자 동일). 미해결

셀 크기가 바뀌면 격자가 튀어 ±0.3 meV 잡음이 얹힌다 → **스캔에선 NGX/NGY/NGZ 고정**. (진공 스캔에서 dz가 0.2202~0.2362 Å를 오감)

## 2D 격자상수 결정 방침
- **2D에는 bulk modulus가 존재하지 않는다** (사용자 확인). 슬랩 V=A·c의 c가 임의값이라 B₀=−V∂P/∂V가 정의 안 됨. 목표는 **E 최소인 a₀ 하나**
- c 고정, 면내 a=b만 스캔. **POSCAR 2번 줄(전역 scale) 금지 → 3·4번 줄(a1,a2)만 배율**. Direct 좌표라 카테시안 z 자동 보존
- `ISIF=8` 금지(진공 짜부라뜨림). 각 점 `ISIF=2`로 Te z 이완 필수(zincblende와 달리 자유도가 있음)
- 부피 대신 **면적 A=|a1×a2|** 기록
- 피팅은 E(a) 다항식(deg 4)로 최소점. deg≥3끼리 a₀ 일치하면 견고
- 검증: 3D BM 식에 **면적**을 넣어도 a₀는 ±8%까지 0.005 mÅ 이내로 같다 → 지수 2/3 vs 1은 a₀에 거의 무영향. 실제로 깨지는 건 **진공 포함 부피를 넣을 때**
- 참고용 면내 강성 A₀·d²E/dA² [N/m] = (C11+C12)/2. GPa 환산 금지

## 스크립트 (04-BM_fit)
`volume.sh`(STAGE=relax/scan/fit/final/all) · `setup_murnaghan.sh` · `run_murnaghan.sh` · `birch_murnaghan_modified.py --dim 2`.
원본 InAs 벌크판은 `*.bulk_backup`. 벌크판 버그: `${A0_BM}` 미정의, `KPOINTS_Gamma` 부재, `INCAR0` 부재, `PREFOCK` 오타(→PRECFOCK), 3원자 셀에 240코어.

관련: [[inas100_cell_convergence_metric]] [[vacuum_scan_vbm_reference_trap]]
