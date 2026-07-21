---
name: cl2_hse06_calc
description: "Cl2 분자 HSE06(AEXX=0.27) 계산 이력 — 값은 재현·확정됨(→mu_reference_phases). LHFSKIP+ALGO=Normal 선택 근거 보존. ENCUT400은 미완/불필요 판정"
metadata: 
  node_type: memory
  type: project
  originSessionId: 812cd4f3-de52-4c7a-9645-51849dcce7e5
  modified: 2026-07-21T09:24:08.894Z
---

## Cl₂ 분자 HSE06 계산 (2026-06-26 최초, 2026-07-21 정리)

경로: `33-inAs/__Ligands_and_Chemicals__/05-Cl2-molecule/12-HSE06-Gamma/ENCUT300/`

**⚠ 확정값은 여기가 아니라 [[mu_reference_phases]]에 있음** (μ_Cl(Cl₂) = −2.697957 eV).
이 메모리는 계산 이력과 설정 근거만 보존한다.

### 값 재현 확인 (2026-07-21)
2026-06-26 기록 **−5.3953 eV**(job 52423) ↔ 2026-07-21 재계산 **−5.39591358 eV**.
**0.6 meV 일치** → 원 값 유효, 재현성 확인. d(Cl–Cl) = 1.9647 Å (실험 1.9879).

### ENCUT400 — 미완, 그리고 불필요
당시 job 52424로 제출했다고 기록돼 있으나 **결과가 트리에 없음**(다른 서버에 있거나 유실).
**추적 불요**: ENCUT=300 세트는 ΔE_f(HCl)를 실험 대비 **2.6 meV**로 재현해 이미 검증
통과했다([[mu_reference_phases]]). ENCUT 수렴을 ENCUT400으로 확인하려던 원래 계획은
이 검증으로 대체됨.

### INCAR 주요 설정 (기준상 세트 공통 footing)
AEXX=0.27 / LHFCALC=.T. / HFSCREEN=0.2 / **PRECFOCK=fast** / LHFSKIP=.T. /
ALGO=Normal / NSW=1000, IBRION=1, EDIFFG=−0.015. PBE CONTCAR를 POSCAR로 스테이징.

### LHFSKIP + ALGO=Normal 선택 이유 (유효)
LHFSKIP은 이온 이동 시 HF 교환을 건너뛰고(PBE force로 이완) 마지막 step에만 HF를 포함한다.
따라서 실질적 SCF가 PBE 수준에서 돌아 ALGO=Normal로도 안정 수렴한다.
ALGO=All은 HSE 완전 이완(LHFSKIP 없을 때) 권장.

### ⚠ 바이너리
원 기록의 `vasp.6.5.1.**dftd4**.wan90.beef.plugin.lhfskip.gam.x`는 **g2 파티션 전용**이다.
cascade 노드엔 그 빌드가 없어 그대로 쓰면 exit 127로 즉사 →
`vasp.6.5.1.wan90.beef.plugin.lhfskip.gam.x` 사용.
