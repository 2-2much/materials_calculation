---
name: mote2-1tp-bm-fit-deferred
description: MoTe2 1T' BM 피팅은 잘 안 맞지만 격자상수는 신뢰 → 보류하고 진행. 추후 PSTRESS로 E-V 곡선 피팅 재시도
metadata:
  node_type: memory
  type: project
---

`~/materials/moTe2/01-Convergence_test/1Tp/04-BM-fit/` (2026-09-07 판단).

## 결정: 1T′ BM 피팅은 여기서 접고 넘어간다
격자상수 자체는 세 경로가 잘 모이므로 **다음 단계(V_Te 결함 등)로 진행**한다.

| 경로 | a₀ (Å) |
|---|---|
| ISIF=3 volume relax (c 고정) | 3.407672 |
| 4차 다항식 피팅 (`--model poly`) | 3.409387 |
| 2D BM 면적 피팅 (`--model bm`) | 3.411989 |

b/a = **1.85330**. ΔE(2H→1T′) = **46.2~46.6 meV/f.u.** (문헌 arXiv:2112.02319 Fig.2의 ~43과 3 meV 이내 일치).

## 추후 재시도 방침
**PSTRESS를 주면서 E–V 곡선을 얻어 피팅**한다. 지금처럼 배율을 강제로 넣는 대신 외부 압력으로 셀을 밀어 각 압력의 이완 셀을 얻는 방식.

## 왜 BM이 안 맞았나 — 배제한 것들
1T′만 B₀′가 상한 30에 붙고 RMS 1.55 meV (2H는 0.023). 아래는 **전부 원인이 아님을 확인**:
- FFT 격자 점프 → NGX/NGY/NGZ 고정해도 그대로
- `--cell hex` 오적용 → `--cell ortho --boa 1.85330`으로 고쳐도 **a₀는 불변**(K가 f에서 상쇄. 바뀌는 건 A₀·B₀뿐)
- 이완 경로 → 이웃 셀 seed(`02-T2_Relax_neighbor`, IBRION=2)로 다시 돌려도 에너지 변화 0.07 meV 미만
- 기준 셀 미평형 → ⚠**내 오진이었다**. vasprun.xml 응력을 kB로 착각해 ×10 했음(vasprun은 **이미 kB**). 실제 OUTCAR 값은 0.093/0.145/−0.084 kB로 충분히 작다

**남은 가설**: 압축 쪽 dimerization 비단조성(scale 0.9900/0.9925/0.9950에서 0.5251 → **0.5028** → 0.5184). 1T′ 고유의 물리이고 BM3 함수형으로는 표현 불가. 실질 영향은 0.5 meV라 상평형 판정엔 무해.

## 3상 공통 발판 (2H/1T/1T′)
- k: **0.17 Å⁻¹ 등밀도** → 2H·1T `12×12×1`, 1T′ `11×6×1` (상간 오차 1.4 meV/f.u.)
- ENCUT **400 eV**로 상 에너지차는 충분(600 대비 0.01 meV 미만)
- ISMEAR=0 통일 (2H 반도체 + 1T/1T′ 금속 혼재라 −5·1 불가)
- 1T′는 직교 셀, 2H/1T는 육방 → `hex_to_ortho.py`(√3×1, det=2)로 셀 모양 통일 가능

관련: [[mote2_2d_lattice_scan]]
