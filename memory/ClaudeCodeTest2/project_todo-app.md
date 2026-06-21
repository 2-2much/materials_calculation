---
name: project-todo-app
description: 이전 대화에서 Python CLI 기반 Todo 앱을 구현함 — 추가/목록/완료/삭제 기능 및 테스트 포함
metadata: 
  node_type: memory
  type: project
  originSessionId: ebdc0dc7-fb3e-4375-82fd-618b3f28b01a
  server: kohn
---

이전 대화에서 Python CLI 기반 Todo 앱을 만들었음.

## 구조
- `todo.py`: 메인 앱. JSON 파일(`todos.json`)을 스토리지로 사용하는 CLI Todo 관리 도구.
  - 기능: `add`, `list`, `done`, `delete` (커맨드라인 인자 기반)
  - 각 todo는 `{id, title, done}` 구조
- `test_todo.py`: 테스트 파일. `add_and_load`, `complete`, `delete` 테스트 포함. pytest 없이 직접 실행 방식.
- `todos.json`: 실제 데이터 파일. 현재 "클로드 테스트" 항목 1개 있음.

**Why:** 사용자가 이 프로젝트의 작업 이력을 기억해 달라고 요청함.
**How to apply:** 이후 대화에서 이 앱의 기능 확장, 버그 수정, 리팩토링 요청 시 기존 구조를 기반으로 작업할 것.
