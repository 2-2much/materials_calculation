---
name: feedback-save-notes
description: 매 대화 종료 전에 대화 내용을 마크다운 노트로 정리하여 주제 폴더에 저장
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 49ed4934-19b2-4387-b54a-9c1787d2b532
---

매 대화 종료 전에 반드시 대화 내용을 마크다운 노트로 정리하여 저장할 것.

**Why:** 사용자가 논문 분석/토론 내용을 Git으로 추적하고 싶어함. Stop 훅이 자동 commit+push하므로 노트만 작성하면 GitHub에 올라감.

**How to apply:**
- 대화에서 논문 분석, 비교, 기술 토론이 있었으면 관련 주제 폴더에 .md 노트로 저장
- 이미 해당 주제 노트가 있으면 날짜와 함께 내용 추가 (새 파일 X)
- 주제 폴더가 없으면 `notes/` 디렉토리 사용
- 별도 git commit 불필요 — Stop 훅이 처리
