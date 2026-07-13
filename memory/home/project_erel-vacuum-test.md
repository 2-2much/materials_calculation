---
name: project_erel-vacuum-test
description: "Ongoing test — is q+1 relaxation energy E_rel vacuum-independent? Setup in __SCPC-test__, plus SCPC-test folder semantics"
metadata: 
  node_type: memory
  type: project
  originSessionId: 1297c17b-084f-48f0-af37-849b065aa6b4
---

**진행 중 작업 (2026-07-13 세팅 완료, job 제출 대기).** Cl-As_In(+1)의 완화 에너지 `E_rel(+1) = E(+1,R_q0) − E(+1,R_q+1)`가 vacuum 크기에 무관한지 실증. FC 분해([[project_transition-level-fc-decomposition]])에서 E_rel을 한 값으로 써도 되는지 확인용.

**이론 기대:** 두 항 모두 q=+1·같은 vacuum이라 발산하는 monopole self-energy(∝q²)가 상쇄 → E_rel은 vacuum-무관(수렴). 단 **반드시 두 항을 같은 vacuum에서** 계산해야 함. (기존 파이프라인 summary.csv의 "E_relax" −2.85→−4.58 발산은 relaxed +1을 단일 고정값으로 쓰고 vacuum별 bare E(+1,R_q0)를 빼서 생긴 artifact였음.)

**세팅:** 경로 `12-Surace-defect_calculation/01-Cl-passv_6L_3x2x1/calc/Cl-As_In/__SCPC-test__/`. vac_{20,30,40}A 각각에 새 폴더 `q+1_Rq0/` 생성 — `q+1_pre`(bare) 설정 그대로 복제하고 POSCAR만 `q0`(R_q0 중성구조)로 교체. 분석: `python3 __SCPC-test__/compute_Erel.py`.
- 실행: `for v in vac_20A vac_30A vac_40A; do (cd $v/q+1_Rq0 && sbatch run.sh); done` (ISTART=0/ICHARG=2, WAVECAR 불필요)
- E_rel = q+1_Rq0/OUTCAR − q+1_pre/OUTCAR. spread <~10 meV면 vacuum-무관 확정.

**__SCPC-test__ 폴더 의미 (reference, 다 NSW=0 single-point):**
- `q0` = 중성 @ **R_q0**(중성 relaxed 구조)
- `q+1_pre` = +1 @ **R_q+1**(charged relaxed 구조), **SCPC OFF (bare)**
- `q+1` = +1 @ **R_q+1**, **SCPC ON** (REFCHG/REFPOT←q0, WAVECAR←q+1_pre). q+1_pre와 같은 구조(변위 0)인데 TOTEN ~3 eV 차이나는 건 SCPC on/off 때문.
- `q+1_Rq0`(신규) = +1 @ **R_q0**, bare. R_q0와 R_q+1 차이 = 0.224 Å.
- 설정: PBE(LHFCALC 없음), ENCUT=300, ENAUG=600, NELECT=742, vasp.6.6.0 scpc 바이너리.

**주의:** __vertical_scan__(R_q0)과 __SCPC-test__(R_q+1)는 절대에너지 기준이 달라 교차로 빼면 안 됨(E_rel 음수=비물리 나옴). 반드시 한 디렉토리 내에서 계산.
