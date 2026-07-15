---
name: feedback_arxiv_source_skill
description: "논문 소스는 arxiv-source 스킬로 원본 TeX 다운로드, 그림중심 논문은 PDF 이미지 판독 병행"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 23cc612b-adc7-4752-8ceb-2a2d038241ed
---

논문 정독·렉쳐노트 작업 시 원문 확보 전략.

**Why:** 출판 PDF에서 텍스트 추출하면 σ′·아래첨자·그리스문자가 뭉개지고 그림은 이미지에 묻힘. arXiv 원본 소스는 저자가 올린 진짜 LaTeX+그림파일이라 변환오류 없음(=다운로드지 변환 아님). 단 arXiv에 없는 논문(저널 OA전용, 예: 일부 Nat.Commun.)이나 저자가 PDF만 올린 경우엔 TeX 소스가 없음.

**How to apply:**
- 수식·이론 중심 논문 → `/arxiv-source` 스킬로 원본 TeX 먼저 확보(`.claude/skills/arxiv-source/`). 검증된 파이프라인: `curl -sL -A "<UA>" https://arxiv.org/e-print/<id>` → `file`로 gzip(=TeX)/PDF(=PDF-only) 판별 → `tar xzf`(실패시 gunzip). 이 서버 curl/wget/tar/gunzip 모두 사용가능, WebFetch로 arXiv API 제목검색해 ID 확정.
- **그림의 물리적 의미 설명이 목적이면 TeX만으론 부족** → PDF를 Read로 페이지 이미지 판독(`pdftoppm -r 150` + `convert` crop). TeX의 `\includegraphics`는 파일명만 있고 그림 내용은 이미지에 있으므로.
- 둘 다 있으면 이상적. arXiv 없으면 PDF 판독 폴백.

관련: [[feedback_interactive_lecture_notes]] (렉노 생성), [[feedback_html_preview]]
