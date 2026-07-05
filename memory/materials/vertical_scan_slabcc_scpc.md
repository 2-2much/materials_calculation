---
name: vertical_scan_slabcc_scpc
description: "Cl-As_In(+1) __vertical_scan__ slabcc≡SCPC 교차검증, 진공수렴, 정렬 이중계산 금지, resonant donor"
metadata: 
  node_type: memory
  type: project
  originSessionId: 0356f79b-9d29-4523-9dbb-a80e6d25376b
---

`12-Surace-defect_calculation/01-Cl-passv_6L_3x2x1/calc/Cl-As_In/__vertical_scan__` (2026-07-03 완료, REPORT.md·summary.csv). Cl-As_In q=+1 표면결함 하전 finite-size 보정을 **SCPC와 slabcc 두 독립방법으로 교차검증** + 진공수렴 확인.

**세팅**: vertical transition(중성 relaxed R_q0에 원자고정, 전하만 0→+1, ionic완화 제외), 진공 30/40/50Å 스캔, 셀정렬=바닥층pin+z-center(`make_aligned_vacuum.py`), ε∞=12.3.

**결과 ①: SCPC ≡ slabcc corrected total energy 6meV 일치**
- 40Å: SCPC −344.059 vs slabcc-auto −344.053 / 50Å: −344.043 vs −344.037.
- 같은 delocalized 밀도 기술 → 상호검증 성공.

**결과 ②: 진공 수렴** — raw E_DFT는 진공↑ 시 +0.4~0.6eV 발산(주기이미지 self-E)이지만 보정후 40→50Å에서 16–21meV 수렴. **30Å는 얇아 수렴영역 밖(−0.22eV 이탈) → 신뢰구간 40Å 이상**. 권장 최소진공 40Å, E_corr≈−0.87eV(40Å).

**⚠️ 정렬 이중계산 금지**: SCPCOUT `Energy Correction`엔 전기적정렬(½q·ΔV=ecor1−ealig, scpc.F rev7 L1037/L1021) 이미 포함. 별도 출력 `Potential Alignment`(~48meV, scpc_potalignment L1316)는 진단량 → 형성E에 추가가산 시 과보정. slabcc E_corr도 `E_iso−E_per−q·dV`로 정렬내장이라 SCPC와 직접비교 가능(6meV 일치가 증거).

**slabcc auto vs fixed**: auto는 30Å σ=4.01 delocalized abort, 40/50Å도 model charge가 슬랩중앙 이동. `optimize_charge_position=no`로 defect atom36 고정(fixed)→σ 1.7~1.85 안정이나 |E_corr| 40~50meV 작아짐.

**물리결론(§7)**: E_relax(+1)=88meV. ε_thermo(0/+1)=VBM+0.81eV로 **CBM(+0.24) 위 → shallow/resonant donor**(중성 여분전자 CB로 자동이온화 = delocalization 근거). ⚠PBE gap 0.24eV 과소평가 → HSE06 확정 필요.

[[scpc_vacuum_scan]]는 formation E_f 수렴(slabcc 없음)으로 별개 작업. [[scpc_debug]] [[pydefect_2d_setup]].
