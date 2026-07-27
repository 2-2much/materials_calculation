---
name: inas100_8ml_thickness_verdict
description: "InAs(100) Cl-passv 두께(out-of-plane) 확정: 8 ML 채택, 6 ML 탈락. 프로덕션 이월 규칙 3개(μ_InAs=−7.6767, DIPOL 필수 지정, NGZF 고정)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 60429d6d-24fe-4d48-bad7-63259cb37cb9
  modified: 2026-07-27T08:28:22.402Z
---

2026-07-27 확정. **(100) Cl-passv 슬랩 두께 = 8 ML** (사용자 최종 결정: "quantum dot 을
묘사하기에 8 ML 정도는 되어야 적합"). 이 판정은 **out-of-plane 전용**이고, in-plane 셀
크기는 별건이다 → [[inas100_inplane_scan_todo]]

계산 위치: `10-Primitive-slab/00-Convergence_test_unitcell/03-thickness_100_Cl-passv/`
(ML 4/6/8/10/12, 2×2 셀, mono-alt = p(2×2) 배치, PBE-d, ENCUT 300, EDIFF 1E-6, IBRION=2, k 2×2×1)

## Cl 배치 확정 (02-Cl_arrangement_100)

**mono-alt(p(2×2)) 승** — mono-A 대비 **11.0 meV** 낮고 k-정밀화해도 부호 안정.
**결정적으로 둘 다 gap 이 열린다**(0.863 / 0.866 eV). Cl 이 monodentate 라 다이머당 빈 In
dangling bond 를 남기는데도 갭 준위를 안 만든다 → **Cl 단독 (100) 패시베이션은 작동한다**
(ChemComm 2017 에 Cl 단독 (100) 사례가 없어 직접 확인이 필요했던 부분).
이완 후 dimer 2.870~2.875 Å, buckling 0.344~0.357 Å (LDA 선례 2.93 / 0.12 Å 와 정합).

## 두께 판정 수치

E_excess 의 12 ML 대비 편차 (수용기준 20 meV):

| ML | 편차 | 판정 |
|---|---|---|
| 4 | **+26.3 meV** | 탈락 |
| 6 | +1.65 meV | 에너지는 통과하나 아래 이유로 탈락 |
| 8 | 0.00 | **채택** |
| 10 | −0.38 | |
| 12 | 0.00 | 기준 |

적합 없는 **2차 차분**(+22.98 / +1.28 / +0.75 meV)이 독립적으로 같은 결론 → 곡률의 직접
측정이지 fitting artifact 아님.

**6 ML 탈락 사유는 에너지가 아니라 기하다.** 표면 교란이 **~3 Å(원자면 2개)** 침투하는데
6 ML 의 미교란 내부는 **1.69 Å** 뿐 — 거시평균 창(a0/2 = 3.09 Å)보다도 짧아서 양면이
문자 그대로 섞인다. 8 ML 은 4.75 Å, 12 ML 은 10.95 Å.

## ⚠ 프로덕션 이월 규칙 3개

1. **μ_InAs = −7.6767 eV/f.u.** (슬랩에서 적합한 값)을 쓸 것. 별도 벌크 계산값
   **−7.717617 은 이 슬랩 에너지들과 절대 섞지 말 것** — 40.9 meV/f.u. 차이라
   Δn_InAs ≠ 0 인 결함마다 그만큼 들어간다. (프로젝트 표준 −7.718334 도 ENCUT 400 이라 별개)
2. **`IDIPOL=3` + `LDIPOL=.TRUE.` + `DIPOL` 을 켤 것.** E(ON)−E(OFF) 가 8 ML +19.8 /
   12 ML +17.1 meV 로 **두께 의존적**이다.
   ⚠ **`DIPOL`(전하분포 중심)을 반드시 명시**해야 한다. 없으면 원점 기준으로 쌍극자를 재서
   보정이 −145 eV 로 발산하고 SCF 가 −25711 → +26 eV 로 진동하다 죽는다.
   실측: 8 ML `DIPOL = 0.5 0.5 0.5084`, 12 ML `0.5 0.5 0.5072` → 29/30 스텝 수렴.
3. **NGZF 고정 또는 PREC=Accurate** — 두께마다 z 격자 밀도가 ±2.5% 흔들린다.

## ⚠ 내부 전위 기울기 기준은 두께를 가르지 못한다

dipole ON 에서도 12 ML 이 **−0.0139 V/Å** (기준 0.01)로 실패한다. 즉 8 ML 을 막는 근거가
아니다. dipole 이 설명하는 몫은 12 ML 에서 **23%** 뿐이고, 이중층별로 −0.0137 / −0.0184 로
**균일하지도 않다** → 내장전위가 아니라 감쇠 못한 표면 공간전하 꼬리. 위/아래가 화학적으로
다른 **비대칭 슬랩 설정 자체의 성질**로 보고, 두께가 아니라 위 규칙 2 로 관리한다.
(초기에 "내부 기울기 = dipole 인공장"이라고 단정했던 것은 철회됨)

⚠ **이 LOCPOT 의 진공을 에너지 기준으로 쓰지 말 것.** 그리고 진공 기울기를 잴 때
진공이 셀 위/아래로 갈라져 있으므로 **주기경계를 unwrap 해야** 한다. wrapped 로 맞추면
+0.0122 V/Å (rms **130 mV**), unwrap 하면 −0.0723 V/Å (rms **2.5 mV**) — 부호까지 틀린다.
Laplace 상 진공 전위는 정확히 직선이므로 **fit 잔차 rms 가 판정자**다.
(`analyze_locpot.py` 에 수정 반영됨)

## 유용했던 도구

- `graft_relaxed_surface.py` — 이완 끝난 얇은 슬랩의 표면 변위를 두꺼운 이상 슬랩에 이식.
  12 ML 이 18 스텝에 수렴(이상 seed 는 ~48). 고정원자 잔차 0.0000 Å.
  → in-plane 확장 seed 로도 [[passivated_surface_tiling_shortcut]] 와 함께 쓸 것.
- `plot_thickness_convergence.py --fit-bulk` — e_bulk 를 슬랩 계열에서 적합(k-오차 상쇄).

관련: [[inas100_slab_generation]] [[cqd_ntype_origin_goal]] [[energy_column_sigma0_vs_toten]]
