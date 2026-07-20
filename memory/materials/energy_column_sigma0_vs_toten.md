---
name: energy-column-sigma0-vs-toten
description: DFE 파이프라인이 TOTEN(자유에너지)을 읽어 홀수 전자 결함만 28~42meV 계통적으로 안정해 보이는 편향 — energy_sigma0_eV로 전환 필요
metadata: 
  node_type: memory
  type: project
  originSessionId: f4bfd3d3-c080-491a-b5ba-f0c4ca66ef42
  modified: 2026-07-20T05:28:11.526Z
---

2026-07-20 발견. `scripts/plot_DFE_from_raw_energies.py:402`가 `r.toten_eV`를 읽는다.
`raw_energies.csv`는 `toten_eV` / `energy_without_entropy_eV` / `energy_sigma0_eV` 세 컬럼을
다 갖고 있는데 뒤의 둘은 **쓰기만 하고 아무도 읽지 않는다**. `--energy-column` 옵션도 없다.

## 왜 문제인가
TOTEN = F = E − TS이고, 여기서 −TS는 Gaussian smearing(ISMEAR=0)의 **가짜 엔트로피**다
(물리적 전자 엔트로피는 ISMEAR=−1 Fermi-Dirac에서만). T=0 형성에너지에 넣을 근거가 없다.
VASP도 ISMEAR=0/1/2에서는 `energy(sigma->0)`를 쓰라고 명시. σ→0은 2차 정확 외삽
`(F + E_woe)/2` — 수치로 확인됨.

## 편향의 지문: EENTRO/2 = σ/(2√π)
SIGMA=0.1 → 0.1/3.5449 = **0.0282 eV**. E_F에 정확히 걸린 단일 상태가 반만 찬 경우의 값이며,
**전자수 패리티와 100% 상관**한다(짝수 전자 셀은 전부 0.0000).

| bias = (TOTEN−σ0)_def − (TOTEN−σ0)_pure | 해당 |
|---|---|
| 0 meV | 짝수 전자: As_In q0, Cl-As_In q+1/q−1, V_Cl-Cl_As q+1, In_As, V_Cl-V_* |
| −28.2 meV | 홀수 전자: Cl-As_In q0/q+2, V_Cl-Cl_As q0/q+2, As_In q±1, In_i_Td_*, As_i_Td_In |
| −41.6 meV | V_Cl-Cl_In q0 (E_F 근처 2상태, occ 1.257) |
| 04: −28~−36 | Cl-As_In, Cl_i-As, In_i_2, V_In, V_As(−36.4) |

pure는 갭이 열려 EENTRO=0이므로 `E_f = E_def − E_pure`가 **홀수 전자 결함만 계통적으로 낮게**
나온다. 하필 축퇴 n형(Burstein–Moss) 결함이 여기 걸린다.

## CTL에 직접 들어간다 (같은 결함도 전하마다 편향이 다름)
Cl-As_In: q0=−28.2, **q+1=0**, q+2=−28.2, **q−1=0**

| CTL | TOTEN(현재) | σ→0 보정 |
|---|---|---|
| Cl-As_In (+1/0) | 0.5913 | **0.6195** (+28) |
| Cl-As_In (0/−1) | 0.7803 | **0.7521** (−28) |
| V_Cl-Cl_As shallow anchor | −1.0782 | **−1.0500** (+28) |

형성에너지 **서열은 안 뒤집힌다**(최소 간격 0.38 eV ≫ 42 meV). CTL만 이동.

## 규모의 한계 — 음의 형성에너지를 설명하지 못함
V_Cl-Cl_As E_f(In-rich) −1.078 → **−1.050 eV**, 편향 몫 2.6%뿐. Δn_Cl=0이라 μ와도 무관하므로
"02 reference 슬랩이 바닥상태 아님"([[cl_as_negative_eform_reference_slab]])은 그대로 유효.

## 조치
`--energy-column {toten,sigma0}` 플래그, 기본 `sigma0`. `plot_shallow_limit_DFE.py`도 동일 컬럼.
**재계산 0.** 그리고 Γ-only relax의 SIGMA를 0.1 → 0.05로 낮추면 아티팩트 절반(14 meV).
ISMEAR은 Γ-only에서 0 유지(k점 1개면 tetrahedron 무의미).

관련: [[spin_stage_symmetry_never_broken]] — 스핀 ΔE 비교도 반드시 σ→0으로.
