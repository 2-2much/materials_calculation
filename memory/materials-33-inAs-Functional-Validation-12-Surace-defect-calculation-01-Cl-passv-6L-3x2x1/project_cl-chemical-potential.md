---
name: cl-chemical-potential
description: Cl₂ 분자 PBE 화학퍼텐셜 계산 결과 (ENCUT 300/400 비교)
metadata: 
  node_type: memory
  type: project
  originSessionId: 2a1d2738-0790-4139-bf5c-e4d377314dd5
---

Cl₂ 분자 PBE 계산 완료. 두 ENCUT 조건에서 μ_Cl 차이 ~2 meV로 무시할 수준.

**계산 위치:** `~/materials/33-inAs/__Ligands_and_Chemicals__/05-Cl2-molecule/01-PBE-Gamma/`
- `ENCUT300/`: E(Cl₂) = -3.57030 eV → μ_Cl = -1.78515 eV
- `ENCUT400/`: E(Cl₂) = -3.57450 eV → μ_Cl = -1.78725 eV

**기존 계산 (같은 상위 폴더):**
- LDA (00-LDA-Gamma): E(Cl₂) = -3.98913 eV → μ_Cl = -1.99457 eV
- HSE AEXX=0.30 1-shot (02-HSE-1shot-Gamma): E(Cl₂) = -5.74590 eV → μ_Cl = -2.87295 eV

**POTCAR:** PAW_PBE Cl 06Sep2000 (from `2.POTPAW.PBE.64.RECOMMEND`)

**Why:** 슬랩 defect 계산(ENCUT=300)과의 일관성 확인. ENCUT 차이에 의한 오차 negligible.
**How to apply:** 슬랩 계산과 일관성을 위해 ENCUT=300 값(μ_Cl = -1.785 eV)을 사용. [[chemical-potential-cli]]
