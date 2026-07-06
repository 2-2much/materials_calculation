---
name: adispersion_scan_pbed
description: "Cl-As_In a축 dispersion 수렴 스캔(PBE-d, p3/p4/p5×2) 셋업 + 큰 셀 결함구조는 strip-insertion으로 만들 것"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6e839863-cc2e-4f77-bc3b-1568b9fed6cc
---

12-Surace.../02-Cl-passv_6L_3x2x1_HSE06/`__a-dispersion-scan_PBE-d__/` (2026-07-06, kohn서버=ClusterName tgmv2).

**목적**: HSE06 03_Band에서 Cl-As_In(q+1) defect band(As antisite)가 Γ→X(=a축) 경로에 dispersion 잔존
→ a축만 3→4→5로 키워 PBE-d로 수렴 스캔. (dispersion 폭은 PBE-d≈HSE06 ~20-30%내, λ는 functional 무관 → 싼 대체재 정당.)

**셀/셋업**: q+1, ISPIN=1. 3단계 `00_Gam-relax`(Γ, vasp.gam) → `01_1shot`(2×2×1 std, ISTART=0 ICHARG=2 → CHGCAR) → `02_band`(ICHARG=11 line-mode **Y–Γ–X–S**, S=(0.5,0.5,0), 10pts/seg). fatband antisite index: p3=36, p4=48, p5=60. NELECT q+1: 742/990/1238.
- Γ→X=a축 dispersion; Y→Γ·X→S=b* 방향(b는 2×고정→불변, 수렴 floor 대조군). **분리형 TB에선 Y–Γ와 X–S branch의 에너지 오프셋 = 4t_a = a축 dispersion** → 두 flat branch가 붙으면 a축 수렴.
- k-path/pts, node수(p3=4, p4/p5=5)는 config 아닌 setup_scan.py 하드코딩.

**⚠ 큰 셀 결함구조 만드는 법 (핵심 교훈)**: pristine을 primitive로 접어 타일링 후 antisite+Cl을 **ideal 위치+offset으로 새로 심으면 relax 중 Cl2 desorption**(Cl 표면 위 4.5Å로 이탈) 발생 → 폐기. 반드시 **strip insertion**: relaxed reference(`CONTCARs_PBE-d/Cl-As_In/CONTCAR_Cl-As_In_q0`) 셀을 통째로 유지(결함 클러스터 그대로)하고 pristine 컬럼(폭 w=a/3)을 가장자리에 (N−3)개 삽입. → binding mode(Cl 표면 위 ~1.82Å) 초기구조에 보존. `build_scan.py`가 이 방식.

**운영 함정**: run_pNx2.sh는 `ROOT=$(pwd)` 쓰면 제출 위치(스캔루트)로 잡혀 즉사 → **ROOT 절대경로 하드코딩**. 관련 [[surface_defect_istart_wavecar_gam_std]](gam WAVECAR을 std가 못읽음→01은 fresh SCF), [[defect_states_02_clpassv]].
