---
name: mote2-mlff-md-plan
description: ★MoTe2 V_Te MLFF-MD 설계 (04-MD). 7x4 직교셀·G 2x2x1 확정·★ML_MODE=train은 ISIF=0/1이면 즉사·온도전략(pristine은 상한만, 스캔은 ML_MODE=run)
metadata:
  type: project
---

**목표 (2026-09-13~15)**: STM tip voltage pulse로 만들어지는 **V_Te 근처 1T'-like
metastable 원자구조**를 찾는 것. 실험 협업 — Mo0.95W0.05Te2에서 pulse 후 V_Te 부근
**~27°(≈30°) 회전**이 관찰되고, **pulse 전에 이미 Te vacancy가 보인다.**

> ⚠ **정확한 총에너지(defect formation energy)가 목적이 아니다.** 사용자가 명시:
> "1T'-like하게 바뀐 distorted V_Te metastable 원자구조를 찾아내는 것"이 목적.
> 이 우선순위가 아래의 모든 타협(Γ/2x2x1, LREAL=A, PREC=N)을 정당화한다.

## 셀 — `04-MD/POSCARs/POSCAR_2H_rectangle_7x4*.vasp`

hexagonal 5x5(17.52 Å)는 **교수님 피드백으로 폐기** — distortion 기술에 너무 작다.
대신 7x4 orthohexagonal:

```
a = 24.5179290771   b = 24.2664623260   c = 23.6176548004   (직교)
Mo 56 / Te 112 = 168 atoms.  이상셀: Mo-Te 2.7172 / Mo-Mo = Te-Te 3.5026 Å
```

- **V_Te = Te71 = 절대 127번** (nMo=56). 프랙 [0.50000006, 0.54166663, 0.57684737].
- 링 6개(윗층 Te, 전부 r=3.5026 Å), **시계방향** 순환:
  `99 -> 103 -> 75 -> 102 -> 98 -> 67 -> 99` (번호는 **삭제 전 원본** Te 번호).
- `distort_V_Te` = 각 링 원자를 다음 이웃 쪽으로 **정확히 절반**(1.7513 Å) 이동.
  결과: 링 반경 3.5026 -> **3.0333 Å** (= 3.5026·cos30°), 각도 0/60/... -> **30/90/...**
  즉 **30° 회전한 pinwheel**. Mo-Te 최단 2.0776 Å, 링 Te 6개가 전부 CN=1.

⚠ m,n 둘 다 짝수라야 1T' 세 배향이 다 들어간다. 7x4는 **7이 홀수** → 배향 하나를
미리 고른 셀이다. 4x4 replication(28x16)이면 셋 다 가능.

## 확정된 계산 조건

| 항목 | 값 | 근거 |
|---|---|---|
| KPOINTS | **G-centered 2x2x1** | 사용자 결정 2026-09-15. Δk≈0.128 Å⁻¹ |
| 바이너리 | **std** (gam 불가) | 2x2x1은 복소 파동함수 |
| KPAR / NCORE | **4 / 12** | k점이 정확히 4개. 48 tasks = 4 k-group x 12 core |
| **ISIF** | **2** | ★아래 블로커 |
| ISYM | **0** | 대칭을 켜면 힘이 묶여 우리가 찾는 대칭 깨짐이 봉쇄됨 |
| MDALGO | 3 (Langevin) | `LANGEVIN_GAMMA = 5.0 5.0` (POTCAR 순 Mo Te). ergodic, SMASS 불필요 |
| ISTART/ICHARG | 0 / 2 | LWAVE=.F., LCHARG=.F.라 WAVECAR이 애초에 없다 |
| POTIM | 2.0 fs (>1500 K는 1.5) | Mo 96 / Te 128 amu. 2100 K에서도 Te 열속도 0.007 Å/fs |

### ★ 블로커 — ISIF=0이면 시작하자마자 죽는다

바이너리(`vasp.6.5.1.dftd4.wan90.beef.plugin.lhfskip.std.x`)의 문자열 그대로:
```
ML_INTERFACE: ERROR: ML_MODE = train is not possible with ISIF = 0 or 1
              because the stress tensor is required, exiting ...
```
`2H-defect/config/INCAR/INCAR_0{0,1,2,3}`와 `04-MD/01-distort_V_Te/INCAR`가 **전부
ISIF=0**이다. 복사해 올 때 제일 먼저 고칠 것. ISIF=2는 셀 고정 + stress만 계산.

`ICONST`는 **ISIF=3(NpT)에서만 작동**하므로 지금은 무의미. 그리고 단층막+진공 셀에
NpT를 걸면 진공이 붕괴하므로 **ISIF=3 금지.**

### ML_AB 동질성 (하나의 DB 안에서 전부 동일해야 함)

`ENCUT=400`, `PREC=N`, `ALGO=Normal`, `EDIFF=1E-6`, `ISMEAR=0`, `SIGMA=0.1`,
`IVDW=13`, `LREAL=A`, `LASPH=.T.`, `LMAXMIX=4`, ISPIN=1, POTCAR(Mo_sv, Te),
**그리고 k-그리드**. ⚠ "2x2x1"이라는 이름이 같아도 **셀 크기가 다르면 Δk가 다르다** —
1T/1T' 셀도 같은 7x4 직교 크기여야 한다. 한 번 오염되면 refit으로도 복구 안 된다.

`ML_MODE=train`은 폴더에 `ML_AB`가 있으면 **자동으로 이어서 학습**한다.
스테이지 연결 = `ML_ABN -> 다음 ML_AB`, `CONTCAR -> 다음 POSCAR`(속도 블록 포함).

## ★ 온도 전략 — 순서를 뒤집어야 한다

사용자 제안: "pristine 먼저 학습하고 온도를 엄청 높여서 깨지는 지점을 보자."
**절반 맞다.**

- **맞는 절반**: 학습 궤적 자체가 목표 온도 범위를 훑어야 한다. FF는 본 적 없는
  배치를 예측 못 한다. 300 K 학습 FF로 1500 K MD를 돌리면 자신 있게 틀린다.
  그러니 학습 = 온도 램프. 두 목적이 계산 하나다.
- **틀린 절반**: **pristine이 깨지는 온도는 쓸 온도가 아니다.** pristine이 깨지는 건
  Te 탈착/골격 융해다. V_Te 주변 재배열은 훨씬 낮은 온도에서 일어난다. pristine 값은
  **"여기 위로 가지 마라"는 상한**일 뿐, 작업온도는 결함 셀에서 다시 정한다.
- **정작 온도 스캔은 AIMD로 하면 안 된다.** 7~10번 돌릴 작업인데 AIMD 1 ps가 며칠이다.
  **학습 -> `ML_MODE=run`으로 스캔**이 순서. FF를 쓰는 이유가 이것이다.

pristine을 먼저 하는 건 맞다. 단 이유가 다르다 — Mo-Te/Mo-Mo/Te-Te 거리 분포의
뼈대를 싸고 안전하게 깐다. FF가 아직 무지할 때 결함 셀부터 들이대면 초반 수백 스텝의
쓰레기 배치가 ML_AB에 박힌다.

### 예상 온도 창 — `Ea ≈ 5.3 kT` (ν=10¹³ s⁻¹, t=20 ps, 결함 1개)

| Ea | 필요 T |  | MoTe2 2H->1T' 장벽이 0.6~0.9 eV/f.u. 급 |
|---|---|---|---|
| 0.3 eV | ~660 K | | → **의미 있는 창 ≈ 1000~1800 K** |
| 0.5 eV | ~1100 K | | 300 K에서 아무 일 없는 건 정상 |
| 0.8 eV | ~1750 K | | |

MD는 유한온도라 **랜덤 변위로 대칭을 깨줄 필요가 없다** (0 K relax와 다른 점).
단 초기 T는 등분배 때문에 TEBEG의 **절반**에서 시작한다.

### 깨짐 판정 지표 (순서대로 민감)

1. `nfree` — Mo 이웃(3.4 Å) 없는 Te 개수. **>0이면 즉시 중단.** Te 탈착은 비가역이고,
   "고립 Te가 진공에 떠다니는" 배치는 FF에 독이다.
2. `dz` — max |z(Te) − ⟨z(Mo)⟩|. 이상적 2H = **1.815 Å**.
3. Mo 부분격자 Lindemann 비 `sqrt(<u²>)/3.5026` — <0.10 고체 / >0.15 융해.
4. **φ = Mo당 prismatic↔octahedral 비틀림 각** (0° = 2H, 60° = 1T/1T').
   ★국소적이고 셀 크기에 무관한 진짜 order parameter.

## 문헌

[Kinetics of vacancy-assisted reversible phase transition in monolayer MoTe2],
Communications Materials 2026, [arXiv:2507.12565] — WebSearch로 실재 확인. SCAN MLIP.
**기구: Te monovacancy가 이웃끼리 합체해 divacancy가 되고, divacancy는 이동성이 있어
작은 삼각형 1T' 섬을 만든다.** diffusive + diffusionless 둘 다.
→ 함의: **V_Te 하나로는 핵생성이 안 될 수 있다.** 인접 V_2Te가 더 유망한 씨앗이고,
우리 `distort_V_Te` pinwheel은 문헌 기구와 **다른 motif**다. 실험의 "pulse 전 Te
vacancy 존재"와는 잘 맞는다. ⚠ SCAN vs 우리 PBE+D3 → 문턱값은 전이되지 않는다.

## 비용 실측 (기준: `V_Te/q0/01_relax_nsp`, 74원자·5 irred. k·ISPIN=1, ~72 s/step)

| 셀 | k | s/step | 1 ps @ 2 fs |
|---|---|---|---|
| 167원자 Γ-only, gam | 1 | ~55 | ~7.6 h |
| **167원자 2x2x1, std** | 4 | **~430** | **~2.5 일** |

2x2x1은 k 4배 + **gam을 못 쓰는 2배 = 8배**. KPAR=4가 이걸 대부분 되돌린다.
on-the-fly라 FF가 학습되면 DFT 호출이 1~5%로 떨어지는 것이 구원.
NELECT(V_Te 셀) = 56x14 + 111x6 = **1450**, 기본 NBANDS ≈ 808.

## 파일 위치 ⚠ 서버 주의

- **kohn**: `~/materials/moTe2/04-MD/input_POSCARs/` — 2H pristine/V_Te/distorted_V_Te
  + 1T pristine/V_Te. (1T' pristine은 예정) + INCAR/KPOINTS/POTCAR. **여기서 실행한다.**
- **bloch**: `~/materials/moTe2/04-MD/POSCARs/`(2H 3종), `01-distort_V_Te/`,
  그리고 2026-09-15에 내가 만든 **`01-Train/` 초안**(pristine 2단계 램프 + md_monitor.py
  + chain.sh + README). 사용자 허락 없이 만든 것이라 **폐기 여부 미정**.
- ⚠ `~/materials/.gitignore`가 `*`라 **계산 파일은 서버 간 동기화 안 된다**
  ([[server_fs_git_sync_scope]]). hostname은 4대 전부 `tgm-master.hpc`라 쓸모없고,
  **`hostname -A` 또는 파티션 이름**으로 판별한다(cascade계열=kohn, g계열=sham/bloch).

## 미해결

- 1T/1T' 셀이 7x4와 **같은 크기**인지 확인 필요 (Δk 일치 조건).
- 인접 V_2Te 씨앗을 7x4에 만들 것인가 (문헌 기구).
- strain·W 치환 학습 가지, production 셀 크기.
- 미수렴/멈춘 잡 2건: `2H-defect/calc/V_Te/q-1/02_relax_sp`(72 ionic step 미수렴),
  `distort_V_Te/q-1/01-T1/00_gam-relax_nsp`(OUTCAR 미종료).
- 템플릿/계산 drift: `calc/V_Te/q0/02_relax_sp/INCAR`가 EDIFF=1E-4·KPAR=1로 구세대.

관련: [[mote2_vte_defect_setup]] [[mote2_vte_size_scan_results]] [[mote2_gamma_vs_mesh_measured]]
