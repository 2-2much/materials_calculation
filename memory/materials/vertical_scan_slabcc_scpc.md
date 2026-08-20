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

**후속 in-plane 스캔 재작업(2026-07-06)**: `__a-dispersion-scan_PBE-d__/__vertical-transition_slabcc__`(p3/4/5x2 in-plane 확장)이 **진공 11Å + `optimize_charge_position=yes`(free)**로 크게 틀림 — slabcc가 model charge를 슬랩중앙으로 끌고 σ_x=3.85 발산. 교훈 재확인(진공≥40Å + charge position 고정). 재작업 폴더 `__vertical-transition_slabcc_vac40__`: relaxed R_q0(00_q0-relax/CONTCAR) 재사용, c=slab두께+40≈**55.05Å**(bloch값, 슬랩 z=0.5 센터·양쪽20Å)로만 재빌드, INCAR/POTCAR는 기존 1shot 복사(NELECT/ISPIN동일). slabcc를 **fixed(optimize_charge_position=no)/free(yes) 두 변형** 모두 생성해 직접 비교. build_vac40.py+make_slabcc_input.py(fixed+free 자동생성, charge_position·interfaces를 40Å POSCAR에서 자동)+collect_vac40.py. 제출 jobs 55172-55177(tgm-master cascade2).

[[scpc_vacuum_scan]]는 formation E_f 수렴(slabcc 없음)으로 별개 작업. [[adispersion_scan_pbed]] [[scpc_debug]] [[pydefect_2d_setup]].

---
## ⚠⚠ 2026-08-19 폐기 — "최소 진공 40 Å" 은 틀린 결론이었다

사용자 확인: **하전 결함은 진공 15 Å 에서도 진공길이에 대해 올바르게 수렴한다.**
[[vacuum_scan_vbm_reference_trap]] (2026-07-22, 더 나중·더 정밀) 이 원인을 분리해 놓았다:

- **보정(slabcc/SCPC) 자체는 13.5 Å 에서 이미 수렴**한다.
- 얇은 진공에서 "발산"처럼 보였던 것은 **기준 레벨(gauge)** 이다. VASP 고유값은 셀-평균
  정전퍼텐셜 기준이라 진공을 늘리면 전 고유값이 통째로 이동한다(원시 VBM 2693 meV 이동,
  진공준위 기준 VBM 은 39 meV 만 이동 = **98.5 % 가 gauge**).
- 따라서 **`q·E_VBM` gauge 항과 pure↔defect `ΔV` 정렬을 제대로 넣으면** 얇은 진공에서도 맞는다.
  이 두 항을 빼먹으면 수렴한 보정이 1 eV/step 실패처럼 보인다.

즉 이 문서의 "권장 최소진공 40 Å" 은 **그 두 항을 분리하기 전의 판단**이고 폐기한다.
진공을 늘려야 하는 진짜 이유가 있다면 그것은 보정 수렴이 아니라 다른 것(예: 리간드 머리 공간)이다.
