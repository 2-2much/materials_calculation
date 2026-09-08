---
name: mote2-1tp-pstress-scan
description: 1T' PSTRESS 스캔 셋업 (04-T4_PSTRESS_test). ★E(A) 최소는 정의상 P=0이라 a0를 새로 주지 않음 — 목적은 b/a 변화 확인
metadata:
  node_type: memory
  type: project
---

`~/materials/moTe2/01-Convergence_test/1Tp/00b-tight-relax/04-T4_PSTRESS_test/`
(2026-09-08 셋업. [[mote2_1tp_bm_fit_deferred]] 의 "추후 PSTRESS 재시도"를 실행에 옮긴 것)

## ★ 이 스캔이 알려주지 "않는" 것
각 점은 압력 P 아래의 평형이라 `dE/dA = −σ_2D`. 따라서 **E(A) 의 최소점은 정의상 P=0 점**
이고 그건 ISIF=3 이완이 이미 준 a₀=3.4076715 다. **a₀ 를 새로 구하는 계산이 아니다.**

목적은 셋:
1. **b/a 가 변형에 따라 변하는지** — BM 스캔은 1.85330 에 고정했다. 변하면 그게 피팅 실패 원인
2. 각 점이 스스로 이완된 매끄러운 E(A) — 압축쪽 이량화 비단조성이 사라지는지
3. P=0 점이 ISIF=3 결과와 일치하는지 교차검증

## ★ 압력마다 두 번 돈다 (01-run → 02-restart)
ISIF=3 는 셀이 변하는데 평면파 기저는 **처음 POSCAR 기준**으로 잡힌다. 이완된 셀을 다시
POSCAR 로 넣고 한 번 더 돌려 기저를 새로 잡는다(Pulay 처방). **최종 값은 02-restart 에서.**
같은 이유로 **FFT 격자를 고정하지 않는다** — 고정은 셀이 안 변하는 BM 스캔에서만 맞는 처방
(⚠내가 처음에 고정을 넣었다가 사용자 지적으로 제거).
ENCUT 600 / ENMAX 242.68 = 2.47배라 잔여 Pulay 는 무시 가능.

## 압력→변형 환산 (슬랩)
`σ_2D = P·c`. c=23.6177 Å → **1 kB 당 0.236 N/m**. K_2D≈126 N/m 이면

| PSTRESS | σ_2D | 면적변형 | a 변형 | Δa |
|---|---|---|---|---|
| ±1.5 kB | 0.354 N/m | 0.28% | 0.14% | 0.005 Å |
| ±3.0 | 0.709 | 0.56% | 0.28% | 0.010 |
| ±4.5 | 1.063 | 0.84% | 0.42% | 0.014 |

⚠ 이전 BM 스캔은 ±1%(±0.035 Å, 에너지 폭 ~50 meV). **±4.5 kB 는 양끝 6 meV 뿐**이다.
같은 폭을 원하면 ±12 kB. 스크립트의 `PLIST_POS`/`PLIST_NEG` 만 고치면 된다.

## 구현
`pstress_volume.sh` (원본은 `.pre_pstress_backup`). `README.md` 있음.
- P=0 먼저 → 양쪽으로 걸어나가며 **이웃 CONTCAR 시드**(같은 이량화 분지 유지)
- `pstress_structures/P0/{01-run,02-restart}`, `Pm4p5/...` 식. `.done` 으로 이어돌리기
- 결과 `lattice_G`: `PSTRESS a b b/a A V E_sigma0 enthalpy sxx conv`
- **E_sigma0 이 피팅용 내부에너지.** enthalpy(E+PV)는 최소점이 다르다
- ISTART=0/ICHARG=2 (셀이 매번 달라 WAVECAR 물려받지 않음), IBRION=2, NSW=200, EDIFFG=−1E-3

## ⚠ 함정
- **PSTRESS 부호를 첫 실행에서 확인할 것.** 양수가 압축이면 a(P) 가 줄어야 한다
- ⚠sed 로 INCAR 값 바꿀 때 `= *-\?[0-9E.]*` 류는 `EDIFFG=-1E-2` 의 뒤 `-2` 를 남겨
  `-1E-3-2` 를 만든다. **`s/=[^ #]*/=값/` 로 "= 부터 공백/# 직전까지" 통째로** 바꿀 것
  (예전 `IBRION=1-1` 사고와 같은 원인)

관련: [[mote2_1tp_bm_fit_deferred]] [[mote2_2d_lattice_scan]]
