---
name: feedback-never-touch-running-calc
description: "작업 방식: 실행 중인 계산 디렉토리는 절대 건드리지 말 것. prepare 재실행 시 --only + --mode missing-stage + md5 전후 검증"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f5c1c286-303c-4cef-b4bf-6b89adb7c5ce
  modified: 2026-08-18T00:55:12.782Z
---

2026-08-13 사용자 지시: **"지금 계산 돌아가는 거 덮어쓰지 않도록 조심하라"**
(21-111Cl-MA 트리에서 pure/V_In 이 실행 중인데 stage 01/02/03 을 추가로 셋업하던 중)

**Why**: `prepare_defect_workflow.py` 는 stage 디렉토리에 POSCAR/INCAR/KPOINTS/POTCAR 를 쓴다.
실행 중인 VASP 가 읽고 있는 파일을 갈아엎으면 그 잡이 조용히 망가지고, 몇 시간짜리 이완이
날아간다. `--mode overwrite` 는 특히 위험하다.
(SLURM 은 제출 시점에 batch 스크립트를 spool 로 복사하므로 `run_case.sh` 를 고치는 것 자체는
실행 중 잡에 영향이 없다. 위험한 것은 **stage 디렉토리 안의 입력 파일**이다.)

**How to apply**:
1. 손대기 전에 `squeue -u $USER` 로 그 case 가 도는지 확인한다. **돌고 있으면 기다린다.**
2. 이미 끝난 case 에 stage 를 덧붙일 때는 `--only <case>` 로 대상을 좁히고
   **`--mode missing-stage`** 를 쓴다 (`overwrite` 금지).
3. prepare 전후로 기존 stage 의 입력·출력을 **md5 로 비교해 무결성을 확인**하고 그 결과를 보고한다:
   `md5sum <stage>/{POSCAR,INCAR,KPOINTS,POTCAR,CONTCAR,OUTCAR,OSZICAR} > before.txt`
   → prepare → `md5sum -c before.txt`
4. `--only` 는 `calc/joblist.txt` 를 그 case 들로만 다시 쓴다. 그래서 이어서
   `run_joblist.sh ... submit` 을 해도 실행 중인 다른 case 는 재제출되지 않는다 — 이 성질을
   적극적으로 이용할 것.
5. 폴더 이름 변경 같은 것도 **잡이 완전히 끝난 뒤에** 한다 (`--chdir` 경로가 끊긴다).

관련: [[initial_poscars_overwrite_guard]] [[no_compute_on_login_node]] [[defect_package_repo]]
