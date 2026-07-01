---
name: surface-defect-icorelevel-bug
description: "02-Cl-passv_6L_3x2x1_HSE06 DOS/Band 단계 ICORELEVEL=1 파싱오류(IERR=5) config 버그 및 수정 (2026-07-01)"
metadata:
  node_type: memory
  type: project
  originSessionId: 0b838ed2-3a0f-4b92-a22c-131ab8936454
---

## 증상
`02_G221-DOS`, `03_Band` 계산이 시작 즉시 사망:
```
Error reading item ICORELEVEL from file INCAR.
Error code was IERR= 5 ...
I REFUSE TO CONTINUE WITH THIS SICK JOB ... BYE!!!
```
OUTCAR가 INCAR echo 직후(ICORELEVEL 라인) 사망 → **CHGCAR/WAVECAR 읽기 전, INCAR 파싱 단계 사망**. restart 체인(이전 CHGCAR 재사용)과 무관함.

## 원인
`INCAR` line 109: `ICORELEVEL=1<TAB>#corelevel calculation`
- 값(1)과 주석(#) 사이 구분자가 **탭 문자**라 VASP 정수 파서가 `1<TAB>#corelevel`를 정수로 읽으려다 IERR=5(타입변환 실패)
- 활성 라인 중 `값<TAB>#주석` 형태는 이 라인 하나뿐이었음(다른 라인은 전부 공백 구분이라 정상)
- ICORELEVEL은 core-level shift(XPS) 계산용 → DOS/Band와 무관 → 주석처리가 정답

## config 템플릿 불일치 (근본 원인)
- `config/INCAR/INCAR_00.Gam-relax`, `INCAR_01.Spin-gam-relax`: `#ICORELEVEL=1` (주석됨, 정상)
- `config/INCAR/INCAR_02.G221-DOS`, `INCAR_03.Band`: `ICORELEVEL=1` (활성화됨, 버그) ← 다른 템플릿에서 복붙 시 주석 누락 추정

## 수정 (2026-07-01)
`grep -rlP '^ICORELEVEL=1'` → `sed -i 's/^ICORELEVEL=1/#ICORELEVEL=1/'`로 12개 파일 일괄 주석처리:
- 템플릿 2개(INCAR_02.G221-DOS, INCAR_03.Band)
- calc 10개: As_In/q0, Cl-As_In/q0, Cl-As_In/q+1, pure/q0, V_Cl-Cl_As/q0 각 02_G221-DOS + 03_Band

**Why:** 템플릿 버그라 defect 재생성 시 재발 가능. 탭+주석 포맷은 VASP 정수 파서에서 위험
**How to apply:** 새 defect 생성/재생성 후 DOS/Band INCAR에 `^ICORELEVEL=1`(활성) 남아있는지 확인. INCAR 작성 시 값 뒤 구분자는 탭 대신 공백 사용. 관련 워크플로우 [[surface-defect-1shot-band-workflow]]
