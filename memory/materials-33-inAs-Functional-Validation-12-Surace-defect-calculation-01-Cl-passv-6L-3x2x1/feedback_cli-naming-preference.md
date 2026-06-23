---
name: cli-naming-preference
description: "CLI 인자 명명 규칙 — --mu_In 스타일 선호, YAML config보다 CLI 선호"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: fdb4f339-fbdd-4a40-aa7b-c267b659b424
---

CLI 인자에서 화학퍼텐셜은 `--mu_In`, `--mu_As`, `--mu_Cl`, `--mu_InAs` 형식으로 작성.

- 띄어쓰기 없이 언더스코어로 연결 (`--mu_In`, not `--mu In`)
- 원소기호 대소문자 그대로 보존 (`In`, not `in`)
- `--reservoir` 같은 불명확한 태그명 기피 → 의미가 명확한 이름 사용 (`--conditions In-rich As-rich`)

**Why:** 값을 자주 변경해야 하므로 YAML config보다 CLI로 직접 작업하는 것을 선호. 또한 argparse 태그명이 불명확하면 혼란을 줌.

**How to apply:** 새 CLI 인자 추가 시 물리적 의미가 명확한 이름으로 짓고, 값 변경이 잦은 파라미터는 YAML이 아닌 CLI 인자로 노출할 것.
