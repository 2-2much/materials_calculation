---
name: feedback_lecture_note_static_math
description: 렉쳐노트 HTML의 수식은 MathJax CDN 대신 정적 HTML로 써야 한다 (사용자 뷰어에서 외부 스크립트가 안 돌아 TeX가 날것으로 보임)
metadata:
  type: feedback
---

렉쳐노트 HTML에 수식을 넣을 때 **MathJax CDN 로더를 쓰지 말고 처음부터 정적 HTML**로 쓴다.
`<i>E</i><sub>C</sub>&minus;<i>E</i><sub>F</sub>` 같은 마크업 + 분수는 CSS 가로줄
(`.eqblock{display:block;text-align:center}` / `.frac .num{} .frac .den{border-top:1px solid currentColor}`).
`.eqblock`은 `<div>`가 아니라 `display:block`인 `<span>`으로 만들어야 `<p>` 안에 넣어도 문단이 깨지지 않는다.

**Why:** 사용자는 HTML을 서버가 아니라 로컬 미리보기(preview)로 연다([[feedback_html_preview]]).
그런 뷰어는 외부 스크립트를 차단하므로 `\(...\)`가 TeX 소스 그대로 노출된다 — 사용자가 "수식 깨졌다"고 부르는 증상.

**How to apply:** /lecture-note로 새 노트를 만들 때 head에 MathJax script를 넣지 않는다.
기존 노트에서 "수식 깨짐" 신고가 오면 인라인/디스플레이 수식을 전부 정적 HTML로 치환하고 MathJax 로더를 제거한 뒤,
body에 `\(` / `\[`가 남아 있지 않은지 grep으로 확인한다. [[feedback_interactive_lecture_notes]]
