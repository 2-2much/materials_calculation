---
name: inas111-hse-tree-35
description: "35-111ClMA_4BL_2r3R30_HSE-d (sham) — 22 트리 5셀의 HSE06 1shot, 2x2x1 Gamma-centered. 배율 s=0.9852104464 는 34 트리와 16자리 동일"
metadata:
  node_type: memory
  type: project
---

2026-08-31 생성. **sham** `12-Surace-defect_calculation/35-111ClMA_4BL_2r3R30_HSE-d/`
(GitHub Defect_Package 클론). 참조 트리 = **34-100MACl_8L_par4x3_HSE-d** (같은 서버, (100) 판).

## 기하
[[inas111_clma_2r3r30_tree_22]] 의 이완 CONTCAR 5종(pure · Cl_As · Cl_MA · V_In_1 · V_In_2)을
**세 격자벡터 전부 균일 배율**:
  s = a0(HSE06-PBEd,AEXX0.27)/a0(PBE-d) = 6.098297/6.189842 = **0.9852104464055786**
  a 15.1619544884 → **14.9377159499** Å, c 32.2699154701 → **31.7926578257** Å
분수좌표 불변(max|dfrac| = 0.00e+00), 고정 36개 보존 — `verify35.py` 로 검증.
★ 34 트리가 쓴 배율과 **소수 16자리까지 동일** → 두 HSE 트리가 같은 격자 footing.
⚠ VASP CONTCAR 는 `In_d`→`In`, `H.75`→`H.` 로 잘라 쓰므로 **종 이름 복원 후** 배율 조정
  (`fixspec.py`). runtime.yaml 의 species_aliases 만 믿지 말 것.

## 계산 설정 (사용자 지정)
2 스테이지: `00_PBE-pre-G221` → `01_HSE-1shot-G221`, 둘 다 NSW=0, **std** 바이너리 6.3.2.
- **k-mesh = Gamma-centered 2×2×1** (Γ-only 아님). ISYM=0 이라 k점 4개.
  ⚠ **두 스테이지의 KPOINTS 가 반드시 같아야 한다** — WAVECAR 는 동일 k-set 에만 재시작 가능.
- HSE: AEXX 0.27 / HFSCREEN 0.2 / **PRECFOCK=Fast** / **ALGO=Normal** / EDIFF 1E-4 / ENCUT 400
- **ISPIN=2**. ⚠ 사용자는 "HSE 1shot만 ISPIN=2" 라 했으나 **00 도 ISPIN=2 로 뒀다**:
  ISPIN=1 WAVECAR 를 ISPIN=2 런이 읽으면 두 채널이 복제되고 ICHARG=0 이라 MAGMOM 도
  무시되어 그 대칭해가 SCF 고정점이 된다 → 01 의 ISPIN=2 가 무의미해진다
  ([[spin_stage_symmetry_never_broken]]). PBE 단계는 싸므로 여기서 대칭을 깬다.
  ⚠ ISPIN 을 실제로 정하는 것은 INCAR 템플릿이 아니라 **stages.yaml 의 `spin_mode`**
    (dynamic_incar 가 SPIN_MODE 를 실어 나른다). 둘 다 `magnetic_seed`.
- SLURM: g1 **12 노드 × 8 = 96 랭크/case**, **KPAR 4 × NCORE 8** (k점 4개에 정확히 대응).
  5 × 12 = 60 ≤ 61 이라 **다섯 개가 동시에** 돈다 — E_f 가 이들의 차이라 같은 머신 상태 필요.
- 잡 이름 `HSE111-<case>_q0`.

## 전자수 / PBE 참조
pure 978(짝) · Cl_As 980(짝) · Cl_MA 971(홀) · V_In_1 965(홀) · V_In_2 965(홀).
22 트리 PBE(같은 2×2×1) E_F−VBM: Cl_As **+0.894**(도너 1위) · pure 0 · V_In_1 −0.056 ·
V_In_2 −0.085 · Cl_MA −0.109. PBE mag 은 5종 전부 0.000~0.001.
★ PBE 도 2×2×1 이라 **이번엔 HSE−PBE 직접 비교가 정당**하다(34 트리는 Γ-only라 불가했다).

## ⚠ footing 경고
- PRECFOCK=Fast 잔차는 E(defect)−E(pure) 에서는 상쇄되지만 **Σn_i μ_i 에서는 안 된다**
  ([[precfock_fast_policy]]). Δn≠0 인 4종 전부 절대 E_f 가 영향받는다.
- μ 세트는 아직 ENCUT=300 / PRECFOCK=Normal 계열 → **절대 E_f 는 못 낸다.**
  지금 낼 수 있는 것은 E(defect)−E(pure) 와 그 HSE−PBE 차이.
- INCAR 태그줄의 **인라인 주석에 비ASCII 문자를 넣지 말 것**(별도 주석줄로 분리).
  이 프로젝트는 INCAR 탭 문자로 IERR=5 즉사한 전례가 있다([[surface_defect_icorelevel_bug]]).

관련: [[inas111_clma_2r3r30_tree_22]] [[hse_relax_vs_singlepoint]] [[hse_slab_scf_settings]]
[[g1_node_vasp_binary_limit]] [[run_joblist_default_sequential_trap]]
