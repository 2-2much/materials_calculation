---
name: stages_yaml_dos_band_contamination
description: stages.yaml의 02/03(DOS/Band) 주석을 푼 채 prepare하면 모든 신규 case에 std 다중 k 단계가 딸려 들어간다 (비용 폭증은 HSE에서만, PBE는 싸다). 사후 삭제 함정과 prepare 모드 선택 포함
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a36501db-d568-4425-8924-3511e61d9a67
  modified: 2026-08-11T06:12:28.011Z
---

`config/stages.yaml`의 `02_G221-DOS`·`03_Band` 블록을 **주석 해제한 상태로 `prepare_defect_workflow.py`
를 돌리면, 그때 만들어지는 모든 case에 DOS(4-k)+Band(20-k) 단계가 자동으로 붙는다.**

## ⚠⚠ 2026-08-11 정정 — 비용 폭증은 **HSE에서만**이다

원래 이 메모리는 "잡 하나가 ~3시간 → 10시간+"라고 적었는데, **그 수치는 HSE06 트리(02/04)에서
나온 것**이다. 사용자 지적: **PBE 계산에서는 해당 없다.** hybrid는 exact exchange 비용이
k점 수에 (사실상) 제곱으로 붙지만, PBE의 다중 k점 SCF는 k점 수에 선형이고 그마저 싸다.

- **HSE 트리** — 02/03을 켠 채 prepare하면 Γ-only 하전 스윕 잡이 3h → 10h+. 켜지 말 것.
- **PBE-d 트리** — DOS/Band를 상시 켜두어도 된다. 09-100AA(162원자)는 4단계를 다 켠 채 제출했다.

즉 **"02/03은 항상 꺼라"가 아니라 "hybrid일 때 꺼라"**가 맞는 규칙이다.
아래 오염/삭제 함정은 functional과 무관하게 그대로 유효하다.

**Why:** prepare는 stages.yaml에 살아있는 모든 스테이지를 case마다 생성하고 `run_case.sh`를
그대로 재생성한다. DOS/Band는 특정 defect의 q0에만 필요한데 stages.yaml은 **전역**이라,
한 목적으로 켜두면 이후 다른 목적의 prepare가 전부 오염된다. 2026-07-22에 실제로 발생했고
제출 직전 검증에서 잡았다.

**How to apply (사전 예방이 원칙 — 2026-07-22 사용자 합의):**
**`prepare_defect_workflow.py`를 돌리기 전에 항상 `config/stages.yaml`을 먼저 열어
"지금 이 목적에 필요한 스테이지만 살아있는지" 확인하고 고친 뒤 prepare한다.**
사후에 지우는 것보다 훨씬 안전하다(아래 삭제 함정 참조). DOS/BAND 제출이 끝나면
**즉시 02/03을 다시 주석 처리**한다. 제출 전에는 항상
`grep -oP 'run_stage "\K[^"]+' <case>/run_case.sh` 로 스테이지 목록을 눈으로 확인.

## ⚠ 사후 삭제는 위험하다 — 판단 기준은 OUTCAR이 아니라 **제출 시점**

SLURM은 **제출 순간 배치 스크립트를 스풀**한다. 따라서 나중에 `run_case.sh`를 재생성해도
이미 큐에 있는 잡은 **옛 스크립트로 실행**된다. 결과적으로:

- `run_case.sh`의 **현재 내용**으로 "이 스테이지는 안 쓰인다"고 판단하면 **틀린다.**
- **"OUTCAR 없으면 안 쓰인 것"도 틀린다.** 아직 시작 안 한 대기 잡의 스테이지 폴더는
  입력 4종(INCAR/INCAR.patch.json/KPOINTS/POTCAR)만 있어 **미사용 폴더와 완전히 구별 불가**다.

2026-07-22 실제 사례: `Cl_As_2/q0`의 02/03이 신규 하전 case들과 파일 구성이 똑같았는데,
**대기 중이던 job 55608이 이어서 실행할 예정**이었다. "OUTCAR 없으면 삭제" 규칙만 적용했으면
그 잡을 망가뜨렸을 것이다. 올바른 절차:

1. `squeue`로 해당 case를 쓰는 잡이 **큐에 있는지** 확인
2. 그 잡의 **제출 시점이 stages.yaml 수정 이전인지 이후인지** 판정
3. 이후 제출분만 삭제 대상. 삭제 전 `find <dir> -type f ! -name INCAR ! -name KPOINTS ...`로 출력물 0건 확인

⚠ `ls -A`는 컬러 별칭 때문에 ANSI 이스케이프가 섞여 `grep` 패턴이 깨진다. 파일 목록 검사는
`find -printf`를 쓸 것.

## 함께 쓰는 prepare 모드 선택

- **`--mode new-only`** — 기존 case를 **통째로 skip**(run_case.sh도 재생성 안 함).
  이미 SLURM에서 돌고 있는 q0를 건드리지 않고 새 charge 폴더만 만들 때 필수.
- **`--mode missing-stage`** — case는 유지하되 없는 스테이지를 채우고 **run_case.sh는 재생성**.
  기존 INCAR/KPOINTS/POTCAR은 존재하면 덮어쓰지 않으므로 **수동 편집(ISTART 등)이 보존된다.**
- **`--mode overwrite`** — INCAR까지 덮어쓴다. 수동 편집이 날아가므로 주의.

⚠ 이미 제출된 잡은 SLURM이 제출 시점에 배치 스크립트를 스풀하므로, 이후 run_case.sh를
고쳐도 영향받지 않는다(= 안전하게 재생성 가능).
⚠ `joblist.txt`는 prepare가 매번 덮어쓰며 **이미 실행 중인 case도 포함**한다. 그대로
`run_joblist.sh ... submit` 하면 같은 디렉토리에 **중복 잡**이 붙는다. 제출 전 `squeue`와
대조해 필터링할 것. → [[slurm_jobname_distinct]] [[server_fs_git_sync_scope]]
