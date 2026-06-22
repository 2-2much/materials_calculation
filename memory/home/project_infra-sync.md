---
name: infra-sync
description: "서버(kohn/sham/bloch/tgm-master) 간 프로젝트 구조, Git 동기화 전략, Claude Code 설정 공유 범위 종합"
metadata: 
  node_type: memory
  type: project
  originSessionId: 8eb65f43-70c9-449a-95ce-27d3f33a4b7b
---

## 프로젝트 분리

```
~/materials/                ← Git repo (VASP DFT 계산, 대용량)
  CLAUDE.md
  .gitignore
  .claude/commands/         ← 커스텀 skills (Git 공유)
  .claude/agents/           ← 커스텀 sub-agents (Git 공유)
  .claude/settings.json     ← 프로젝트 권한 (Git 공유)
  .claude/settings.local.json ← 로컬 전용 (.gitignore)
  InAs/ GaAs/ reproduce/

~/papers/                   ← 별도 Git repo (논문 읽기/정리, 가벼움)
  CLAUDE.md
  InAs/ GaAs/
```

**Why:** materials는 VASP 대용량, papers는 텍스트 중심. 논문이 여러 물질에 걸칠 수 있어 분리가 깔끔함.

## 동기화 전략

```
GitHub ↕ kohn / sham / bloch / tgm-master (materials + papers)
GitHub ↕ 로컬 PC (papers만 clone)
```

- sham/bloch에는 이미 materials/가 존재 → git clone 불가, git init + remote add로 연결
- reproduce 계산은 `~/materials/{물질명}/reproduce/`에 배치
- papers의 CLAUDE.md에서 reproduce 경로 참조

## Claude Code 설정 공유 범위

| 파일 | Git 공유 | 비고 |
|---|---|---|
| CLAUDE.md | 가능 | 프로젝트 지침, insights 반영 |
| .claude/commands/ | 가능 | DFT 커스텀 skills |
| .claude/agents/ | 가능 | DFT 커스텀 sub-agents |
| .claude/settings.json | 가능 | 프로젝트 권한 |
| .claude/settings.local.json | 불가 | .gitignore 대상 |
| ~/.claude/ (홈) | 별도 관리 | 메모리, 글로벌 설정 — 서버별 개별 설정 |

개인 선호도(언어 등)는 각 서버의 `~/.claude/CLAUDE.md`에 별도 설정.

## 현재 진행 상태 (2026-06-22)

- GitHub repo: `2-2much/materials_calculation` (push 완료)
- kohn: git init 완료, push 완료
- tgm-master: materials git 연결 완료, 메모리 동기화 작동 중
- sham/bloch: 아직 git 미연결 — 각 서버에서 아래 순서로 설정 필요:
  ```
  cd ~/materials
  git init
  git remote add origin https://github.com/2-2much/materials_calculation.git
  gh auth login   # 최초 1회
  git fetch origin
  git checkout main
  ```
- .claude/settings.json: 서버 공통 권한만 포함, 로컬 전용은 settings.local.json으로 분리

## papers 메모리 동기화 (2026-06-22 추가)

- papers(`~/papers/` → `/mnt/hohenberg/.../papers/`)의 `.claude/settings.json`은 hohenberg를 통해 서버 간 공유됨
- 하지만 Claude 프로젝트 메모리(`~/.claude/projects/.../memory/`)는 서버별 로컬
- `sync-memory.sh`의 `is_syncable_project()` 필터에 papers slug(`-mnt-hohenberg-*-papers*`) 추가하여 해결
- `~/materials/memory/papers/.source`에 매핑 저장
