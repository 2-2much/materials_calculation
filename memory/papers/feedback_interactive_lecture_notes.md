---
name: feedback_interactive_lecture_notes
description: "논문 공부는 인터랙티브 HTML 렉쳐노트로 — /lecture-note 스킬, 질문복사→답채우기 순환"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6e3c655c-ea3e-4b7f-8316-0b33f694c92c
  modified: 2026-08-17T09:27:38.092Z
---

사용자는 논문 공부를 **인터랙티브 HTML 렉쳐노트**로 하는 것을 선호한다. `/lecture-note` 스킬로 구현됨 (`.claude/skills/lecture-note/SKILL.md`, 레퍼런스 구현: `~/papers/Band_alignment/lecture_note_band_alignment.html`).

**핵심 워크플로우(질문↔답변 순환):**
- 렉노 HTML의 각 섹션에 `❓ 질문` 버튼 → 질문 입력칸 → `📋 질문 복사` 버튼.
- 복사하면 질문 + 렉노파일·원논문 절대경로 + `id="qa-sN"` 위치 지시가 `[렉쳐노트 Q&A]` 블록으로 클립보드에 담김.
- 사용자가 이를 **터미널의 Claude에 붙여넣음** → Claude는 해당 HTML을 열어 그 섹션의 `.qa-answers`에 답변을 정리해 추가(기존 답변 보존).
- 이렇게 렉노가 대화를 거치며 계속 발전한다.

**좌우 날개 분리 (2026-08-17 사용자 요청):** ❓날개가 너무 많아 "내가 한 질문"을 찾기 어렵다는 피드백.
→ **왼쪽 날개 = 언제나 ❓(질문하기)**, **오른쪽 = 내 질문 전용**으로 역할을 분리한다. 오른쪽 3종 세트:
1. 블록별 `.qa-mark` 💬N 초록 마커(답변 있는 블록에만 생김)
2. 화면 오른쪽 가장자리 `.qa-rail` 미니맵 — 문서 스크롤 비율 위치에 초록 점, hover 시 섹션명 라벨, 클릭 점프
3. 우상단 `💬 내 질문 N` 버튼 → `.qa-nav` 목록 패널(섹션명 + 질문 전문, 클릭하면 해당 답변으로 점프 + flash)

레퍼런스 구현: `~/papers/SEAL_InAs/lecture_note_branch_point_monch1997.html` (CSS `--- 내 질문 마커 ---` 이하 + JS 하단 블록).

**Why:** .html로 만드는 이유가 바로 이 인터랙티브 질의응답과 그로 인한 이해 축적. 단순 정적 노트가 아님.

**How to apply:**
- 새 논문 공부 요청 → `/lecture-note` 스킬 사용. 비전문가 눈높이, 목차 앵커 네비, 섹션별 Q&A 블록 필수.
- 이해를 돕기 위해 **움직이는 SVG/CSS 애니메이션**(GIF 대체)을 종종 넣는다.
- `[렉쳐노트 Q&A]` 붙여넣기를 받으면 = 답 채우기 모드(스킬 모드 B).
- 서버 열람은 `python3 -m http.server` + VS Code 포트포워딩/Simple Browser.

관련: [[research_topic_n-type_InAs_QD]] 등 공부 주제 전반에 적용. 분석 노트는 `~/papers/memory/paper_notes/`에 별도 저장.
