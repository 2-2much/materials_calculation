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

**결과/결론 (2026-07-06 완료, `ANALYSIS.md`)**: aDisp(Γ→X) = 0.335→0.233→0.198 eV (p3→p4→p5, a=13.1/17.5/21.9Å). 한계효용 p4에서 급감(p3→p4 −0.10 / p4→p5 −0.035eV). concave(λ 12→27Å), 완전평탄은 ~p8-10×2 비현실적. b축(2×고정): Y→Γ ~0.09-0.13eV 불변, X→S≈0 flat → 대각결합 t_ab≈t_b, antisite는 a축 delocalized resonant-ish donor. **방침: HSE06 본계산 셀 = p4×2 채택**(완전수렴 아닌 "충분히 작음", 잔여~0.23eV). CTL/formation E는 dispersion 무관 경로(total-E + Falletta correction)로, dispersion은 진단용.

**2026-07-06 vertical-transition slabcc setup**: bloch에서 vacuum thickness를 바꿔가며 slabcc를 돌렸던 경험을 바탕으로, 이번에는 a축 cell size(p3/p4/p5)가 바뀔 때 neutral defect geometry `R(q0)`에서 q0와 q+1 PBE-d static 계산을 수행하고, `~/bin/slabcc/bin/slabcc`로 vertical transition correction을 계산하는 셋업을 만듦. 위치는 `__a-dispersion-scan_PBE-d__/__vertical-transition_slabcc__/`. workflow: `00_q0-relax`(q0, Gamma, ISPIN=2, NUPDOWN=1) → `01_q0_1shot`(q0, 2×2×1, CHGCAR/LOCPOT) → `02_qp1_1shot`(q+1, same R(q0), 2×2×1, CHGCAR/LOCPOT) → `03_slabcc`. POSCAR/build_scan 기준 antisite/fatband index는 p3=36, p4=48, p5=60. NELECT q0/q+1: p3=743/742, p4=991/990, p5=1239/1238. `make_slabcc_input.py`가 q0-relaxed CONTCAR의 antisite 좌표를 읽어 `charge_position`을 쓰고, `collect_vertical.py`는 `E(q+1;R(q0))-E(q0;R(q0))+E_slabcc`를 `vertical_transition_summary.tsv`로 모은다.

**2026-07-06 bloch submission**: 사용자가 VASP/slabcc job 제출까지 요청하여 처음에는 `__vertical-transition_slabcc__/submit_vertical_all.sh` 실행했고 Slurm job id p3x2=`55154`, p4x2=`55155`, p5x2=`55156`이 배정됨. 이후 사용자가 `03_slabcc`는 1 node + `OMP_NUM_THREADS=32`로 따로 돌리는 게 좋다고 지적. 기존 5-node monolithic jobs `55154/55155/55156`은 `scancel`로 취소하고, 스크립트를 VASP 단계와 slabcc 단계로 분리함: `run_pNx2_vasp.sh`는 `00_q0-relax`→`01_q0_1shot`→`02_qp1_1shot`만 5 nodes로 실행, `run_pNx2_slabcc.sh`는 `--nodes=1 --ntasks-per-node=32`, `OMP_NUM_THREADS=32`로 `03_slabcc`만 실행. 새 dependency submission job id: p3x2 VASP=`55157`, slabcc=`55158`; p4x2 VASP=`55159`, slabcc=`55160`; p5x2 VASP=`55161`, slabcc=`55162`. 제출 직후 `squeue`: `55157 vtV-p3x2` RUNNING on `n[024-028]`; `55159/55161` PENDING; `55158/55160/55162` PENDING(Dependency).

**2026-07-06 node-count correction for KPAR=2**: 사용자가 2×2×1 static 계산에서 `KPAR=2`인데 5 nodes(160 ranks)는 k-point group이 node 단위로 잘 안 나뉜다고 지적. `p3x2`는 이미 VASP가 끝나 slabcc(`55158`)가 1 node에서 실행 중이라 그대로 둠. `p4x2/p5x2`의 이전 VASP/dependency jobs `55159/55160/55161/55162`는 취소하고, `run_p4x2_vasp.sh`/`run_p5x2_vasp.sh` 및 `setup_vertical_slabcc.py` 템플릿을 `#SBATCH --nodes=4`, fallback `NPROC=${SLURM_NTASKS:-128}`로 수정. 새 submission: p4x2 VASP=`55163`, slabcc=`55164`; p5x2 VASP=`55165`, slabcc=`55166`. 제출 직후 `squeue`: `55163 vtV-p4x2` RUNNING 4 nodes `n[024-027]`; `55165 vtV-p5x2` RUNNING 4 nodes `n[012,016-017,028]`; `55164/55166` PENDING(Dependency); `55158 vtS-p3x2` RUNNING 1 node `n011`.

**2026-07-06 p4x2 slabcc 중간 분석**: 사용자가 p4x2 slabcc 결과 분석 요청. 확인 당시 `55164 vtS-p4x2`는 1 node `n011`에서 RUNNING, `p4x2/03_slabcc/slabcc.out`은 아직 0 byte라 최종 `Energy correction`은 미산출. VASP static은 완료되어 raw vertical energy는 계산 가능:
`E(q0;R(q0))=-461.19395480 eV`, `E(q+1;R(q0))=-460.81239925 eV`, raw vertical=`0.38155555 eV`.
slabcc는 fitting 완료 후 energy/extrapolation 단계에 진입. 현재 로그상 model: interfaces≈`0.23925/0.78849`, charge_position≈`0.30653/0.51398/0.65644`, charge_sigma≈`3.8499/0.1/1.8175`, dV≈`-0.002688 eV`, E_periodic≈`0.354967 eV`. 중요한 품질 이슈: model charge는 slab 내부/외부 `0.999791/0.000178`인데 실제 defect charge difference는 `0.706141/0.293860`; 즉 extra charge의 약 29%가 surface/vacuum 쪽으로 분포. 경고 메시지: extra charge may be partially localized on slab surfaces. 또한 `charge_sigma_y=0.1` lower bound에 붙고, RMSE≈`0.0507`, z 방향 error가 커 anisotropy≈`7.6`. 해석: p4x2 slabcc correction이 나오더라도 깨끗한 localized defect correction으로 강하게 신뢰하기보다는, Cl-As_In donor charge가 surface/resonant-like하게 퍼졌다는 진단으로 보는 것이 안전. 최종 vertical은 `0.38156 eV + E_corr_slabcc`.
