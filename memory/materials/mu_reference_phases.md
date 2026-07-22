---
name: mu_reference_phases
description: "HSE06(AEXX=0.27,ENCUT300) 기준상 세트 — 2026-07-22 PRECFOCK=Normal로 통일 확정. mu_H/mu_Cl(Cl2/HCl/InCl3) + In metal + mu_Cl 접근가능 범위(InCl3 pinning)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 21ba4701-12fb-4582-8d69-24cecc9e027f
  modified: 2026-07-22T03:48:22.831Z
---

## 기준상(reference phase) 세트 — 2026-07-22 **PRECFOCK=Normal로 통일 확정**

경로: `33-inAs/__Ligands_and_Chemicals__/`, 요약 스크립트 **`mu_summary_pfN.py`**(신규, Normal).
결정: 04 결함 슬랩도 Normal, In metal도 Normal이므로 **전 계산을 Normal 하나로 통일**(fast 폐기).
분자 3종은 `12-HSE06-Gamma/**ENCUT300_pfN/**`에 재계산(원본 fast는 `ENCUT300/`에 보존).

**공통 footing**: 분자=30 Å 박스·Γ-only·LHFSKIP·ISMEAR=0/0.05·PBE 스테이징;
In metal=In_d PAW·14³ MP·ISMEAR=1/0.1·BM fit E0. 공통=HSE06 AEXX=0.27/HFSCREEN=0.2,
ENCUT=300, PREC=N, **PRECFOCK=Normal**. POTCAR: H 15Jun2001, Cl 06Sep2000, In_d 06Sep2000.

| phase | E(σ→0) [eV] | d(Å) | fast→Normal |
|---|---|---|---|
| H₂ | −7.87848497 | 0.745 | +31.0 meV |
| Cl₂ | −5.39207196 | 1.965 | +3.8 meV |
| HCl | −7.62774012 | 1.277 | +14.0 meV |
| InCl₃(g, D3h) | −14.95557020 | 2.292 | +6.7 meV |
| In(metal) | **−2.94160264** (BM E0) | — | (원래 Normal) |

- **μ_H = −3.939242 eV**
- **μ_Cl(Cl₂) = −2.696036 eV** ← Cl-rich 극한, Δμ_Cl ≡ 0 (**상한**)
- **μ_Cl(HCl+H₂) = −3.688498 eV**, Δμ_Cl = −0.992
- **μ_Cl(InCl₃ g + In metal) = −4.004656 eV**, Δμ_Cl = **−1.309** (In-rich)
- 검증: ΔE_f(HCl) calc −0.9925 vs 실험 −0.9865 → **오차 −6.0 meV** (Normal도 신뢰 OK)

## μ_Cl 접근가능 범위 — **InCl₃ pinning** (2026-07-22 확립)

passivated 표면은 μ_In+3μ_Cl ≤ E(InCl₃) 구속. In이 있으면 상한이 min(½E(Cl₂),
[E(InCl₃)−μ_In]/3)인데 **InCl₃ 항이 항상 이김** → **Cl₂ 포화(Δμ=0)엔 절대 도달 못 함**.
Δμ_Cl^min(In-rich) = ΔH_f(InCl₃)/3. InCl₃(g) 형성 ΔH_f = −3.926 eV.

| 기준 | Δμ_Cl (In-rich) | Δμ_Cl (As-rich) |
|---|---|---|
| **gas-monomer InCl₃** (DFT 자체정합) | −1.31 | ~−1.15 |
| **solid InCl₃** (실험 ΔHf≈−5.57, 병기) | −1.86 | ~−1.70 |

폭 ~0.16 eV = |ΔH_f(InAs)|/3 (In-rich↔As-rich μ_In 스윕). 사용자 결정=**두 기준 병기**(밴드로).
⚠gas-monomer가 CQD 리간드엔 오히려 더 물리적일 수 있음(고체 격자에너지 없음); 용액이면 더 낮아짐.

**04 음의 형성에너지 해소**: 지금 04는 Δμ_Cl=0을 잘못 씀 → 실제 −1.1~−1.9 밴드 구속 넣으면
Δn_Cl=+1 결함 음수 일괄 해소, 서열 재정렬([[cl_as_negative_eform_reference_slab]] 예측 일치).

## ⏭ 남은 것: As-rich 끝 정밀화
위 밴드 As-rich 끝(폭 0.16 eV)은 |ΔH_f(InAs)|≈0.49 eV를 **bulk-defect footing**으로 추정.
정확히 하려면 **InAs bulk + As(A7)를 이 AEXX=0.27/ENCUT=300/Normal footing으로 계산** 필요.
In metal은 확보됨(`01-In/PBE-d_HSE06_AEXX27/`, BM_fit_result.dat).

## ⚠ 함정 (보존)
- **PRECFOCK 종별 민감도 다름**: fast→Normal 이동이 H₂ +31 vs Cl₂ +3.8 meV로 제각각 →
  차이가 상쇄 안 됨(그래서 통일 필요). 이전 fast 세트(μ_H=−3.954737, μ_Cl(Cl₂)=−2.697957)는 폐기.
- **바이너리**: g2는 `...dftd4...gam.x`, **cascade엔 dftd4 빌드 없음** →
  `vasp.6.5.1.wan90.beef.plugin.lhfskip.gam.x` 사용. HCl/InCl3 run.sh가 dftd4 경로면 execvp 즉사.
  (INCAR에 분산력 태그 없으면 두 바이너리 결과 동일). cascade 메모리 눌린 노드 OOM 방지 `--exclusive`.
- **In metal `results_BM.txt`의 "error vs exp"는 무시**: In을 FCC로 가정해 V0→a0=(4V0)^⅓ 변환한
  아티팩트(a0 −21.8%). 실제는 tetragonal a=3.2605Å(+0.25%), V0/atom 26.59(+1.6%), B0 40.7GPa≈실험.
  폴더 OUTCAR는 BM a0 아니라 볼륨스캔 마지막점(scale 1.040); μ_In엔 BM E0 −2.9416 사용.
- **10-InCl3는 고체 아닌 기체 단분자**(실제 기체는 In₂Cl₆ 이량체 우세). 상별 μ_Cl 서열 = 단분자>고체>용액.
