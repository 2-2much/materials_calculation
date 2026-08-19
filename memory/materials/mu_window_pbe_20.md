---
name: mu_window_pbe_20
description: "★Δμ_Cl=0(½Cl₂)은 금지 영역이다 — InCl₃(s) 상한 −1.52(PBE)/−1.64(D3)/−1.86(실험) eV. PBE는 층상 InCl₃ 부피를 +17% 부풀린다(전부 c축). In(OAc)₃는 tris-bidentate 최저지만 기체단량체라 Δμ_AA 상한은 헐겁다"
metadata:
  type: project
---

트리 = `33-inAs/__Ligands_and_Chemicals__/20-mu_window_PBE/`. 2026-08-19 완료.
결과 = `results/mu_window.md`, `results/cpd_mu_window.png`, `results/DFE_07_mu_window.csv`.

## ★ 결론: ½Cl₂ 는 물리적 Cl-rich 극한이 아니다

`Δμ_In + 3Δμ_Cl ≤ ΔH_f(InCl₃,s)` 가 Δμ_Cl 상한을 **−1.5 eV 근처로 끌어내린다.**

| 기준 | ΔH_f(InCl₃,s) | Δμ_Cl 상한 In-rich / As-rich |
|---|---|---|
| PBE | −4.556 | **−1.519 / −1.357** |
| PBE+D3(BJ) | −4.924 | −1.641 / −1.479 |
| PBE+D4 | −4.956 | −1.652 / −1.490 |
| 실험 ΔH_f (−537.2 kJ/mol) | −5.568 | −1.856 / −1.694 |

→ Δn_Cl>0 결함의 E_f 는 지금 값보다 `|Δμ_Cl^max|×Δn_Cl` 만큼 **올라가고**, V_Cl(Δn=−1)은
그만큼 **내려간다**. 07 트리 q0 실측: Cl-As_In −0.01→+1.51, Cl_In −0.71→+0.81,
**V_Cl 2.14→0.62(PBE pin)/0.28(exp pin)**. 표 전체는 `results/DFE_07_mu_window.csv`.
[[inas100_mu_cl_convention_cl2]]의 "InCl₃ pinning 보존표"가 이걸로 계산값이 됐다
(그 메모의 solid 추정 −1.857/−1.694 = 여기 실험행과 일치).

## ⚠ PBE 는 층상 InCl₃ 를 못 잡는다 (vdW)

AlCl₃/YCl₃형 C2/m, Z=4(16원자). 시작셀 3종(scale 1.00/0.95/0.928)을 ISIF=3.

| | V(Å³) | ρ | In–Cl | a | b | **c** |
|---|---|---|---|---|---|---|
| PBE | 494~502 | 2.93~2.97 | 2.562 | 6.58 | 11.39 | **6.94~7.02** |
| D3/D4 | 429 | 3.42 | 2.547 | 6.45 | 11.17 | **6.33** |
| 실험 | 425.4 | 3.460 | ~2.48 | | | |

**면내(a,b)는 2% 이내인데 적층축 c 만 −10% 무너진다.** plain PBE 오차 = 전적으로 층간 vdW.
D3/D4 는 부피를 실험 −1% 까지 맞춘다.
⚠ 단 ΔH_f 오차는 PBE +1.01 → D3 +0.64 eV 로 **다 안 없어진다**. 남은 것의 일부는
**D3 가 In 금속을 0.33 eV/atom 과결합**시켜 기준을 끌어내리기 때문 → In metal·Cl₂ 도
**같은 IVDW 로 닫아야 한다**(`solids/vdw-refs/`). 섞으면 ΔH_f 가 0.33 eV 틀린다.

## In(OAc)₃ — 구조는 확정, 경계는 헐거움
초기구조 3종 중 **tris-bidentate D3 (6배위)** 가 최저:
2bi-1mono +0.838 eV, tris-monodentate +2.737 eV. 다중시작이 실제로 필요했다.
ΔH_f(In(OAc)₃,g) = −0.396 eV → **Δμ_AA 상한 −0.132(In-rich)/0.000(As-rich)** = 거의 무구속.
⚠ **기체 단량체**라서 그렇다. 실제 인듐 아세테이트는 다핵 고체(승화 ~2 eV급)이므로
진짜 상한은 **0.6~0.7 eV 더 아래**다. 지금 값은 "상한의 상한".

## footing (확정) — [[mu_reference_phases]]의 PBE판
ENCUT=400 · PREC=Accurate · LREAL=.FALSE. · In→In_d/As→plain As · POTCAR 54.
분자 20 Å 입방 Γ-only (V1: HCl 16~22 Å 편차 **0.14 meV**).
- **½E(Cl₂) = −1.799279** (현행 plot_DFE.sh −1.78515 대비 **−14.1 meV**)
- μ_AA 원점 = E(AcOH)−½E(H₂) = −43.394152
- ΔH_f(InAs) = **−0.486441** (실험 −0.60)
- 검증: HCl ΔH_f 오차 +36 meV, In metal 직접이완 −2.56279 vs BM −2.562344 (**0.45 meV**)

## ⚠ ISIF=3 는 Pulay 때문에 2~3회 재출발 필수
pass1→pass2 에서 D3_a_lit 이 **+49.6 meV** 움직였다. pass2 후 D3 세 시작점이
0.16 meV 로 수렴. PBE 는 층간 PES 가 평평해 pass3 에서도 V=494~502 로 흔들린다(에너지는 5 meV).

관련: [[inas100_mu_cl_convention_cl2]] [[mu_reference_phases]] [[inas100_acetate_tree_09]]
[[inas100_par4x3_q0_results]] [[cascade2_sbatch_workflow]]
