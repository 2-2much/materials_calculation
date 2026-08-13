---
name: vasp_zero_count_species
description: "POSCAR에 개수 0인 종 블록을 두면 VASP 6.5.1이 segfault. 단일 POTCAR 공유 편법은 불가"
metadata:
  type: reference
---

2026-08-13, 실측. 결함 셋에서 **Cl 이 일부 셀에만** 있을 때 POTCAR 를 하나로 통일하려고
"5종 POTCAR + POSCAR 에 `Cl 0`" 을 시도했다.

## ❌ 안 된다 — VASP 6.5.1 segfault

```
   In_d      As        H1.25     H.75      Cl
   36        36        6         6         0
```
→
```
POSCAR found type information on POSCAR InAsH1H.Cl
POSCAR found :  5 types and      84 ions
...
Caught signal 11 (Segmentation fault)
```
파싱은 하고 배열 설정 전에 죽는다. NELM=1/NSW=0/Γ-only 라 다른 원인은 없다.
테스트 트리: `11-110bare_6L_par3x2_PBE-d/02-build_defects/__zerocount_test__/`

## 그래서 남는 선택지

Defect Package 의 `check_species_order` 는 POSCAR 종순서 == POTCAR 종순서 완전일치를
요구하고 `runtime.yaml paths.potcar` 는 전역 하나뿐이다. 따라서
(1) 패키지에 케이스별 POTCAR 조립(`potcar_mode: build`) 추가, 또는
(2) defects.yaml 을 종세트별로 쪼개 prepare 2회.

관련: [[inas110_bare_par3x2_pure_cell]] [[species_aliases_mechanism]]
