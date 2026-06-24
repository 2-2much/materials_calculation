---
name: bloch-workspace-setup
description: bloch 서버 VS Code workspace 파일 설정 진행 중 (로컬 Windows PC)
metadata: 
  node_type: memory
  type: project
  originSessionId: 9169cc2f-99e2-4b89-83f5-ef17c918b612
---

bloch 서버 접속용 VS Code workspace 파일 설정 진행 중 (2026-06-24 시작).

**완료된 것:**
- bloch-materials.code-workspace 파일 생성 완료 (`/home/jaegwan97/materials/bloch-materials.code-workspace`)
- 내용: `ssh-remote+bloch` → `/home/jaegwan97/materials`
- bloch 서버 주소: `bloch.kaist.ac.kr` (143.248.247.246)
- tgm-master의 `~/.ssh/config`에 Host bloch 추가 완료

**남은 작업:**
- 로컬 Windows PC (`C:\Users\정재관\.ssh\`) 에서 `config.txt` → `config`으로 파일 이름 변경 (확장자 제거)
- config 내용: Host bloch / HostName bloch.kaist.ac.kr / User jaegwan97
- 로컬에서 `ssh bloch` 접속 테스트
- workspace 파일을 로컬 바탕화면으로 복사: `scp jaegwan97@bloch.kaist.ac.kr:/home/jaegwan97/materials/bloch-materials.code-workspace C:\Users\정재관\Desktop\`
- 더블클릭으로 VS Code 연결 확인

**Why:** bloch 서버 materials 폴더에 빠르게 접속하기 위한 바탕화면 단축키
**How to apply:** 다음 대화에서 이어서 진행할 때 참조
