---
name: feedback_html_preview
description: HTML 렉쳐노트는 직접 미리보기로 열 수 있으므로 http.server/포트포워딩 안내 불필요
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1da45e1a-046f-43a6-8022-957b83631a21
---

렉쳐노트 등 .html 파일을 만든 뒤 `python3 -m http.server` 실행이나 VS Code 포트 포워딩 보는 법을 안내하지 말 것. 사용자가 에디터 미리보기로 직접 연다.

**Why:** 사용자가 명시적으로 "미리보기로 열 수 있어서 포트 포워딩 필요없다"고 밝힘.
**How to apply:** HTML 산출물 전달 시 파일 경로만 알려주고, 서버 실행/포워딩 단계는 생략. [[feedback_interactive_lecture_notes]]
