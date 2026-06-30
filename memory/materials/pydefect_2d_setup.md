---
name: pydefect_2d_setup
description: "pydefect_2d InAs(110) surface defect 보정 셋업 — 유전율 입력은 슬랩 셀-평균(이방성), 벌크 아님"
metadata: 
  node_type: memory
  type: project
  originSessionId: e32ee6d3-2ec0-4fc9-ad86-95ffaf484917
---

`12-Surace-defect_calculation/03-pydefect_2d/` 에서 pydefect_2d(v0.1.5, conda env `py4vasp`)로 InAs(110) charged surface defect NK 유한크기 보정 진행. 시작 defect: **Cl-As_In q+1** (PBE-d `01-` 완료 데이터, perfect=pure/q0/01_Relax).

**핵심 함정 — 유전율 입력 종류:** `sdd`(step_diele_dist)는 `unitcell.yaml`에 **pristine 슬랩 셀-평균(cell-averaged) 유전율**(진공 포함, 이방성)을 요구한다. 벌크값(InAs ε0=15.15, ε∞=12.3)을 그대로 넣으면 안 됨 — 면수직(z) 구성은 셀 조화평균이 입력값이 되도록 root-find하는데, 진공 때문에 조화평균이 ~1.7 이상 불가 → z plateau가 수천대로 폭주.

**effective-medium 근사 레시피**(LEPSILON 슬랩 계산 없을 때, 사용자 동의한 방식): 물질두께 W, 셀길이 L, 진공 Lvac=L−W에 대해
- 면내(∥, 산술): ε∥ = (ε_bulk·W + Lvac)/L
- 면수직(⊥, 조화): ε⊥ = L/(W/ε_bulk + Lvac)
static·electronic 각각 계산, ion=static−ele. W는 sdd의 `-w`와 **반드시 일치**시켜야 sdd가 슬랩 내부를 벌크로 복원(self-consistent). 우리 값: W=14.77Å(원자 span 6.22–20.99), C=0.5181, L=26.2613. → ele diag(7.355,7.355,2.069), ion diag(1.603,1.603,0.0375).

**정상 결과 확인:** 면내 슬랩 plateau=15.15(벌크 복원 ✓), 면수직 plateau≈7.62. **면수직 내부가 벌크 15.15가 아닌 건 정상** — 슬랩-진공계 면수직 거시응답은 depolarization으로 억제됨(셀-평균 조화 2.107 만족). z를 15.15로 강제 보정하면 틀림(애초에 ~12에서 포화돼 도달 불가).

**LOCPOT 파싱 함정:** VASP LOCPOT 6번째 줄 원소명이 `In As H1 H. Cl`(패시베이션 분수전하 H 라벨) → pymatgen이 `H.`를 못 읽음. 스테이징 LOCPOT 복사본의 6번째 줄을 `In As H H Cl`로 치환하면 됨(보정엔 원소정체성 무관, counts/격자/포텐셜 유지).

워크플로우 순서(README): unitcell.yaml(Step5) → sdd(6) → 1gm(7) → 1fp(8) → gmz(9-10) → ge(11) → 1sm(12, correction.json). 최종 보정값은 기존 [[scpc_vacuum_scan]] / slabcc 결과와 대조 예정. 정확한 값 필요시 추후 perfect 슬랩 LEPSILON 계산으로 unitcell.yaml 교체.
