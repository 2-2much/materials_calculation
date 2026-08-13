---
name: inas110_bare_par3x2_pure_cell
description: "11-110bare 프로젝트 pristine 셀 확정 — p1x1 이완 후 전단 par3x2로 타일링. ω=30.1°/dz=0.753Å, slabcc 불가"
metadata: 
  node_type: memory
  type: project
  originSessionId: 912d3380-abf1-4022-b597-7a4dafc645fc
  modified: 2026-08-13T04:17:59.513Z
---

2026-08-13. `12-Surace-defect_calculation/11-110bare_6L_par3x2_PBE-d/` 의 pristine
reference cell 구축. 빌드 트리 = `01-build_p1x1/` (README.md 에 전체 기록).

## 확정된 셀

**par3x2, 84원자** (36 In_d / 36 As / 6 H1.25 / 6 H.75), NELECT=660, 36개 고정
(바닥 2개 In-As 층 24 + pseudo-H 12). `Initial_POSCARs/pure/POSCAR`.

```
A  = 3 a_s x         = (13.13064,  0.00000, 0)
B' = a_s x + 2 b_s y = ( 4.37688, 12.37968, 0)     <- 전단
C  =                   (0, 0, 26.26128)
|A| = |B'| = 13.13064 Å,  gamma = 70.529°
```
축: x=[1-10] (In-As 지그재그 **사슬 방향**, a_s=4.376879), y=[001] (b_s=6.189842),
z=[110] 법선. c=26.2613 은 01 과 동일 → Cl 이 빠져 진공 11.5→**13.63 Å**.

⚠ **전단은 사용자 선택.** 직교 p3x2 대비 이득은 최근접 image 12.38→**13.13 Å 뿐**
(면적·원자수 동일). 대가로 **slabcc 불가** — 하전 결함 보정은 CoFFEE/SCPC/pydefect_2d
로 가야 함. (100) par4x3 와 같은 상황: [[inas100_par4x3_sheared_cell]]

## 왜 p1x1 을 먼저 이완했나

자유원자 8개 vs 48개 → k 수렴 스캔이 공짜. 결과 (PBE-d, 01/03 production footing,
ENCUT300/PREC N/LREAL A/ISYM 0/dipole OFF, ISPIN=1, EDIFFG=−0.01):

| | ω | dz(As−In) | max Δr vs k961 | wall |
|---|---|---|---|---|
| k3x2x1 (= p3x2 의 Γ-only) | 29.9° | 0.747 | 0.0100 Å | 40 s |
| k6x4x1 | 30.1° | 0.753 | 0.0014 Å | 95 s |
| **k9x6x1** ← 채택 | 30.1° | 0.753 | — | 164 s |
| k6x4x1 LREAL=.FALSE. | 30.0° | 0.750 | 0.0049 Å | 69 s |

- **ω=30.1°, dz=0.753 Å** = III-V(110) 교과서값(29~31°). 하부 반대버클링
  L5 −0.139 / L4 +0.068 / L3 −0.022 로 감쇠.
- Γ-only(3x2 셀)가 0.010 Å 차 → production `00_Gam-relax` 로 충분
  ([[gamma_relax_adequacy_par4x3]] 와 일관).
- **LREAL=A 는 14원자 셀에서도 무해**(0.005 Å). footing 안 깨짐.

## ★ 초기구조 함정 — Cl 이완 기하는 버클링 부호가 반대

Cl-passv CONTCAR 를 깎아 Cl 만 지우면 dz(As−In)=**−0.35 Å** (Cl 이 표면 In 을 위로
당김). Bare 는 +0.75 로 **부호가 반대**. 그렇다고 표면 사슬을 강체회전시키면
In back-bond 이 **2.31 Å 로 압축**되어 망가진다 (In 이 아래로만 내려가고 면내로
안 비켜서). 해법 = 실제 이완된 bare 슬랩에서 변위장을 떠옴:
`33-inAs/02-LDA/defective_slab/110bare_p2x3_As_In_bulk2.vasp/01-LDA/CONTCAR` (8L LDA),
자기 고정 bulk 부격자 기준 측정 후 a0 비(6.189842/6.061944)로 스케일.

| 층 | 면내(+ = 아래층 back-bond 짝 쪽) | dz |
|---|---|---|
| top In | −0.437 | −0.514 |
| top As | +0.191 | +0.245 |
| 2nd In | +0.027 | +0.093 |
| 2nd As | −0.024 | −0.053 |

## 검증

- pseudo-H 결합이 01·03 과 **완전 동일**: In–H1.25 = **1.7757 Å**, As–H.75 =
  **1.5622 Å** (고정 원자를 그대로 옮기므로 구조적으로 보장, 양쪽 pure CONTCAR 로 대조).
- 타일 셀 In-As 결합 132개, 2.648~2.711 Å (bulk 2.680). 132 = 36×4 − 6(top In 3배위)
  − 6(bottom In 의 4번째는 H).
- `validate_par3x2/` NSW=0 Γ2x2x1: 자유원자 max|F| = **0.022 eV/Å**. 타일링이 진짜
  수퍼셀임을 확인(어긋났으면 eV/Å 급). 잔차는 k-샘플링(2x2x1 ≪ 9x6x1).

⚠ VASP CONTCAR 는 원소명을 2글자로 자른다("In","H1","H.") → POTCAR 순서로
In_d/As/H1.25/H.75 복원 필요 ([[species_aliases_mechanism]]).

관련: [[inas100_par4x3_sheared_cell]] [[surface_defect_dipole_correction]]
[[slabcc_delocalized_defect_policy]] [[inas100_pseudoh_lasph_footing]]
