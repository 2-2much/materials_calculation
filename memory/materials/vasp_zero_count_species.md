---
name: vasp_zero_count_species
description: "POSCAR 개수 0 종 블록은 ISYM=0이면 정상 동작. 기본 ISYM=2면 대칭성 setup에서 segfault"
metadata:
  type: reference
---

2026-08-13, 실측 3종 대조. 결함 셋에서 **Cl 이 일부 셀에만** 있을 때 POTCAR 를 하나로
통일하려고 "5종 POTCAR + POSCAR 에 `Cl 0`" 을 시도한 건. 트리:
`11-110bare_6L_par3x2_PBE-d/02-build_defects/__potcar_test__/`

## ✅ 된다 — 단 **ISYM=0** 이어야 한다

동일 POTCAR(5종)·ENCUT300·PREC N·LREAL A·NELM1·NSW0·Γ·NCORE8·**std 바이너리**,
차이는 Cl 개수와 ISYM 뿐:

| | Cl 개수 | ISYM | 결과 |
|---|---|---|---|
| A | **0** | 기본(2) | "5 types and 84 ions" 읽고 `POSCAR, INCAR and KPOINTS ok, starting setup` 에서 **segfault** |
| B | 1 | 기본(2) | 정상, NIONS 85, NELECT 667.0000 |
| C | **0** | **0** | **정상**, NIONS 84, NELECT 660.0000 |

★ 크래시는 **대칭성 setup** 안이다(이온 0개인 type 을 못 넘김). zero count 자체는 무죄.

⚠ **나의 첫 진단("VASP 가 zero count 를 못 받는다")은 틀렸다.** 사용자가
`08-100Cl-MA_8L_par4x3_PBE-d` 를 지목해서 잡혔다 — 거기 pure 셀은 7종 POTCAR 에
`N 0 / C 0 / H 0` 으로 **처음부터 이 방식으로 돌고 있었고**, 4개 stage(gam·std 양쪽)
전부 정상종료다. 이유는 그 프로젝트 INCAR 가 ISYM=0 이기 때문.

## 적용

11 프로젝트 13셀 전부 5종 블록(없으면 0)으로 통일 → 단일 `POTCAR` 로 prepare 통과.
패키지 자체 함수(`read_potcar_species_and_zval` + `check_species_order` +
`compute_neutral_nelect`)로 13셀 전수 검증 완료, NELECT 표와 일치.
`config/INCAR/` 5개 전부 ISYM=0 확인.

⚠ 나중에 **대칭성 켠 채로** 이 POSCAR 를 읽는 것(ISYM 안 준 일회성 VASP 실행, 외부 툴)이
있으면 0 블록을 지운 사본을 줘야 한다.

관련: [[inas110_bare_par3x2_pure_cell]] [[inas100_MA_copassiv_tree_08]]
[[species_aliases_mechanism]]
