# Materials Project

KAIST VASP DFT 계산 프로젝트. 서버 3대(kohn, sham, bloch)에서 공유.

## 폴더 구조
- 물질별 폴더: InAs, InP, InSb, CdS, PbS, Si, SiC 등
- reproduce 계산은 각 물질 폴더 내 `reproduce/`에 배치

## 메모리 및 설정 동기화
- Claude Code 훅(`.claude/settings.json`)으로 서버 간 자동 동기화
  - **대화 시작(SessionStart)**: `git pull` → `memory/`를 각 Claude 프로젝트 메모리로 복사
  - **응답 완료(Stop)**: Claude 메모리를 `memory/`로 복사 → 자동 커밋+푸시
- 동기화 스크립트: `.claude/sync-memory.sh`
- 대상: `~/materials` 하위 프로젝트 + `~/`(home) 프로젝트의 메모리만 동기화
- 커밋 메시지에 서버명 포함 (예: `Auto-sync: Claude Code session (kohn)`)
- 각 메모리 파일의 metadata에 `server:` 필드로 생성 서버 기록
- `memory/` 내 각 하위 폴더의 `.source` 파일이 Claude 프로젝트 경로와의 매핑을 저장

## 논문 참조
- 논문 정리 노트는 ~/papers/ 에 위치

## 사용 언어
- 한국어로 대화
