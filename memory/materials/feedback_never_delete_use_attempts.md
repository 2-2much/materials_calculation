---
name: feedback_never_delete_use_attempts
description: "계산 디렉토리를 절대 지우지 말 것 — 실패한 시도는 __attemptN__ 으로 보존하고, 재계산은 직전 attempt 의 CONTCAR 를 POSCAR 로 이어받는다"
metadata:
  type: feedback
---

2026-08-18. IP/EA 트리에서 내가 실패한 `01-relax` 배치를 `rm -rf` 로 지우고 재생성했다가
**ZBRENT 실패 증거를 잃었다.** 사용자가 두 번 지적: "함부로 삭제하지 말고,
이전의 실패한 시도는 `__attempt__` 으로 진행하라. 재계산은 이전 attempt 의 CONTCAR 를
POSCAR 로 읽어들여서 진행하라."

**Why:** 실패한 런은 폐기물이 아니라 **진단 증거**다. 무엇이 왜 죽었는지(수렴 이력, 힘,
마지막 기하)는 다음 시도의 설정을 정하는 근거이고, 지우면 재현조차 못 한다. 그리고 이미
극소점 근처까지 간 기하를 버리고 처음부터 다시 돌리는 것은 순수한 낭비다 — VASP 자신도
ZBRENT 실패 시 "copy CONTCAR to POSCAR and continue" 를 권한다.

**How to apply:** 약속으로 두지 말고 **스크립트에서 삭제 경로를 없앨 것.**
`10-Primitive-slab/04-Facet_IP-EA/04-tools/` 에 구현해 둔 형태:

- `rerun_step.sh <STEP>` — 재계산의 **유일한 경로**.
  보존 → 새 스텝 생성 → CONTCAR 시드 → preflight → 제출을 한 번에 한다.
- `new_attempt.sh <STEP>` — `<cell>/<STEP>/` 를 `<cell>/__attemptN__/<STEP>/` 로 **이동**
  (N 자동 증가). 삭제 없음.
- `seed_from_attempt.py` — 새 POSCAR = 직전 attempt 의 CONTCAR.
  ⚠ **VASP CONTCAR 는 종 이름을 자른다**(`H.75`→`H.`, `H1.25`→`H1`). 좌표·selective
  dynamics 플래그는 CONTCAR 것을 쓰되 **6행 종 이름만 원본 셀에서 복원**할 것 —
  안 그러면 VASP 의 POTCAR 대조와 preflight 종순서 검사에 걸린다.
- `prep_runs.py build` — 내용이 있는 스텝 디렉토리를 만나면 **거부**하고
  `new_attempt.sh` 를 쓰라고 안내한다(`--force` 는 있지만 권장 안 함).
- `regen_cells.sh` — `01-cells` 를 지우지 않고 `__cells_attemptN__` 으로 옮긴다.

⚠ 부수 함정: 보존 후 `find 03-runs -type d -name 01-relax` 가 `__attemptN__` 하위까지
잡아서 낡은 `.done` 을 실패로 오탐한다. 라이브 스텝은 깊이 3이므로 감시·스테이징 스크립트에
**`-maxdepth 3`** 를 박을 것.

관련: [[feedback_never_touch_running_calc]] [[initial_poscars_overwrite_guard]]
[[inas_surface_ip_ea_plan]]
