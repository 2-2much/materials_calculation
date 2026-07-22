---
name: slabcc_charge_truncation_guard
description: "slabcc \"discretization error\"는 격자 문제가 아니라 minimum-image 꼬리 절단(σ/L)이며, 잘 국소화된 전하도 1e-4 기본 tolerance에 걸려 죽는다 — SLABCC_CHARGE_TOLERANCE 환경변수로 우회"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 640e3ab2-68c1-49e1-b49b-8fbed2a39915
  modified: 2026-07-22T12:00:57.891Z
---

## 정체 (소스 확인 완료, `slabcc_model.cpp`)
`new_charge_error = |defect_charge − total_charge|` (전자 개수 단위).
- `defect_charge` = CHGCAR 차분의 실제 여분 전하
- `total_charge` = 모델 가우시안을 격자에서 합산한 값

이름은 "discretization"이지만 **실제 지배항은 격자가 아니라 minimum-image 절단**이다. `gaussian_charges_gen()`은 소스 주석대로 *1st nearest image만* 만들고 `if |pos|>L/2: pos = L−|pos|`로 접으므로, **중심에서 L/2 너머 꼬리는 통째로 안 세어진다.** 이 손실분은 축별 erf(L/2√2σ) 곱으로 정확히 예측되고 **σ/L만의 함수 → 격자를 아무리 키워도 안 줄어든다.**

## 수치 검증 (04 In_As_1, 셀 32.60×23.05×56.34 bohr)
| | σ_opt | 예측 누락 = 1−Π erf | slabcc 보고 |
|---|---|---|---|
| q+1 | 3.034 bohr (1.61 Å) | 1.4589e-4 | **1.4590e-4** |
| q−1 | 4.900 bohr (2.59 Å) | 1.9536e-2 | **1.9540e-2** |
격자 160→540 (3.4배)에서 4번째 자리만 흔들림. ⚠**slabcc 내부는 bohr 단위** — Å로 계산하면 300배 틀린다.

## 결과적 문제
tolerance는 하드코딩 `1e-4`. q+1의 1.459e-4는 그 **1.46배**(전하의 0.015%)뿐인데 `exit(1)`. **격자로 절대 못 내리는 양을 격자로 내리라 요구하는 구조**라 무한 실패 = 위양성. 반면 q−1은 195배라 정당한 거부.

## ⚠패치는 **서버마다 따로** 해야 한다 (2026-07-22 추가 확인)
`~/bin`은 공유 마운트가 아니라 **서버 로컬**([[server_fs_git_sync_scope]]). 아래 패치를 한 서버에서 해도 다른 서버의 `~/bin/slabcc`는 **그대로 1e-4 하드코딩**이다.
실제로 tgm-master에서는 소스에 `SLABCC_CHARGE_TOLERANCE`가 없었고(`grep`·`strings` 둘 다 0건), 바이너리도 2026-06-18자 구버전이었다 → **2026-07-22 tgm-master에서 재패치·재빌드**. 백업 `bin/slabcc.orig.bak`.
회귀 검증: 저자 배포 NaCl case01을 재실행해 **E_corr = +0.557445 vs 참조 +0.5575** (5e-5 eV 일치) → 패치가 물리를 안 건드림 확인.
새 서버에서 slabcc를 처음 쓸 때는 `strings ~/bin/slabcc/bin/slabcc | grep SLABCC_CHARGE_TOLERANCE` 로 패치 여부를 먼저 확인할 것.

## 조치 (2026-07-22)
`~/bin/slabcc` 소스에 **`SLABCC_CHARGE_TOLERANCE` 환경변수 override** 추가 후 재빌드(`bin/build_local.sh`, icx/icpx MKL=1).
⚠**하드코딩 기본값 1e-4는 안 바꿨다** — 환경변수 미설정 시 이전과 완전 동일. 값을 준 곳은 In_As_1 q+1 잡 스크립트 한 줄뿐.
사용법: `SLABCC_CHARGE_TOLERANCE=1e-3 slabcc`
**왜 1e-3**: q+1(1.459e-4)의 6.9배 위 ↔ q−1(1.954e-2)의 20배 아래 = 두 케이스 사이 빈 구간. 3e-4~5e-3 어디를 골라도 판정 동일하므로 **값에 민감하지 않음**.
구 바이너리 백업 `bin/slabcc.orig_1e-4.bak`.

## 회귀테스트 (재빌드 검증용, 재사용 가능)
`tests/`에 개발자 제공 참조출력(`output/gas/`, `output/gaussian/` 각 30파일)이 있고 `tests/makefile`이 numdiff로 대조하는 구조(평균화 .dat+slabcc.out은 rel 1e-3/abs 1e-5, 원시 LOCPOT/CHGCAR은 abs 1e-4).
⚠**이 서버에 numdiff 없음** → 대체 스크립트를 만들어 저장해뒀다: **`~/bin/slabcc/tests/run_regression.sh`** (+ `numdiff.py`). 그냥 실행하면 2케이스×30파일 대조.
2026-07-22 재빌드 결과 **60파일 ALL-PASS** (gaussian E_corr 0.500213792 vs 참조 0.500213687, 1e-7 eV).

## 판정 기준으로 쓰기
1e-2급 = "에너지 몇 % 틀림"이 아니라 **모델 전하가 자기 주기 이미지와 물리적으로 겹친다**는 뜻 = 고립 극한이 정의 안 됨 = 적용범위 이탈. slabcc 자체 하드리밋은 `max_sigma = 6.5 bohr`("method is not suitable").
⚠**`charge_trivariate = yes`는 해법이 아니다**: In_As_1 q+1에서 σ가 상한 (7,7,1.67)로 pinned되며 pancake로 붕괴, max_sigma 에러 + 누락 0.1176. RMSE는 0.085→0.058로 좋아지지만 물리적으로 무의미. 등방 모델 유지할 것. ([[slabcc_optimize_tolerance]] 의 trivariate 권고는 이 케이스엔 부적용)

관련: [[in_as_1_deep_level_q_dependent]], [[slabcc_delocalized_defect_policy]], [[slab_correction_workflow]]
