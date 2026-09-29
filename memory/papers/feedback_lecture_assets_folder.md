---
name: feedback-lecture-assets-folder
description: 렉노 figure 파일은 주제 폴더의 lecture_assets/<논문slug>/ 에만 저장 (폴더 루트에 흩어두지 않음)
metadata:
  type: feedback
---

렉쳐노트용 그림(png/jpeg)은 `~/papers/<주제>/lecture_assets/<논문slug>/figN.png`에 저장하고 HTML은 그 상대경로로 참조한다.

**Why:** 2026-09-29 사용자가 "Figure 파일들은 Lecture assets 폴더 만들어서 거기 넣어줘. 이전 것들도 그렇게 해줘"라고 요청. 루트에 fig1.png가 여러 논문 것으로 섞이면 충돌·혼란.
**How to apply:** 새 렉노·발표 HTML 만들 때 항상 이 경로 사용. 그날 Band_alignment, Near_perfect_light_Abs, charged_error_correction_in_bulk(figs/ 포함), charged_QD의 루트 그림을 모두 이동 완료. lecture-note 스킬 SKILL.md에도 반영. 관련: [[feedback_interactive_lecture_notes]]
