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

## 계산 설정 (확정, 2026-08-31)
2 스테이지: `00_PBE-pre-gam` → `01_HSE-gam-1shot`, 둘 다 NSW=0, **gam** 바이너리 6.3.2.
- **k-mesh = Γ-only.** ⚠ **두 스테이지의 KPOINTS 가 반드시 같아야 한다** —
  WAVECAR 는 동일 k-set 에만 재시작 가능.
- HSE: AEXX 0.27 / HFSCREEN 0.2 / **PRECFOCK=Fast** / **ALGO=Normal** / EDIFF 1E-4 / ENCUT 400
- **ISPIN=1 (두 스테이지 모두).** 5종 전부 비자성이 확인되어 있다: 22 트리 PBE 에서
  mag 0.000~0.001, 이 트리 `__attempt2_G221-ISPIN2__` 의 PBE 단계에서도 0.0000~0.0001.
  ⚠ ISPIN 을 실제로 정하는 것은 INCAR 템플릿이 아니라 **stages.yaml 의 `spin_mode`**
    (dynamic_incar 가 SPIN_MODE 를 실어 나른다). 둘 다 `nonmagnetic`.
  ⚠ 만약 ISPIN=2 가 필요해지면 **00 도 반드시 ISPIN=2 로** 해야 한다. ISPIN=1 WAVECAR 를
    ISPIN=2 런이 읽으면 두 채널이 복제되고 ICHARG=0 이라 MAGMOM 도 무시되어 그 대칭해가
    SCF 고정점이 된다 → 01 의 ISPIN=2 가 무의미해진다 ([[spin_stage_symmetry_never_broken]]).
- SLURM: g1 **28 노드 × 8 = 224 랭크/case**, Γ-only 이므로 **KPAR 1 × NCORE 8** = 28 밴드그룹.
  ⚠ 5 × 28 = 140 > 61 이라 **동시에 두 개까지만** 돈다. 34 트리 주석의 "전부 동시 실행"
    조건은 여기서 못 지킨다. NSW=0 단일점이라 재현성 문제는 없지만 **큐가 다 빌 때까지
    config/ 를 건드리지 말 것** (케이스마다 footing 이 갈린다).
- 잡 이름 `HSE111g-<case>_q0`. 잡 13612~13616.

## 시도 이력 (전부 `calc/<case>/q0/__attempt2_G221-ISPIN2__/` 에 보존)
1. G221 + ISPIN=2 + 12노드 → 사용자가 "너무 비싸다" 로 취소. PBE 단계 mag 0.0000~0.0001 기록.
   (그 안의 `__loginnode_killed__00_PBE-pre-G221` 은 [[run_joblist_default_sequential_trap]] 사고분.)
2. **현행**: Γ-only + ISPIN=1 + 28노드.

## 전자수 / PBE 참조
pure 978(짝) · Cl_As 980(짝) · Cl_MA 971(홀) · V_In_1 965(홀) · V_In_2 965(홀).
22 트리 PBE(같은 2×2×1) E_F−VBM: Cl_As **+0.894**(도너 1위) · pure 0 · V_In_1 −0.056 ·
V_In_2 −0.085 · Cl_MA −0.109. PBE mag 은 5종 전부 0.000~0.001.
⚠⚠ 위 PBE 값은 **2×2×1** 이고 이 트리는 **Γ-only** 다 — 그대로 비교하면 안 된다.
21 트리에서 같은 기하로 k 만 2×2×1↔Γ 로 바꿨을 때 ΔE(결함−pure) 가 종별로 **0.5~0.83 eV**
움직였고 상쇄되지 않았다 ([[inas111_cl_ma_p4x3_tree]] 함정 1).
★ HSE−PBE 비교에는 **이 트리의 `00_PBE-pre-gam`** 을 쓸 것 — 같은 Γ, 같은 HSE 격자라
  k-set 과 격자가 동시에 통제된 유일한 PBE 기준값이다. 이게 00 단계의 두 번째 용도다.

## ⚠ footing 경고
- PRECFOCK=Fast 잔차는 E(defect)−E(pure) 에서는 상쇄되지만 **Σn_i μ_i 에서는 안 된다**
  ([[precfock_fast_policy]]). Δn≠0 인 4종 전부 절대 E_f 가 영향받는다.
- μ 세트는 아직 ENCUT=300 / PRECFOCK=Normal 계열 → **절대 E_f 는 못 낸다.**
  지금 낼 수 있는 것은 E(defect)−E(pure) 와 그 HSE−PBE 차이.
- INCAR 태그줄의 **인라인 주석에 비ASCII 문자를 넣지 말 것**(별도 주석줄로 분리).
  이 프로젝트는 INCAR 탭 문자로 IERR=5 즉사한 전례가 있다([[surface_defect_icorelevel_bug]]).

## ★ 결과 (2026-08-31, 잡 13612~13616, case당 14~17분)
5종 전부 정상 수렴 — dE·rms 단조 하강, SCF 9~12스텝(NELM 150), ALGO=Normal limit-cycle 없음.
OUTCAR 로 `PRECFOCK = Fast` 확인(INCAR 아님).

**E(sigma->0), eV**

| case | 00 PBE Γ | 01 HSE Γ | HSE−PBE 의 ΔE(결함−pure) |
|---|---|---|---|
| pure | −537.342279 | −651.856620 | — |
| Cl_As | −535.271289 | −648.606932 | +1.179 |
| Cl_MA | −503.169926 | −611.506766 | +6.178 |
| V_In_1 | −532.512851 | −645.701445 | +1.326 |
| V_In_2 | −532.337460 | −645.623575 | +1.228 |

### ★ μ 없이 읽히는 유일한 비교 — V_In_2 − V_In_1 (조성 완전 동일)
| | 값 | 판정 |
|---|---|---|
| 22 트리 PBE-d격자 2×2×1 | +0.142 eV | V_In_1 이 142 meV 안정 |
| 35 트리 HSE격자 PBE Γ | +0.175 eV | 175 meV |
| **35 트리 HSE격자 HSE Γ** | **+0.078 eV** | **78 meV** |
★ 세 조건 모두 **V_In_1(남은 Cl 을 제자리에 둔 쪽)이 이긴다.** Γ-only 오차가 이 비교에서는
33 meV 뿐(142 vs 175) — 두 셀이 거의 같아 오차가 상쇄되기 때문. **HSE 78 meV 는 신뢰 가능.**

### ★ 준위 (슬랩내부 정렬, pure VBM=0). 같은 Γ·격자·기하 → 순수 범함수 효과
| | pure 갭 | Cl_As HOMO | Cl_MA | V_In_1 | V_In_2 |
|---|---|---|---|---|---|
| PBE Γ | 0.238 | **−0.031** | +0.062 | +0.089 | +0.076 |
| **HSE Γ** | **1.024** | **+0.651** | +0.099 | +0.149 | +0.129 |
| Δ(HSE−PBE) | +0.786 | **+0.682** | +0.037 | +0.060 | +0.053 |
★ HSE 가 **Cl_As 의 점유준위만 0.68 eV 끌어올린다**(나머지 셋은 0.06 eV 이내).
  HSE 에서 Cl_As HOMO 는 갭의 **64 % 위치**(LUMO 아래 0.37 eV) = 도너 성격 유지·강화.
  나머지 셋은 HOMO 가 VBM 바로 위(+0.10~0.15) = 억셉터 쪽. **PBE 의 도너/억셉터 순서가 유지된다.**
⚠ VASP E_F 는 갭이 열린 셀에서 갭 안 임의 위치이므로 **E_F 가 아니라 HOMO/LUMO 로 읽을 것.**

## ⚠⚠ Γ-only 의 한계 — Cl_As 는 이 트리로 결론내지 말 것
같은 PBE 로 [22 트리 2×2×1, PBE-d격자] 와 [35 트리 Γ, HSE격자] 를 비교하면:
- ΔE(결함−pure) 차이: **Cl_As +0.952 / V_In_1 +0.259 / V_In_2 +0.225 / Cl_MA +0.139 eV**
  → 종별로 다르므로 **상쇄되지 않는다**. Γ-only 절대 ΔE 는 Cl_As 에서 ~1 eV 오차.
- Γ점 HOMO 도 Cl_As 만 **+0.592 → −0.031 (0.62 eV)** 어긋난다. 나머지 셋은 0.16 eV 이내.
- 22 트리 2×2×1 은 Cl_As 준위가 **CB 안**(갭 0.053 대비 +0.592)이라 했고, 35 트리 HSE Γ 는
  **갭 64 %** 라 한다. 둘 다 "도너" 지만 **깊이가 다르다.**
⚠ k-set 과 격자(−1.48 %)가 **동시에** 바뀌어 confounded. 분리하려면 HSE 격자에서
  **PBE 2×2×1** 을 한 번 돌리면 된다(~20분). 그게 없으면 원인 귀속 불가.
★ 권고: Cl_As 의 HSE 도너 깊이를 확정하려면 **pure + Cl_As 2종만 HSE 2×2×1** 로
  (2 × 28 = 56 ≤ 61 노드, 동시 실행 가능).

관련: [[inas111_clma_2r3r30_tree_22]] [[hse_relax_vs_singlepoint]] [[hse_slab_scf_settings]]
[[g1_node_vasp_binary_limit]] [[run_joblist_default_sequential_trap]]
