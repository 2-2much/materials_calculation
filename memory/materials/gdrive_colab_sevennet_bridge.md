---
name: gdrive_colab_sevennet_bridge
description: "Google Drive 커넥터로 Colab SevenNet 연동 — Claude는 Drive 파일 읽기/쓰기만, Colab 셀 실행은 사용자가. 기존 노트북·결과 폴더 ID"
metadata:
  node_type: memory
  type: reference
  originSessionId: 5617dea8-2982-4bbf-bc24-a593e179e1bc
  modified: 2026-09-27T05:10:57.316Z
---

2026-09-27 연결 확인 (claude.ai Google Drive 커넥터, 계정 = 사용자 본인 gmail).

## 역할 분담
- Claude: Drive에 입력(POSCAR/파라미터/노트북) 올리기, 결과 파일 내려받아 분석
- **Colab 런타임 실행은 Claude가 못 한다** — 사용자가 노트북 열고 Run all
- 다운로드는 base64로 통째 → traj/대형 ipynb(출력 포함 1.2MB)보다 **작은 요약 파일**(log, CONTCAR, csv)을 읽을 것

## 기존 Drive 자산 (ID)
- 노트북 `sevennet_temperature_md_colab_cueq.ipynb` = `1FvXatk5SBq4lY7UwNybCZZ_oXdWAdBcK` (최신, 09-26 수정, 부모 `13jaqQ4pUUjTKDkze21E5ZIR8ZFxOBwOu`)
- 노트북 비-cueq판 = `1AXhMzfjBaF388kPZY4rYZPPEoOeIQ43L`
- 결과 폴더 부모 `1bpnUkGdkRqXfy0p4HH1h96MNAzqPPeP-`: `sevennet_md_results_1.07strained_omni-i12_SingleV`/`_DiV`, `_1000-300K`, `_2000-0K`
- `sevennet-test` 폴더 = `1xCqLN7DG6uOE7e7IlArTHg8g1EVmz2kC` (My Drive 루트)

관련: [[sevennet_jh_tool]] [[feedback_code_and_readme_only]]

## ⚠ 큰 파일 업로드
커넥터 업로드는 내용을 tool 인자로 직접 넣어야 함 → 1000줄 POSCAR(59KB)는 비현실적·오류위험. 
**Drive에 이미 있는 원본 + 작은 생성 스크립트(md5 자체검증)** 를 올리고 Colab에서 `!python` 으로 만들게 할 것.
예: `Armchair_9x10/make_AC_DiV.py`(2026-09-27) → A/B/C 15·30·45 DiV AC 구조. 파일크기로 업로드 무결성 확인.
