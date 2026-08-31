---
name: inas111-aa-hse-1shot-23
description: "kohn 23-111AA/__HSE06_1shot__ — 아세테이트 (111)A pure/V_In HSE06 1shot. 진공을 22트리 것으로 줄일 때 'HSE 격자에서' 맞춰야 35트리와 같은 footing"
metadata:
  node_type: memory
  type: project
---

2026-08-31 생성. kohn `12-Surace-defect_calculation/23-111AA_4BL_2r3_PBE-d/__HSE06_1shot__/`.
2셀(pure, V_In) × 2스테이지(`00_PBE-pre` → `01_HSE-1shot`). 빌더 `make_hse_cells.py`, 설명 `README.md`.
구조는 kohn `09-100AA .../__HSE06_1shot__` 과 sham [[inas111_hse_tree_35]] 을 그대로 따랐다.

## ★ 진공을 옆 트리에 맞출 때 — 배율을 어디에 거는가

23 PBE-d 셀은 진공이 **25.08 Å** 로 10 Å 낭비였다. 22 트리(Cl/MA, 같은 (2√3×2√3)R30)에
맞추라는 지시였는데, 22 는 **PBE-d 격자**의 값(14.9910 Å)이다. 그대로 쓰면 안 된다 —
22 의 HSE 판인 **35 트리는 진공도 s 배 된 14.7693 Å 에서 돈다**. 그래서 23-HSE 도
**14.7692928417 Å** 로 맞췄다. 그래야 (111)A 아세테이트 HSE ↔ (111)A Cl/MA HSE 가
**같은 진공 footing**이 된다(진공을 맞추는 유일한 이유가 그것이다).

```
             c (Å)     슬랩     진공
 23 PBE-d   42.7756   17.7003  25.075
 22 PBE-d   32.2699   17.2789  14.9910
 35 HSE-d   31.7927   17.0234  14.7693   = 22 × s
 23 HSE-d   32.2080   17.4387  14.7693   ← 여기
```

## 셀 만들기 3단계 (순서 중요)
1. 종 이름 복원 `In→In_d`, `H.→H.75` (CONTCAR 가 잘라 쓴다)
2. 격자+**데카르트 좌표** 전부 `F = 0.9852104464055786` 배 (분수좌표 불변)
3. c 만 따로 지정 + 슬랩 z 재중심. **순수한 상자 변경** — 원자간 거리는 안 건드린다.
   ⚠ 3단계는 분수 z 를 다시 계산하므로 2단계와 섞으면 안 된다.

⚠ **pure 와 V_In 의 c 는 반드시 하나**. 두 셀 슬랩 두께가 0.0002 Å 다르므로 각자
진공을 맞추면 상자가 달라져 `E_f = E(V_In) − E(pure) + μ_In` 이 깨진다. 두꺼운 쪽으로
c 를 한 번 고정(32.2079951256)하고 둘 다 쓴다.

⚠ 고정원자 36개(pseudo-H 12 + 바닥 BL 24)의 `F F F` 는 그대로 통과시킨다. NSW=0 이라
무의미해 보이지만 셀을 나중에 이완에 재사용할 때 필요하다.

검증(빌드 후 실측): `max|Δfrac_xy| = 0`, 원자쌍 거리가 정확히 F 배(잔차 7e-15 Å),
SD 플래그 동일, 두 셀 격자 동일.

## 설정
- 00: PBE, ISTART=0/ICHARG=2, EDIFF 1E-5. **ISPIN=2 (01 만이 아니라 00 도)** —
  ISPIN=1 WAVECAR 를 ISPIN=2 가 읽으면 대칭해가 고정점이 된다([[spin_stage_symmetry_never_broken]]).
  MAGMOM 은 기본값(모든 이온 1.0) 그대로 둔다. V_In NELECT=1067 **홀수**.
- 01: HSE06 AEXX 0.27 / HFSCREEN 0.2 / **PRECFOCK=Fast** / **ALGO=Normal** / EDIFF 1E-4,
  ISTART=1/ICHARG=0 으로 00 의 WAVECAR·CHGCAR 승계. LHFSKIP 은 일부러 안 켬.
- 공통: NSW=0, ENCUT 400, PREC=N, ISMEAR=0 SIGMA=0.1, ISYM=0, **Γ-centered 2×2×1**
  (ISYM=0 이라 k점 4개 → KPAR=4). 두 스테이지 KPOINTS 가 같아야 WAVECAR 가 넘어간다.
- SLURM: cascade2 4노드×32 = 128 rank, NCORE=16/NSIM=32. 잡 `AA23hse_pure` / `AA23hse_V_In`
  (60792 / 60793, 2026-08-31 제출).

## ⚠ 이 폴더 숫자의 한계
`../results/raw_energies.csv` 의 PBE-d 값은 **옛 42.78 Å 상자 + ISMEAR=−5** 라 대조군이
아니다. 대조군은 이 폴더의 00 단계다. μ_In 은 PBE/ENCUT300 이고 PRECFOCK=Fast 는 Δn≠0 에서
상쇄되지 않으므로([[precfock_fast_policy]]) **절대 E_f 는 못 낸다** — 낼 수 있는 것은
`E(V_In) − E(pure)` 와 그 HSE−PBE 차이, 준위 위치, E_F.

## 10 트리 규약과의 관계 (같은 날 별도 세션)
[[inas100_hse_1shot_tree_10]] 은 "진공 재설정(참조트리 PBE 값) → 등방 배율" 순서로 했고
여기는 "등방 배율 → 진공을 배율된 값으로 지정" 순서다. **최종 진공은 둘 다 vac_ref × F 로 동일**하다.
차이는 하나뿐: 10 은 슬랩을 z 로 안 옮겨 진공이 셀 경계를 감싸고, **여기는 슬랩을 상자 가운데로
옮겼다**(아래 7.38 / 위 7.38 Å). LOCPOT 평탄부를 wrap 없이 양쪽에서 읽을 수 있다.

## 출발 기하 상태
V_In `00_Gam-relax` 는 NSW=400 을 소진했지만(reached accuracy 없음) 이어지는
`01_Spin-gam-relax` 가 7스텝에 수렴했다. 쓴 CONTCAR 는 01 것이고 자유원자 max|F| 는
pure 0.0125 / V_In 0.0095 eV/Å (EDIFFG −0.015) — 둘 다 정상.

관련: [[inas111_hse_tree_35]] [[inas_vin_facet_trees_10_23]] [[inas100_acetate_tree_09]]
[[hse_relax_vs_singlepoint]] [[hse_slab_scf_settings]] [[hse_1shot_pitfalls_and_q0_results]]
[[vacuum_scan_vbm_reference_trap]] [[dos_2x2x1_tetrahedron_occ_overshoot]]
