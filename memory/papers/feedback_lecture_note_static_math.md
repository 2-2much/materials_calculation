---
name: feedback-lecture-note-static-math
description: 렉쳐노트 수식은 MathJax CDN 금지 — 정적 HTML로. 일괄 변환 스크립트 tex2static.py 있음
metadata:
  type: feedback
---

렉쳐노트 HTML의 수식은 **MathJax CDN 스크립트를 쓰지 않는다**. 정적 HTML
(`<i class="mv">`·`<sub>`·`<sup>`·HTML 엔티티)과 CSS 분수(`.eqblock`/`.frac`)로 작성한다.

**Why:** 사용자는 VS Code 미리보기로 파일을 직접 여는데, 이 뷰어가 외부 CDN 스크립트를 차단한다.
그러면 `\(E_C-E_F\)` 같은 **TeX 소스가 날것 그대로 화면에 노출**된다 = "수식 깨짐".

**How to apply:**
- 새 렉노는 처음부터 정적 HTML로 쓴다. (`/lecture-note` 스킬 SKILL.md에 반영됨)
- 이미 TeX로 쓴 파일은 일괄 변환:
  `python ~/papers/.claude/skills/lecture-note/references/tex2static.py <파일>.html ...`
  (`--dry` 로 미변환 매크로만 먼저 확인 가능)
- 이 스크립트가 하는 일: MathJax 설정+로더 제거 → `.eqblock/.frac/.vec/.ovl/.ubrace/...` CSS 주입
  → `\(...\)`·`\[...\]` 를 HTML로 변환. 매크로 110여 종 지원.
  `<script>/<style>/<code>` 안과 **태그 속성값**(`data-title="..."`)은 안전 처리(속성 안에는 태그 없이 평문).
- 2026-08-18에 papers 저장소의 렉노 **21개 전부** 이 방식으로 변환 완료.

[[feedback_interactive_lecture_notes]] · [[feedback_figure_extract_white_bg]]
