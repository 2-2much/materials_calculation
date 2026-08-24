---
name: hse_slab_dipole_convergence_trap
description: "★HSE 슬랩 1shot 함정 — 총에너지가 수렴해도 쌍극자 모멘트가 덜 수렴해 진공에 잔류장이 남고 V_vac 이 100 meV 급으로 틀린다. 게이트는 vac_slope"
metadata:
  type: project
---

2026-08-25, `04-Facet_IP-EA` 의 `03-hse-dipole` 에서 확인.

## 증상

HSE 1shot 8종 전부 **진공 평탄부가 안 평평하다**. `vac_slope` 가 PBE 의 300~1000배:

| | vac_slope (meV/Å) | vac_std (meV) |
|---|---|---|
| PBE 02-dipole (EDIFF 1E-6) | 0.03 ~ 0.09 | **0.05 ~ 0.06** |
| HSE 03-hse-dipole | 5.9 ~ 43.2 | **9 ~ 78** |

⚠ **PREC 탓이 아니다.** PBE 에서 `PREC` 만 Normal 로 바꾼 대조(C7 `__PREC=N_02-dip__`)는
`vac_std` 0.055 로 Accurate(0.051)와 같다. NGZF 도 두 HSE 런이 384 로 동일.

## ★ 원인 = 쌍극자 모멘트 미수렴 (총에너지 수렴으로는 안 잡힌다)

같은 셀·같은 기하·같은 `DIPOL` 로 두 경로를 비교:

| C1 HSE | IP | vac_slope | vac_std | dipole moment | 비용 |
|---|---|---|---|---|---|
| cold-start `ALGO=Normal`, EDIFF=**1E-5**, 80스텝 | 6.4509 | 11.18 | 16.0 | **0.250374** | 7900 s × 20노드 |
| **PBE 시드 + `ALGO=Damped`**, EDIFF=**1E-4**, 21+12스텝 | **6.3327** | **0.00** | **0.024** | **0.270851** | **2914 s × 10노드** |

- **총에너지는 0.41 meV 로 일치** — 전자구조는 같은 극소점이다.
- 그런데 **IP 가 118 meV 다르다** (V_vac 39 meV + V̄_slab 79 meV).
- 쌍극자 모멘트가 **8% 다르다.** 쌍극자는 밀도의 **1차 모멘트**라 진공 꼬리에 민감한데
  `EDIFF` 는 총에너지 기준이라 그걸 전혀 못 본다. 톱니가 장을 덜 지우면 그대로 잔류 기울기다.
- **더 느슨한 EDIFF(1E-4) 쪽이 오히려 평평하다** → EDIFF 를 조여도 안 고쳐진다.

**진공이 평평한 쪽이 옳다.** LDIPOL 이 제대로 걸렸다는 정의 자체가 그것이다.

## 처방

**PBE 사전 SCF → `ISTART=1` 로 HSE, `ALGO=Damped` + `TIME=0.4`.**
sham 에 `LHFSKIP` 빌드가 없으니 두 단계를 한 잡 안에서 손으로 잇는다
([[inas_facet_hse_1shot_setup]]). 부수 효과로 **node-hour 5.4배 절감**
(HSE 스텝 80 → 12; PBE 21스텝은 138 s 로 공짜).
⚠ `ALGO=Damped` 는 cold-start 에서 발산하므로 **시드 없이 단독으로 쓰면 안 된다**
([[hse_slab_scf_settings]], [[pbe_geometry_hse_1shot_delta]]).

## ★ 게이트

**`vac_slope` 를 반드시 볼 것.** 총에너지·SCF 스텝수·EDIFF 는 이 실패를 못 잡는다.
합격선은 PBE 수준인 **|vac_slope| < 1 meV/Å**. 넘으면 V_vac 이 못 미더우니 IP 를 쓰지 말 것.
`macroavg.py --plot` 의 그림에서도 진공 창(초록)이 기울면 보인다.

## 곁다리로 같이 잡은 것 — 거시평균 창 폭

`macroavg.py` 의 `PERIOD` 가 PBE-d a0(6.189842)로 하드코딩돼 있었다. HSE 스케일 셀
(a0=6.0982965656, −1.48%)에 그대로 쓰면 boxcar 가 1.5% 넓어 평면평균 진동이 안 지워진다.
실측 차이: C1 0 meV / C4 **11 meV** / C8 **95 meV** (σ 도 21 → 77 meV 로 악화).
→ `--a0` 옵션 추가. **HSE 셀에는 반드시 `--a0 6.0982965656`.**

관련: [[inas_facet_hse_1shot_setup]] [[inas_facet_ipea_workflow]] [[surface_defect_dipole_correction]]
