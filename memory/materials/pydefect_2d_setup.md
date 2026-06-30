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

**Cl-As_In 결함 위치(중요):** As_In antisite = CONTCAR **atom #36**(0-idx 35), frac [0.4173,0.5653,0.7394], **z=19.42Å(표면 상단)**. 판별법: nearest perfect-In≈1.02Å(In 자리에 앉음)이 antisite 기준 — "perfect-As에서 가장 먼 As"로 찾으면 틀림(그건 정상 As의 2nd-neighbor). atom36은 Cl 2개와 2.16Å 결합 = Cl-As_In 표면 복합체. 1fp가 찾은 charge center=z frac **0.81**(antisite+Cl 표면). defect_entry.json: charge=+1, defect_center=atom36 좌표. (1fp는 charge만 사용, defect_center는 1sm eigenvalue shift용)

워크플로우 순서(README): unitcell.yaml(Step5) → sdd(6) → 1gm(7) → 1fp(8) → gmz(9-10) → ge(11) → 1sm(12, correction.json).

**전체 완주 완료(2026-06-30)**: 1gm `-r 0.5 0.82`(33점), 1fp→charge center z=0.81, gmz `-z 0.70~0.92`(12점, 백그라운드 ~3분, 2분 timeout 주의), ge 보간, 1sm. **최종 correction.json (Cl-As_In q+1)**: periodic=1.751, isolated=1.894, alignment=0.181 → **gauss항 +0.143, 정렬항 −0.181, 총 E_corr = −0.038 eV**. eigenvalue_shift=0.471 eV. ⚠전하가 슬랩 표면(z=0.81, 가파른 구간)에 국소화돼 z0 민감. ⚠이 작은/음수 보정은 SCPC(~1.8eV)와 크게 다름 → effective-medium 근사 유전율·lateral 셀·표면 전하 때문일 수 있음, 비교검증 필요. 정확값 필요시 perfect 슬랩 LEPSILON 계산으로 unitcell.yaml 교체(Option A). 결과는 [[scpc_vacuum_scan]] / slabcc(`_chgcar_diff_/`)와 대조 예정.
