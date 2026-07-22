---
name: si_db_kp_reproduction
description: "Komsa-Pasquarello Fig.4(b) Si dangling bond(q=-1) 재현 — 셀 기하 N=4t+1 유도, uncorrected는 KP와 0.09eV 일치하나 E_corr은 2배, 가설 3개 배제, 국소성 경계 지도"
metadata: 
  node_type: memory
  type: project
  originSessionId: 9576900b-ea8f-420e-9daf-cd578b563a18
  modified: 2026-07-22T11:59:49.318Z
---

`11-Surface-defect_TOY-model/slabcc_Si-DB/` — KP PRL 110, 095505 (2013) **Fig.4(b) Si dangling bond (q=−1) @ H-passivated Si(001)-(2×1)** 을 VASP+slabcc로 재현. 2026-07-22 착수.
NaCl 재현([[kp_slabcc_nacl_reproduction]])이 "쉬운" 벤치마크라면 이쪽은 논문 본문이 직접 *"severely challenges the correction scheme — covalent, small band gap, complex surface structure, high dielectric contrast, **more extended defect wave function**"* 이라 쓴 어려운 쪽. InAs (110) 표면 결함이 정확히 같은 범주라 통과 여부가 곧 파이프라인 신뢰도.

## 셀 기하 — N = 4t+1 (직접 유도, 논문에 없음)
SI: *"On opposite sides of the slab, the dimer rows are oriented perpendicularly. Therefore the minimum lateral size is 2×2"*.
ASE `diamond100`으로 back-bond 투영을 실측: **짝수 층수 = 양면 dimer 평행, 홀수라야 수직.** 여기에 "slab thickness = t·alat"(Si z-span)를 걸면 **N = 4t+1**로 유일 확정 → α=1,2,3 = **5/9/13층**, lateral 2/4/6, c = 2t·alat.
독립 검증: Fig.4(b) 상단 라벨 `2x2x2 / 4x4x4 / 6x6x6`의 셋째 숫자가 c/alat이고 우리 c = 10.86/21.72/32.58 Å = 정확히 2/4/6 alat. SI Fig.5(b)의 `2/1/1, 4/2/2, 6/3/3`과도 일치.

## 논문 사양 (SI Sec. V, 본문 아님)
alat=**5.43 실험값**, cutoff 30 Ry(≈408 eV), k = 표면 1×1 기준 **12×12**(→ lateral 2/4/6에 6/3/2), 수직 Γ-only.
이완: pristine=표면 Si+H / defect=**DB Si 1개만**. ⚠본문의 *"Structural relaxation has been disregarded"* 는 **NaCl 문단 전용** — Si는 이완함(에이전트 2회 교차검증).
⚠**VBM을 슬랩에서 읽지 말 것** — confinement로 두께 민감. 별도 bulk Si VBM을 슬랩 중앙 정전퍼텐셜로 정렬(SI 명시).

## 결과 (α=1까지)
| | KP | 우리 |
|---|---|---|
| E_f **uncorrected** 2/1/1 | 1.49 | **1.580** ✅ |
| E_corr | +0.22 함의 | **+0.492±0.021**(3D) / +0.536(2D) ❌ |
| E_f corrected | 1.71 | 2.07~2.12 |

**uncorrected가 0.09eV로 맞는다** = 기하·μ_H·VBM정렬·NELECT 회계가 전부 옳다. 미지수는 **E_corr 하나**.
**첫 평탄성 테스트(진공 1→2 alat)**: uncorrected 1.580→1.834(**+254meV 발산**), corrected 2.116→2.040(**−76meV**) → 3.3배 개선, KP Fig.1(c) 효과 재현. (KP의 ~10meV 수준은 아직 아님)

## 배제된 가설 3개 (전부 원인 아님)
1. **ε·경계·taper 선택** — 4변형 스프레드 41meV뿐(12.9/11.7/diel_taper=2/경계를 Si면에 고정).
2. **Δρ vs |ψ_d|² 방법론 차이** — LPARD로 뽑은 **σ(|ψ_d|²)=2.289Å vs slabcc σ(Δρ)=2.320Å, 1% 일치.** DB 파동함수 자체가 그만큼 퍼져 있음(셀 변 7.68Å의 1/3) = KP의 "more extended" 정량화. screening 이중계산 우려는 기각.
3. **slabcc 2D vs 3D 경로** — α=1에서 2D(0.536) > 3D(0.492), 차이 45meV로 오차막대급. 앞서 vac 2/1/2에서 2D가 0.206으로 작았던 건 경로가 아니라 **셀이 달랐던 것**(E_corr이 진공 따라 변하는 건 uncorrected 발산 상쇄로 정상).
→ 남은 원인은 **셀 크기의 물리** (α=1 DB 밴드 분산 0.34eV, Δρ f_slab 0.53/overlap 0.67, 진공 plateau 폭 1.4Å뿐).

## 국소성 경계 지도 (⚠재현의 핵심 발견)
| 셀 | lateral/두께 | pure gap | q=−1 전자 위치 | slabcc |
|---|---|---|---|---|
| 2/1/1 | 2×2 / 1 | 1.486 | gap 73.4%, occ=1 | 5/5 성공 |
| 2/1/2 | 2×2 / 1 | 1.491 | 104.3% 경계 | 2D만 |
| 2/2/2 | 2×2 / 2 | 1.123 | **197.5%, occ 0~0.83, 분산 0.94eV** | **4/5 abort** |
두꺼워지면 confinement가 풀려 gap이 줄고 DB acceptor 준위가 **PBE CBM 위로 밀려남** → 전자가 전도대로 유출. slabcc가 *"Most probably the model charge is fairly delocalized!"* 로 스스로 거부 = [[slabcc_delocalized_defect_policy]] 를 외부 문헌 벤치마크에서 독립 재확인. ⏭lateral을 키운 α=2(4/2/2)에서 DB 밴드가 좁아져 다시 bound가 되는지가 미결.

## 배선 / 함정
- 케이스별 독립 체인 `run_case.sh <case> [seed]` (α=3는 [[passivated_surface_tiling_shortcut]] 적용)
- 진단: `check_defect_level.py`(점유·gap 내 위치), `check_charge_localization.py`(Δρ f_slab/overlap), `psi_sigma.sh`(LPARD σ), `tile_relaxed.py`
- ⚠relax 단계만 α=2/α=3가 `LREAL=Auto, EDIFF=1E-5, ALGO=Fast`(속도 4~6배). statics는 전 케이스 `LREAL=.FALSE., EDIFF=1E-6` → **E_f에 무전파**. 단 **relax 총에너지끼리 셀 간 비교 금지**(4×E(vac_2_2_2) vs E(alpha2)가 0.075eV 어긋남).
- ⚠`stage_tools.py` 정규식은 `^charge_position` 앵커 필수 — 없으면 `optimize_charge_position = yes`까지 좌표로 덮어씀(실제로 겪음).
- ⚠LPARD는 **2-pass**(1차 LWAVE=.T. → 2차 ISTART=1+LPARD)이고 **KPAR=1 필수**(`PARCHG: KPAR>1 not implemented`).

관련: [[kp_slabcc_nacl_reproduction]], [[g1_node_vasp_binary_limit]], [[slabcc_charge_truncation_guard]], [[passivated_surface_tiling_shortcut]]
