---
name: mote2-defect-package-setup
description: MoTe2 결함 계산을 Defect_Package 클론 2개(2H/1T)로 전환. ★패키지에 magmom 다중중심+neighbor_count 커밋(053005b)
metadata:
  node_type: project
  type: project
---

`~/materials/moTe2/03-Defect/` (2026-09-08). 폴더명 `03-Vte_defect` → **`03-Defect`** (V_2Te 도 들어가서).

## 구조 — 클론 2개 (패키지 표준 "시스템당 클론 하나")

```
03-Defect/
├── 2H/POSCAR_prim_2H      1T/POSCAR_prim_1T
├── 2H/01-Size_scan/       (완료 → [[mote2_vte_size_scan_results]])
├── tools/                 2D 전용: plot_band.py, make_kpath.py, build_cells.py, analyze_size.py
├── 2H-defect/  1T-defect/ ← github.com/2-2much/Defect_Package 클론
└── __pre_package_2026-09-08__/  직접 만들었던 임시 셋업(폐기, 보관용)
```

phase 를 합치지 않은 이유: 패키지가 `pure` 하나를 전제하는데 2H·1T 는 pristine 참조가 다르다.
합치면 `delta_atoms`·μ 참조가 꼬인다. tgm-master 에서 GitHub 접근 정상(인증 이미 됨).

## ★ 패키지에 올린 개선 (커밋 053005b, origin/master)

`build_magmom_string()` 이 **모든 결함을 "단일 자리 + 최근접 4개"로 가정**하고 있었다.
둘 다 zincblende 전용이라 다른 데선 조용히 틀린 시드를 만든다:
- MoTe2 5×5 에서 하드코딩 `n=4` 가 **3.50 Å 떨어진 Te 까지** 모멘트를 준다
  (진짜 dangling bond 는 2.717 Å 의 Mo 3개)
- di-vacancy 는 **두 빈자리 중 하나 주위에만** 시드된다

추가한 것 두 개, 둘 다 opt-in 이라 기존 InAs config 는 한 줄도 안 고쳐도 된다:
- **`defects.yaml` 최상단 `neighbor_count`** — 결함 자리의 배위수. pristine 격자의 성질이라
  결함별 하위 키가 아니라 파일 맨 위에 한 번. `prepare_defect_workflow` 가 전 case 에 주입. 없으면 4
- **`defect_centers_frac`** (리스트) — 빈자리가 여럿인 결함. 없으면 기존 `defect_center_frac` 로 폴백

⚠**`defect_center_frac` 의 의미는 안 바꿨다.** `run_charged_corrections.py` 와
`run_bandfill_corrections.py` 가 보정 중심 3-벡터로 소비하므로 리스트를 주면 안 된다.
MAGMOM 시딩만 복수형 키를 읽는다.

우선순위: **`reference_neighbors` > `neighbor_count` > 기본 4**.

## MoTe2 config (두 클론 동일)

3단계. `stages.yaml` 의 `spin_mode` 가 우리가 손으로 만들던 흐름 그 자체다:
```
01_relax_nsp   spin=nonmagnetic     copy=[]         ISPIN=1
02_relax_sp    spin=magnetic_seed   copy=[]         ★비워야 MAGMOM 이 산다
03_band_sp     spin=magnetic_seed   copy=[CHGCAR]   ICHARG=11 (MAGMOM 은 무시됨, ISPIN=2 목적)
```
- INCAR 템플릿에서 **ISPIN 을 뺀다** (stage 가 주입). ENCUT400/EDIFF1E-4/EDIFFG−1E-2/ISIF0/ISYM0/LREAL A/KPAR1
- KPOINTS: 5×5 는 **2H(a=3.5026)·1T(a=3.4421) 모두 `3 3 1`** → config 공유 가능
- `runtime.yaml`: g1 12노드×12, VASP 6.5.1 dftd4, `neighbor_moment: 2.0`
- `defects.yaml`: `neighbor_count: 3` (Te 자리=Mo 3배위, 2.717/2.733 Å)
- `defect_center_frac` 는 POSCAR 이 있어야 채운다 → **주석 처리해 둠**(없으면 패키지가 명확히 실패)

POSCAR 규약은 패키지식 `inputs/pure/POSCAR`, `inputs/defects/<name>/POSCAR`.
사용자가 `/make-surface-defect` 로 만들어 **눈으로 확인 후** 넣는다.

## V_2Te 정의 (사용자 지정)
- **2H**: 면내 좌표가 같은 Te 두 개(수직 정렬 쌍, 3.6299 Å). **같은 Mo 3개**에 배위 → 시드 3개
- **1T**: top Te + 최근접 bottom Te(4.2459 Å). 그런 이웃이 **3개인데 C3 로 전부 등가**라 배치 모호성 없음.
  서로 다른 Mo 에 배위 → 시드는 합집합(5~6개)

## ⚠ 패키지 운용 함정 (메모리 [[defect_package_repo]] 요약)
- `scripts/` 를 심링크로 두지 말 것 — compute 노드가 /mnt/hohenberg 를 못 봐 잡이 0초에 죽는다
- 계산 폴더에서 `git checkout`/`restore` 금지 — 작업 config 가 템플릿으로 되돌아간다
- `example/config` 를 시스템 값으로 고쳐 push 금지(공유 템플릿 오염)

관련: [[defect_package_repo]] [[mote2_vte_defect_setup]] [[mote2_vte_size_scan_results]]
