---
name: surface-defect-istart-wavecar-gam-std
description: "12-Surace-defect DOS 단계에서 Gamma-only WAVECAR을 std 바이너리가 못 읽는 문제 → ISTART=0 수정 (2026-07-01)"
metadata:
  node_type: memory
  type: project
  originSessionId: 0b838ed2-3a0f-4b92-a22c-131ab8936454
---

## 증상
`02_G221-DOS`(vasp.std, 2×2×1)가 ICORELEVEL 수정 후 다음 지점에서 사망:
```
ERROR: while reading WAVECAR, plane wave coefficients changed 48187 24094
```
**48187 ≈ 2 × 24094** — 정확히 2배 관계가 원인 지목.

## 원인
- `00_Gam-relax`/`01_Spin-gam-relax`는 **vasp.gam(Gamma-only)** 바이너리로 계산. Gamma-only WAVECAR은 c(G)=c*(−G) 대칭으로 plane-wave 계수를 절반만 저장
- `02_G221-DOS`는 **vasp.std(complex, 2×2×1)** → 전체 계수 기대 → gam WAVECAR 읽으면 개수 불일치로 사망
- run_case.sh의 STAGE_PREP_2가 gam stage의 WAVECAR을 DOS 폴더로 복사하고 ISTART=1로 읽으려던 게 문제

## 수정 (2026-07-01)
- **DOS 단계(02_G221-DOS)만 ISTART=1 → ISTART=0** (템플릿 INCAR_02.G221-DOS + 생성된 q0 5개). Gamma WAVECAR을 아예 안 읽고 2×2×1용 파동함수 새로 생성
- **ICHARG=1 유지**: CHGCAR은 실공간 그리드 기반이라 k-점 무관 → gam→std 호환. seed로 사용
- **03_Band는 ISTART=1 유지**: DOS(std)→Band(std) 경계는 둘 다 complex라 plane-wave 개수 일치 → 정상. gam→std 경계인 DOS 단계만 문제
- ISTART=0이면 STAGE_PREP_2가 복사한 gam WAVECAR이 있어도 무시되므로 무해

## 부작용: HSE-from-scratch 수렴 느림
ISTART=0은 HSE를 맨바닥 오비탈에서 시작 → 초기 SCF 느림([[surface-defect-oszicar-buffering]]의 이중루프와 겹쳐 step 많이 필요). 근본 가속은 "2×2×1 PBE 1shot으로 std-호환 WAVECAR 만든 뒤 HSE ISTART=1로 읽기"이나 stage 하나 추가됨. 현재는 미도입.

**Why:** gam↔std WAVECAR은 plane-wave 저장방식이 달라 호환 안 됨. 바이너리 종류가 바뀌는 stage 경계에서 ISTART=1 restart는 위험
**How to apply:** vasp.gam → vasp.std 넘어가는 첫 std stage는 ISTART=0(WAVECAR 무시), ICHARG=1(CHGCAR seed는 OK). std→std 경계는 ISTART=1 무방. 관련 [[surface-defect-1shot-band-workflow]] [[surface-defect-icorelevel-bug]]
