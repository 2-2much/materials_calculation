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
(바닥 2개 In-As 층 24 + pseudo-H 12), 자유 48개. `Initial_POSCARs/pure/POSCAR`.

⚠ **전단은 a 에 걸려 있다** (내가 처음 만든 b-전단 버전은 폐기). 사용자가 준
`Initial_POSCARs/par3x2.vasp` 가 기준:

```
a = 3 a_s x + 1 b_s y = (13.13064,  6.18984, 0)     <- 전단
b =         2 b_s y   = ( 0.00000, 12.37968, 0)
c =                     (0, 0, 26.26128)
|a| = 14.51647,  |b| = 12.37968,  면적 162.5531 Å²
```
축: x=[1-10] (In-As 지그재그 **사슬 방향**, a_s=4.376879), y=[001] (b_s=6.189842),
z=[110] 법선. c=26.2613 은 01 과 동일 → Cl 이 빠져 진공 11.5→**13.63 Å**.

★ **이 전단을 쓰는 이유는 최근접 image 가 아니다.** 면내 image 껍질은
12.38 / 14.52 / 22.74 / 24.76 / 26.26 Å 로, 최근접 12.38 은 직교 p3x2 와 같다.
이득은 **사슬축 image**: 순수 [1-10] 격자벡터는 6.18984m + 12.37968n = 0 →
(m,n)=(2,−1) 이라 **26.26 Å**(직교/b-전단이면 13.13). (110) 결함–결함 결합은
In-As 사슬을 타고 가므로 이쪽이 실효 거리. (100) par4x3 와 같은 논리
([[inas100_par4x3_sheared_cell]], [[inas100_dimer_row_chain]]).

⚠ 비직교라 **slabcc 불가** — 하전 결함 보정은 CoFFEE/SCPC/pydefect_2d 로.

⚠ 사용자 par3x2.vasp 원본 함정 3종 (`01-build_p1x1/fix_user_par3x2.py` 가 처리):
**모든 원자가 정확히 2번씩 중복**(168→84), 원소명이 In/As/H 로 뭉개짐(H 24개는
결합 상대로 H1.25/H.75 분리), Selective dynamics 없음. 그리고 b 가 (5.28, 11.20)
으로 x·y 혼합 → **격자만 회전**(분수좌표 유지 = 강체회전)해 b∥y 로. 면적 162.5531 불변.

## ★ 배포되는 pure/POSCAR 는 **미재구성(ideal bulk termination)**

2026-08-13 사용자 요청: 일부 결함은 **이완 안 된 표면에서 출발해야** 더 안정한 구조로
간다(pristine 버클링이 seed 를 pristine basin 쪽으로 편향시킴). 그래서 자유 In-As 층을
전부 이상적 PBE-d bulk 격자로 되돌림 → 6개 층 전부 dz(As−In)=0.
`01-build_p1x1/make_unreconstructed.py`. 기준 부격자는 가정하지 않고 **고정된 바닥
2층에서 읽어옴**(짝수 n=L1 패턴 / 홀수 n=L2 패턴, z=z1+n·d, d=2.18844 Å).

되돌린 변위(층별, bulk 로 감쇠): L6 0.308~0.672 / L5 0.054~0.095 / L4 0.027~0.050 /
L3 0.008~0.022 Å. 검증: In-As 결합 132개 **전부 정확히 2.6803 Å**(=a0√3/4),
pseudo-H 1.7757/1.5622 유지, 36 고정/48 자유, NELECT 660.

⚠ **출발 구조일 뿐**이다. pure 도 `00_Gam-relax` 를 거치므로 기준 에너지는 영향 없음
— 다시 버클링(ω=30.1°)으로 돌아간다. 바뀌는 건 generate_surface_defect.py 가 각 결함에
넘기는 seed 기하.

| 파일 | 표면 |
|---|---|
| `Initial_POSCARs/pure/POSCAR` | 미재구성, ideal bulk termination |
| `Initial_POSCARs/pure/POSCAR_relaxed` | p1x1 이완, ω=30.1°, dz=0.753 Å |

## 밴드 k-path (사교) — eta=7/18, nu=11/36

`config/KPOINTS/KPOINTS_03.Band`. `vaspkit -task 302` (2D k-path) 결과 =
Setyawan-Curtarolo MCL 공식 해석해와 정확히 일치. 2D Bravais = **Oblique**,
경로 **Γ-X-H_1-C-H-Y-Γ**, 20점/구간(고유 115 k점).

| 점 | 분수좌표 (정확값) | k (1/Å, 2π 제외) |
|---|---|---|
| X | (1/2, 0, 0) | (0.0380789, 0) |
| H_1 | (25/36, 7/18, 0) | (0.0380789, 0.0314135) |
| C | (1/2, 1/2, 0) | (0.0190394, 0.0403888) |
| H | (11/36, 11/18, 0) | (0, 0.0493640) |
| Y | (0, 1/2, 0) | (−0.0190394, 0.0403888) |

유리수로 떨어지는 이유: 전단이 정확히 b_s 하나이고 b=2b_s 라 `|a|cosγ/|b| = 1/2` 항등.
η=(1−4/11)/(2·9/11)=7/18, ν=1/2−7/36=11/36.

⚠ **07(100) par4x3 경로(η=5/18, ν=13/36)를 그대로 쓰면 안 된다.** 이 셀에 넣으면
H_1·H 가 2k·G/|G|²= **1.083 / 1.076** 로 **BZ 밖 8%** 로 튀어나간다.
원본은 `KPOINTS_03.Band.bak_07-par4x3_path` 로 보존.

★ **a_y = b_y/2 라서 결정축 두 개가 정확히 경로 위에 얹힌다**:
**Γ→X = 사슬축 [1-10]**(k_y≡0), **Γ→H = 가로지르는 [001]**(k_x≡0, H가 +y 방향 BZ 코너).
Γ→H 는 표준경로엔 없다(C→H→Y 로 도달) — 사슬내 vs 사슬간 분산 비교가 필요하면
7번째 구간으로 덧붙일 것. 전단을 고른 이유가 바로 그 비교다.

자세한 표·유도는 `config/KPOINTS/KPATH_NOTES.md`.

## 결함 12종 (02-build_defects/make_defects.py)

`Initial_POSCARs/<case>/POSCAR` (07 규약). 자리: **A33 = 표면 In(사슬1, y=7.737)**,
**A71 = 표면 As(사슬2, y=12.380)** — 두 사슬은 (110) trench 를 사이에 두고 y 로 4.643 Å.

| case | N | NELECT | 홀짝 | 결함 index |
|---|---|---|---|---|
| pure | 84 | 660 | 짝 | — |
| As_In / Cl_In / V_In | 84/84/83 | 652/654/**647** | 짝/짝/**홀** | A36 / A84 / — |
| In_As / Cl_As / V_As | 84/84/83 | 668/662/**655** | 짝/짝/**홀** | A1 / A84 / — |
| In_i1 / In_i2 | 85 | **673** | **홀** | A37 |
| Cl-In_i1 / Cl-In_i2 | 86 | 680 | 짝 | A37(In), A86(Cl) |
| Cl_i1 / Cl_i2 | 85 | **667** | **홀** | A85 |

⚠ **치환 원자는 새 종 블록의 맨 앞**에 놓인다(As_In→A36, In_As→A1) → 뒤 인덱스 전부 밀림.
격자간/흡착은 블록 맨 뒤. ⚠ **홀수 NELECT 6종은 ISPIN=2 필수**.

★ 격자간 배치: 세 원자 무게중심의 면내 위치 + **h=0**(최상층 높이). 자유파라미터 없음 —
h=0 에서 최단 접촉이 두 hollow 모두 정확히 **2.680 Å**(이상 벌크 결합).
- **In_i2 = 좋은 자리**: As 3개가 2.680 (A71,A72,A64).
- ⚠ **In_i1 = 양이온 과다**: 최근접 3개가 전부 **In** 2.680 (In 금속 3.25 대비 18% 압축).
  01/03 의 "2 In + 1 As" hollow 대응 → adatom 배출 예상([[in_i_2_adatom_ejection]]).

Cl 배치: 격자간 위 Cl 은 In-Cl 2.45 Å, 진공 반구에서 **host 기준** clearance 최대
(⚠ In_i 자신을 목적함수에 넣으면 최소값이 2.45 로 고정돼 방향이 안 정해진다 — 실제로 처음에
그 버그로 Cl 이 A36 에 2.58 Å 로 붙었었다). 표면원자 위 Cl 은 **dangling bond 방향**
(=−normalize(Σ 결합이웃 단위벡터)): Cl_i1/A33 (0,+0.577,+0.816) In-Cl 2.45,
Cl_i2/A71 (0,−0.577,+0.816) As-Cl 2.20 (AsCl₃ 2.16).

## POTCAR = 5종 하나로 통일 (개수 0 블록)

13셀 전부 `In_d/As/H1.25/H.75/Cl` 5종 블록을 갖고, 없는 종은 **개수 0**.
⚠ **ISYM=0 에서만 안전**하다 — 기본 ISYM=2 면 대칭성 setup 에서 segfault.
자세한 대조는 [[vasp_zero_count_species]]. config/INCAR 5개 전부 ISYM=0 확인됨.

## q0 밴드 결과 (2026-08-13, 7종 완료) — `03-band_analysis/`

pristine: VBM −0.506, CBM −0.056, **E_g 0.450 eV** (Γ 직접). **CB 폭 0.986 eV** —
이게 host 밴드/결함 밴드를 가르는 자다.

| 결함 | 갭 밴드 | E 범위 | 폭 | 점유 | 투영배율 | 판정 |
|---|---|---|---|---|---|---|
| As_In | 327 | −0.023…+0.790 | 0.813 | 빔 | 3.2× | host CB, **갭 준위 없음** |
| Cl_In | 328 | −0.167…−0.102 | 0.066 | **빔** | 14.0× | **완전히 빈 깊은 준위**(VBM+0.35) → 억셉터쪽 |
| V_In | 324 | −0.262…+0.066 | 0.328 | **부분** | 4.5× | **반점유** As dangling bond |
| In_As | 334 | −0.688…−0.343 | 0.344 | **참** | 9.7× | **채워진 준위**가 갭에 진입 → 도너쪽 |
| Cl_As | 331 | −0.198…+0.549 | 0.747 | **부분** | 2.0× | 비국소, **얕은 도너** |
| V_As | 328 | −0.356…−0.133 | 0.223 | **부분** | 9.4× | **반점유** In dangling bond |
| In_i1 | 337 | +0.077…+0.593 | 0.515 | **부분** | 14.5× | In adatom 공명, 도너 |

★ **Cl_In 이 07 (100) 과 같은 서명**을 낸다 — 갭 한가운데 완전히 빈 준위. IPR 게이트가
HOMO 만 봐서 놓치는 유형([[inas100_par4x3_q0_results]]).
★ **V_In 은 억셉터다.** band-filling 스크립트가 "donor, CB 전자 0.734" 로 분류했지만
그건 결함 밴드를 host CB 로 오인한 것 — 폭 0.33 vs host 0.99, As 이웃 무게 4.5배.
전자수 세기(표면 In 제거 → As dangling bond 3개가 6e 자리에 3.75e)와도 맞는다.
⚠ **그 −0.111 eV band-filling 값을 인용하지 말 것.**

★ **In_i1 은 예상대로 adatom 으로 배출됐다**: In 이 z +1.009 Å(18.602→19.496) 올라가고
In-In 접촉이 2.680 → 3.38~3.60 으로 열림, 이제 As 하나와 2.83 Å. 01/03 과 동일
([[in_i_2_adatom_ejection]]). V_In 은 As 이웃이 1.359 Å 움직이는 국소 재배열.

⚠ **03_Band 의 E_F 는 무의미하다** — ICHARG=11 line-mode 는 경로만 샘플링해서 페르미
준위가 대표성 없는 k집합에 맞춰진다(Cl_As +0.513, In_i1 +0.531 = CBM 위 0.57 eV).
준위와 점유수만 읽을 것.
⚠ 폭 0.2~0.5 eV 는 상당부분 **결함-결함 분산**이다(최근접 image 12.38 Å). 전단은
사슬축만 26.26 Å 로 밀었다.

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
