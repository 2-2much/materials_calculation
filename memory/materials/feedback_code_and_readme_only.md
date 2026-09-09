---
name: feedback-code-and-readme-only
description: 계산은 코드+README까지만 만들고 실행은 사용자가 직접 한다 (2026-09-09 지시)
metadata:
  type: feedback
---

새 계산을 셋업할 때 **입력 생성기·실행 스크립트·수집 스크립트와 README까지만 만들고
멈춘다.** 사용자가 직접 읽어 보고 실행한다. 내가 `sbatch`/`mpirun`/`nohup`으로
계산을 던지지 않는다.

**Why:** 사용자가 입력을 눈으로 확인한 뒤 돌리고 싶어 한다. 계산 자원은
공유 자원이고, 발판(footing)이 한 번 어긋나면 그 뒤 전체 스캔이 오염된다
([[feedback_never_touch_running_calc]], [[stages_yaml_dos_band_contamination]] 참고).
"실행할 것이다"라는 말은 사용자 본인이 하겠다는 뜻이지 나에게 시키는 뜻이 아니었다.

**How to apply:**
- 산출물 = ① 입력 생성기(단일 진실의 원천) ② 실행 스크립트(옵션은 env로 노출)
  ③ 결과 수집/판정 스크립트 ④ **README.md** — 폴더 트리, 각 폴더가 무슨 계산인지,
  계산 조건의 출처(논문/기존 트리), 실행법, 결과 읽는 법, 함정, 성공/실패 판정표.
- README에는 "왜 이 트리가 존재하는가(답할 질문)"를 맨 앞에 적는다.
- 실행이 필요하면 명령어를 제시하고 사용자에게 넘긴다.
- 예외: 사용자가 명시적으로 "돌려라"라고 할 때만 실행.

참고 사례: `~/materials/__JCC-reproduce__/01-dE0_BN_6x6_Lz30_QE/README.md`
