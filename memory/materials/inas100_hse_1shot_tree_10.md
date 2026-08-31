---
name: inas100_hse_1shot_tree_10
description: "10-100AA-unrecon 트리 __HSE06_1shot__ — 진공을 09와 맞추는 규약(pure 기준·cartesian z 보존)과 PBE-pre→HSE 2단 구조"
metadata:
  type: project
---

2026-08-31. `12-Surace-defect_calculation/10-100AA-unrecon_8L_par4x3_PBE-d/__HSE06_1shot__/`
(kohn 로컬). pure + V_In 2셀, q0만. 생성기 `make_hse_cells.py`, 상세는 그 폴더 `README.md`.

## ★ 진공을 다른 트리와 "같게" 맞추는 규약 (재사용할 것)

셀 c 를 그냥 복사하면 안 된다 — 09(0.5 ML acetate)와 10(1.5 ML)은 **슬랩 두께가 다르다**.
맞추는 건 c 가 아니라 **진공 간극**이고, 기준은 **pure 셀**이다:

    vac := c − (z_max − z_min)          (원자 cartesian z 기준)
    c_new = thickness(pure, 이 트리) + vac(pure, 기준 트리)

- **cartesian z 를 보존하고 분율 z 를 다시 계산**한다. 분율을 그대로 두면 슬랩까지 압축된다.
- 결함 셀은 **같은 c 를 쓴다**(E(V_In)−E(pure) 때문에 필수). 리간드가 더 튀어나오면 그만큼
  진공이 줄어드는데, 09 도 똑같이 그렇다(12.46 / 11.88 → 10 은 12.46 / 11.35 Å).
- 순서: **진공 재설정 → 등방 a0 배율**(×0.9852104464). 검증: 모든 원자가 정확히 `F × r_old`
  (2e-10 Å). 10 은 c 41.8429 → 29.4912 → 29.0550 Å.
- 슬랩을 z 로 **옮기지는 않았다** → 진공 간극이 셀 경계를 감싼다(박스 안: 슬랩 아래 9.85 Å,
  위 2.60 Å). LOCPOT 평탄부를 읽을 때 wrap 처리하거나 아래쪽 넓은 창을 쓸 것. 09 도 동일.

## 2단 구조 (09·34·35 트리와 공통)

`00_PBE-pre` (ISTART=0/ICHARG=2, EDIFF 1E-5, LWAVE=T) → `01_HSE-1shot`
(ISTART=1/ICHARG=0, EDIFF 1E-4). `run.sh` 하나가 두 단계를 한 잡에서 돌리고
POSCAR/WAVECAR/CHGCAR 를 넘긴다. LHFSKIP 대신 PBE 다리를 **명시적으로** 떼는 이유:
**이 기하 위의 PBE 값이 남아서 PBE→HSE 차이가 순수 함수 차이가 된다**(배율·진공 컷이 공통).
⚠ 00 도 ISPIN=2 여야 01 의 ISPIN=2 가 의미 있다 → [[spin_stage_symmetry_never_broken]].
MAGMOM 은 기본값(전 이온 1.0) — PBE 가 둘 다 비자성이라 대칭 깨짐 기회를 주려고 일부러.

설정: Γ 2×2×1(ISYM=0 → k 4개), AEXX=0.27, PRECFOCK=Fast·ALGO=Normal·ISPIN=2(사용자 요청),
ENCUT=400, ISMEAR=0/SIGMA=0.1(두 단계 공통), cascade2 4노드×32, KPAR=4/NCORE=16.

⚠ PRECFOCK=Fast 는 V_In(Δn={In:−1})에서 **상쇄 안 됨** → 스크리닝용
([[precfock_fast_policy]]). ⚠ 저장소 μ 는 전부 PBE 라 **E_f 는 못 낸다**.
⚠ 부모 PBE-d `V_In/01_Spin-gam-relax` 는 **NSW=200 소진**(pure 는 수렴)
→ [[inas_vin_facet_trees_10_23]].

관련: [[inas111_hse_tree_35]] [[inas_facet_hse_1shot_setup]] [[hse_relax_vs_singlepoint]]
[[hse_slab_dipole_convergence_trap]] [[inas100_worktree_on_kohn]]
