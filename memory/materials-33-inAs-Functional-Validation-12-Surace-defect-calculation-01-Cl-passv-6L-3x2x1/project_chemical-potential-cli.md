---
name: chemical-potential-cli
description: plot_DFE_from_raw_energies.py 화학퍼텐셜 CLI를 --mu_X + --conditions 방식으로 일반화 완료
metadata: 
  node_type: memory
  type: project
  originSessionId: fdb4f339-fbdd-4a40-aa7b-c267b659b424
---

plot_DFE_from_raw_energies.py의 화학퍼텐셜 인터페이스를 일반화함 (2026-06-23).

**새 CLI:**
- `--mu_In`, `--mu_As`, `--mu_Cl`, `--mu_InAs` 등 `--mu_X VALUE` 형식 (대소문자 보존, parse_known_args 동적 파싱)
- `--conditions In-rich As-rich` — 열역학 조건 명시적 지정
- 화합물 자동 탐색: condition species로 formula parsing하여 --mu_InAs 자동 매칭

**변경 이력:**
- 1차: `--mu-in/--mu-as/--mu-inas` (하드코딩) → `--mu SPECIES VALUE` + `--reservoir` 시도 → 사용자 피드백으로 거부
- 2차: `--mu_X VALUE` + `--conditions X-rich` 최종 채택

**Why:** Cl 패시베이션으로 delta_atoms에 In/As 외 Cl도 등장. 임의 원소 추가 시 코드 변경 없이 --mu_X만 추가하면 됨.

**How to apply:** 새 원소 추가 시 plot_DFE.sh에 --mu_NewSpecies VALUE만 추가. 새 화합물은 --mu_Compound VALUE + --conditions 패턴으로 처리.
