---
name: precfock_fast_policy
description: "PRECFOCK=Fast는 ~2배 빠르고 셀 하나의 에너지는 거의 같지만 오차가 화학종마다 달라 상쇄되지 않음 — Δn=0이면 안전, Δn≠0 절대 E_f는 기준상까지 같은 footing 필요"
metadata: 
  node_type: memory
  type: project
  originSessionId: c112f7c9-ad4a-4a61-8428-865a9d3d4938
  modified: 2026-08-06T22:08:13.146Z
---

2026-08-04, 사용자 관측: **PRECFOCK=Fast가 Normal 대비 약 2배 빠르고 에너지 차이는 작다.**
→ 다른 폴더의 defect 계산에는 Fast를 쓰겠다는 방침.

## ⚠ 이 프로젝트는 같은 판단을 했다가 되돌린 적이 있다
2026-07-22에 기준상 세트를 **전부 Normal로 통일하고 fast 세트를 폐기**했다([[mu_reference_phases]]).
이유는 "fast가 부정확"이 아니라 **오차 크기가 화학종마다 달라 상쇄되지 않는다**는 것:

| fast → Normal | ΔE |
|---|---|
| H₂ | **+31.0 meV** |
| HCl | **+14.0 meV** |
| Cl₂ | **+3.8 meV** |

(참고: Cl₂ 자체 계산은 원래 fast로 돌렸었다 — [[cl2_hse06_calc]]. 그게 폐기된 세트다.)

## 판단 기준 = "Fast냐 Normal이냐"가 아니라 **"한 footing이냐"**
`E_f = [E(defect) − E(pure)] − Σnᵢμᵢ + q(E_VBM+E_F) + E_corr`
- **대괄호 항**: 같은 셀·거의 같은 조성 → PRECFOCK 오차 대부분 상쇄. **Fast 안전.**
- **Σnᵢμᵢ 항**: μ는 기준상(Cl₂/HCl/InCl₃/In metal)에서 오고 그건 **Normal로 고정**돼 있다.
  결함 셀만 Fast로 가면 **Δn≠0 결함에서 상쇄 안 되는 오차**가 남는다.

**→ 운용 규칙**
- ✅ Fast: Δn=0 결함([[dncl_zero_vcl_clas_set]] 류), 구조 이완, 밴드/DOS/IPR 분석,
  동일 설정 내 서열 비교, 스크리닝
- ⚠ Fast 금지(또는 기준상까지 Fast로 새로 갖출 것): **Δn≠0 결함의 절대 E_f**.
  기존 Normal μ 세트(μ_Cl, μ_H, μ_In)를 그대로 가져다 쓰면 footing이 깨진다.
- 새 폴더가 **자체 기준상까지 전부 Fast**면 자기정합이라 문제없다. 섞는 게 문제다.

## ⚠ 2026-08-07: `PREFOCK` 오타 — 33-inAs INCAR 126개가 사실은 Normal로 돌았다
33-inAs 하위 INCAR 126개가 `PRECFOCK` 이 아니라 **`PREFOCK`** 으로 적혀 있다. VASP은 이걸
모르는 태그로 무시하므로 실제로는 기본값 `PRECFOCK=normal` 로 실행됐다(OUTCAR에
`PRECFOCK=normal` 로 찍힘). 즉 **"Fast로 돌렸다"고 적힌 04-Chemical-reservoir(μ_As/μ_In),
01-Murnaghan-fit(a0), 일부 12-* 00_Gam-relax 는 전부 Normal footing** 이다.

→ 오히려 footing이 일관돼 있어 다행이지만, **일부 폴더에서만 오타를 고치면 그 순간 footing이
조용히 깨진다.** 고칠 때는 μ 기준상까지 한꺼번에 가거나, 안 고치고 Normal로 두거나 둘 중 하나.
확인법: `grep -rl 'PREFOCK' --include='INCAR*'` / OUTCAR의 `PRECFOCK=` 줄.

### ⚠ 오타를 고치면 이번엔 `volume.sh` 의 sed 가 되돌린다
Murnaghan 스캔용 `volume.sh` 에 이 줄이 있다:
```bash
sed -i '/^PREC/s/= *.*/= Normal/' INCAR_2.one-shots   # ← ^PREC 가 PRECFOCK 도 잡는다
```
`^PREC` 가 `PRECFOCK` 줄까지 매치해서 **`PRECFOCK = Normal` 로 덮어쓴다.** 기존 `PREFOCK`
오타는 `PREF` 로 시작해 이 sed 를 피해갔던 것. 오타를 고치는 순간 sed 에 걸려 여전히 Normal 로
돈다 — INCAR 에는 Fast 라고 적혀 있는데 OUTCAR 는 Normal 이라 눈치채기 어렵다.
고친 sed: `sed -i -E '/^PREC[[:space:]]*=/s/=.*/= Normal/' INCAR_2.one-shots`

**교훈: PRECFOCK 을 바꿨으면 반드시 OUTCAR 의 `PRECFOCK =` 줄로 확인할 것.** INCAR 은 증거가
아니다(태그 오타도, 스크립트 sed 도 조용히 무력화한다).

## 2026-08-07 실측: bulk 고유값에는 Fast가 사실상 공짜
InAs zincblende primitive(2원자), HSE06 AEXX=0.27, ENCUT=300, Γ 8×8×8, a0 고정.
`PRECFOCK` 만 바꾼 대조 (`09-Bulk-electronic_structure/02-PRECFOCK_test/`):

| | Normal | Fast | Δ |
|---|---|---|---|
| E_total | −9.383183 eV | −9.382471 eV | +0.71 meV |
| gap(Γ) | 0.4485 eV | 0.4485 eV | **+0.02 meV** |
| VBM / CBM | 3.8055 / 4.2540 | 3.8055 / 4.2541 | +0.02 / +0.04 meV |
| In 4d(Γ) | −12.404 / −12.281 | 동일 | +0.57 meV |
| wall (36 core) | 8.1 분 | 2.3 분 | **3.5×** |

29 k × 24 band 전체 shift 평균 +0.10 meV, 최대 |Δ| 1.17 meV.
→ 위 운용 규칙의 "✅ 밴드/DOS/IPR 분석에 Fast" 를 수치로 확인. 2배가 아니라 3.5배 빨랐다.

## ⛔ 반대로, **격자상수(Murnaghan) 피팅은 Fast 로 하지 말 것**
같은 볼륨 스캔 9점을 Fast 로 재실행한 결과:

| | a0 (Å) | B0 (GPa) | B0′ |
|---|---|---|---|
| Normal | 6.098297 | 58.933 | 4.451 |
| Fast | 6.096873 | 57.988 | **6.061 (+36%)** |

a0 는 1.4 mÅ 밖에 안 움직이지만 **B0′ 가 36% 튄다.** Fast−Normal 차이가 부피의 매끄러운
함수가 아니라서다 — 앞 8점은 +0.42 → +1.11 meV 로 거의 선형인데 **마지막 점에서 1.45 meV
불연속**(−0.34 meV)이 나온다. 셀 크기에 따라 FFT 그리드가 계단식으로 바뀌는 것이 유력한
원인(미확인). 선형 부분이 E(V) 를 기울여 a0 를 옮기고, 불연속이 곡률=B0′ 를 망친다.

**→ E(V)·상태방정식·응력 계열은 Normal. 고정 기하의 고유값·DOS·band 는 Fast.**

## 미측정 — 채택 전에 이것 하나는 재고 갈 것
위 수치는 전부 **작은 분자** 기준이다. **100~130원자 슬랩에서 PRECFOCK이 E_f를 얼마나
움직이는지는 측정된 적이 없다.** 대괄호 항의 상쇄가 실제로 얼마나 잘 되는지가 관건.
검증은 싸다: **pure 슬랩 1개 + 결함 1개를 두 설정으로 single-point 4번** 돌려 E_f 차이를 본다.
차이가 ≲10 meV면 Δn≠0에도 Fast 전면 채택 가능.

관련: [[hse_slab_scf_settings]](ALGO=Damped 처방), [[pbe_then_hse_workflow_plan]],
[[cl_as_negative_eform_reference_slab]](μ footing이 깨졌을 때 나타나는 증상)
