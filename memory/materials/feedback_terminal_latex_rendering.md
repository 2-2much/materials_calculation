---
name: feedback_terminal_latex_rendering
description: "Claude Code 터미널은 LaTeX \\color·\\hline·복잡한 aligned를 렌더링 못 한다. 강조는 색이 아니라 이름·표·별표로"
metadata:
  type: feedback
---

2026-09-08. JCC Eq.(4)−(6) 상쇄를 설명하며 `aligned` 안에 `\color{gray}{...}`와 `\hline`을 썼더니
수식 블록이 통째로 깨졌고, "회색으로 칠한 두 항"이라는 지시어가 가리키는 것이 화면에 없었다.

**Why:** 터미널 마크다운 렌더러는 색·표 괘선이 들어간 LaTeX를 처리하지 못한다.
색으로 지시하면 사용자는 존재하지 않는 것을 찾게 된다.

**How to apply:**
- 수식은 **한 줄짜리 display 수식**으로 쪼갠다. `aligned`+`\hline`+`\color` 금지.
- 항을 구분해 가리켜야 하면 **A/B/C/D 같은 이름표 + 마크다운 표**를 쓰고, 코드블록으로 정렬한다.
- "회색으로 칠한", "빨간 항" 같은 **색 지시어를 지시대명사로 쓰지 않는다** — 이름으로 부른다.

관련: [[feedback_model_first_not_precision]]
