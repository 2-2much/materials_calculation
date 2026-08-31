---
name: mu_window_hse_aexx27_21
description: "★HSE06 AEXX=0.27 / ENCUT=400 / PRECFOCK=Fast μ 세트 확정 (μ_In −2.943828, μ_As −5.686222, μ_InAs −9.389653, μ_Cl −2.697931, μ_AA −52.764889, μ_MA −42.308680). ΔH_f(InAs)=−0.7596 실측 → Δμ_Cl 밴드폭 0.16→0.253 eV. ⚠In metal POSCAR_BM_a0.vasp 는 부피가 3배인 불량 파일"
metadata:
  type: project
---

트리 = `33-inAs/__Ligands_and_Chemicals__/21-mu_window_HSE06_AEXX27/`. 2026-09-01 완료.
결과 = `results/mu_window_hse.md`, `results/cpd_mu_window_hse.png`. 계산은 **fermi**.

## footing — 왜 Fast/400 인가
타깃이 `12-Surace-defect_calculation/09-01-100AA_8L_par4x3_HSE-d` 인데 그 트리가 이미
**ENCUT=400 / PRECFOCK=Fast** 다 (C·O PAW ENMAX=400). [[mu_reference_phases]] 의
"Normal 통일"은 **Cl-only 트리(02·06, ENCUT=300/Normal)에만** 해당한다. 두 세트를 섞지 말 것.

| 세트 | ENCUT | PRECFOCK | μ 출처 |
|---|---|---|---|
| 02·06 Cl-only HSE | 300 | Normal | 기존 `12-HSE06-Gamma/ENCUT300_pfN/` |
| **09-01·10-01 AA HSE** | **400** | **Fast** | **이 트리** |

공통: AEXX=0.27, HFSCREEN=0.2, In→In_d, As→plain As, POTCAR 54.
분자 = 20 Å 입방·Γ-only·LREAL=A·**LHFSKIP=.T.**·PBE 기하 씨앗 → HSE 이완.
고체 = LREAL=.FALSE.·PREC=Normal (BM 원본과 동일).

## ★ 확정 μ 세트 (eV)
```
μ_In   = -2.943828   (In metal bct, In_d)
μ_As   = -5.686222   (gray As A7, plain As)
μ_InAs = -9.389653   (/f.u.)
μ_H    = -3.955178   (½E(H2))
μ_Cl   = -2.697931   (½E(Cl2))
μ_AA   = -52.764889  (E(CH3COOH) - ½E(H2))
μ_MA   = -42.308680  (E(CH3NH2) 통째, 중성 배위자)
```
분자 원값: H2 −7.91035660 · Cl2 −5.39586100 · HCl −7.64433748 ·
InCl3(g) −14.96198226 · AcOH −56.72006754 · MA −42.30867957.

## 고체는 BM E0 + shift 로 옮겼다 (재적합 안 함)
`E0(400,Fast) = E0_BM(300,Normal) + [E(400,Fast) − E(300,Normal)]|_BM a0`
앵커의 (300,Normal) 이 BM E0 를 재현하는지로 자체검증된다:

| 상 | BM E0 | 앵커 잔차 | shift | E0(400,Fast) |
|---|---|---|---|---|
| InAs | −9.3861699 | −0.65 meV | −3.48 meV | **−9.389653** |
| As-A7 | −11.3713679 | −0.29 meV | −1.08 meV | **−11.372444** (2원자) |
| In-metal | −2.9416026 | **−0.004 meV** | −2.22 meV | **−2.943828** |

⚠ **PRECFOCK Fast−Normal 은 고체에선 ≤1 meV** (InAs +0.72, As −0.00, In −0.08)인데
**분자는 H₂ +31 meV** 다. 종별 민감도 차가 크다는 기존 관찰 재확인.
As BM 은 등방 볼륨스캔이 아니라 **층간 변형 스캔**(짧은 As–As 고정)이고 최소는 eps=+0.02
(`strain_p0.0200`) — 그 기하를 앵커로 썼다.

## ⚠⚠ In metal `POSCAR_BM_a0.vasp` 는 불량 파일이다
`bloch:.../04-Chemical-reservoir/01-In-metal/02-HF-mixing/PBE-d_HSE06_AEXX27/POSCAR_BM_a0.vasp`
의 scale = **1.45319914675679218259** → 셀 부피 **80.62 Å³**. BM V0 는 **26.5937 Å³** 이므로
**3.03 배**다. 그대로 쓰면 E = −1.5169 로 **1.42 eV 어긋난다**(2026-09-01 실제로 당함).
올바른 셀 = 그 파일의 기저벡터(= lattice_G scale 1.000, V=26.2696) × **1.0040953231**.
→ **BM a0 POSCAR 는 이름 믿지 말고 OUTCAR 부피를 BM V0 와 대조할 것.**
InAs(비 1.0000)·As(1.0013)은 정상이었고 In metal 만 틀렸다. 폐기런은
`solids/In-metal/__attempt1_wrongcell_V80.6__/` 에 보존.

## 생성엔탈피와 Δμ_Cl 창
- ΔH_f(InAs) = **−0.7596** (실험 −0.600, −160 meV). PBE 는 −0.4867(+113 meV)
  → **PBE 와 HSE 가 실험을 사이에 둔다.**
- ΔH_f(HCl) = −0.9912 vs 실험(ZPE 제거) −0.9865 → **−4.8 meV** (Normal 판 −6.0 과 동급)
- ΔH_f(InCl₃,g) = **−3.9244** ([[mu_reference_phases]] 의 −3.926 과 2 meV 일치)

| Δμ_Cl 상한 기준 | In-rich | As-rich |
|---|---|---|
| **기체 단량체 InCl₃(g)** ← 계산 | **−1.308** | **−1.055** |
| 고체 추정 (기체 − PBE 승화 0.952) | −1.625 | −1.372 |
| 고체 실험 ΔH_f | −1.856 | −1.603 |

★ **밴드폭 = |ΔH_f(InAs)|/3 = 0.253 eV.** [[mu_reference_phases]] 가 "추정 0.49 → 폭 0.16"
으로 남겨둔 숙제가 이것으로 닫혔다. In-rich 끝은 −1.309→−1.308 로 그대로고
**As-rich 끝만 −1.15 → −1.055** 로 바뀐다.

⚠ Δμ_AA·Δμ_MA 는 **상한 0 뿐**이다. 하한은 In(OAc)₃ / In–아민 착물이 있어야 닫힌다(미계산).
⚠ Δμ_Cl 은 **기체 단량체 기준 = 가장 헐거운 경계**. 고체가 진짜 구속이다([[mu_window_pbe_20]]).

관련: [[mu_window_pbe_20]] [[mu_reference_phases]] [[fermi_node_setup]]
[[inas100_mu_cl_convention_cl2]] [[inas100_acetate_tree_09]]
