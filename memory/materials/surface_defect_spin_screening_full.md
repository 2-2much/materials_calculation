---
name: surface_defect_spin_screening_full
description: "02-Cl-passv_6L_3x2x1_HSE06 전 defect 스핀 스크리닝 결과 + ISPIN 분기 방침(2026-07-02 갱신: 전체 ISPIN=2 통일 → 스핀에너지 기반 분기로 전환)"
metadata:
  node_type: memory
  type: project
  originSessionId: 0b838ed2-3a0f-4b92-a22c-131ab8936454
  modified: 2026-07-20T05:30:03.741Z
---

> ⚠️ **2026-07-20 부분 무효화 — [[spin_stage_symmetry_never_broken]] 먼저 읽을 것.**
> `01_Spin` 단계가 `ISTART=1`+`ICHARG=1`로 **비자성 WAVECAR을 물려받아 MAGMOM이 무시**된다.
> 02 전 결함 자화 이력이 **11개 모두 mag(1단계)≈mag(최종)** — 자화가 0에서 자라난 사례가 없다.
> 따라서 아래 "비자성 확정" 판정들은 **탐색의 결과가 아니라 탐색 부재의 결과**다.
> 특히 무효: (1) L32 "V_Cl-Cl_As는 mag=0.0045 → 비자성 최종 확인", (2) L36 "seeding 충분히 확인됨",
> (3) L38의 홀수-전하 판정 절차(실제로는 MAGMOM이 안 먹었음).
> 독립 진단자: 홀수 전자인데 ISPIN=2 결과의 **EENTRO≠0이면 스핀 미수렴** — V_Cl-Cl_As(0.0282)와
> In_i_Td_In(0.0224)이 여기 걸린다. Cl-As_In·V_Cl-Cl_In은 0.0000이라 이 둘의 자성은 유효.
> 아래 ΔE 표 자체는 양쪽 다 PRECFOCK=Normal·σ→0 기반이라 **수치는 유효**하다.
> (별건 무효: "단일점 스크리닝은 오판한다"는 교훈은 PRECFOCK Fast↔Normal 혼용 비교였다.)

## 전체 defect 스핀 스크리닝 결과 (PRECFOCK=N으로 통일, [[surface_defect_gam_relax_spin_comparison]] 방식)
ΔE = E0(spin) − E0(nonmag), OSZICAR 마지막 줄 기준

| Defect/charge | ΔE (meV) | mag (μB) | 판정 |
|---|---|---|---|
| V_Cl-Cl_In/q0 | −268.1 | 1.00 | 강한 자성 ground state (최대) |
| Cl-As_In/q0 | −171.1 | 1.00 | 강한 자성 ground state |
| In_i_Td_In/q0 | −7.0 | 0.50 | **애매 — moment 있는데 안정화 미미, 재확인 필요** |
| In_As/q0 | −4.0 | ~0.00 | 비자성 |
| Cl-As_In/q+1 | −3.1 | 0.00 | 비자성 |
| V_Cl-V_As/q0 | −1.0 | ~0.00 | 비자성 |
| V_Cl-Cl_As/q0 | −0.8 | 0.0045 | 비자성 (기존 미결정 상태 해소) |
| pure/q0 | −0.6 | 0.00 | 비자성 |
| In_i_Td_As/q0 | −0.5 | 0.006 | 비자성 |
| As_In/q0 | −0.3 | 0.00 | 비자성 |
| V_Cl-V_In/q0 | −0.1 | 0.00 | 비자성 |
| As_i_Td_In/q0 | +0.5 | 0.025 | 비자성 |

## 결론
- **100 meV 이상 강한 안정화 + 정수 moment(1.0 μB) = V_Cl-Cl_In/q0, Cl-As_In/q0 둘뿐**. 둘 다 donor-acceptor 보상쌍(compensated pair) 구조 → 홀수 전자수 → open-shell radical (S=1/2) 패턴 공통. V_Cl-Cl_In은 V_Cl(도너성)+V_In(억셉터성) 조합으로 추정
- 나머지 defect는 ΔE가 대부분 1 meV 이하 → 비자성
- **charge parity 효과 실증**: Cl-As_In은 q0=자성(mag=1.0), q+1=비자성(mag=0) → ISPIN 결정은 defect 단위가 아니라 **(defect × charge)별**로 해야 함
- V_Cl-Cl_As는 PRECFOCK=N 재실행으로 mag=0.0045 → 비자성 최종 확인
- **In_i_Td_In/q0는 예외적 케이스**: mag=0.50 μB moment 있는데 ΔE=−7 meV로 안정화 미미. 자성/비자성 solution 거의 축퇴 or SCF 미수렴 가능성 — ISPIN=2 잠정, 본계산 재확인 필요

## ISPIN 분기 방침 (2026-07-02 갱신, 이전 "전체 ISPIN=2 통일" 번복)
- **전환 이유**: 지금 단계는 무거운 본계산 전 가벼운 Gamma 스크리닝. 스핀에너지 없으면 ISPIN=1로 비용 절감이 합리적. 큰 초기 MAGMOM으로 편극 기회를 주고도 mag→0, ΔE≈0이면 진짜 비자성 확정(seeding 충분히 확인됨)
- **판정 기준**: mag > ~0.5 μB 또는 |ΔE_spin| > ~10 meV → ISPIN=2 ; 아니면 ISPIN=1
- **odd-electron 주의(개념)**: 홀수 전자수가 자동으로 자성은 아님. ISPIN=1은 frontier 상태를 up 0.5/down 0.5 분수점유로 강제하는데, 국소 준위면 편극이 유리(자성)·metallic이면 0.5/0.5가 진짜 바닥상태(비자성). 그래서 홀수 charge는 반드시 큰 MAGMOM으로 ISPIN=2 테스트 후 판정
- **적용 시점**: 현재 큐(V_Cl-Cl_As/q0 R, pure/q0 PD)는 이미 ISPIN=2로 돌고 있어 그대로 완주(mag=0이라 값 동일). **다음 배치부터** 위 판정으로 분기
- **ispin 값의 저장 위치**: ispin은 a priori 입력이 아니라 스크리닝 파생 결과 → defects.yaml(정의 파일)에 넣지 않기로 함(2026-07-02 넣었다가 되돌림). **B안 채택 예정: 별도 `config/spin_screening.yaml`(mag/ΔE 원본 포함)로 분리 후 stage 생성 코드가 읽도록 배선 — 2026-07-03에 작업 예정**

**Why:** DOS/Band 본계산 전 spin-polarization이 유의미한 defect만 ISPIN=2로 추적/검증, 나머지는 비용 절감
**How to apply:** 다음 배치부터 (defect,charge)별 mag/ΔE로 ISPIN 분기. V_Cl-Cl_In/q0, Cl-As_In/q0=ISPIN=2. In_i_Td_In/q0=ISPIN=2 잠정+재확인. 나머지 비자성=ISPIN=1. ispin은 spin_screening.yaml로 관리(내일 배선)
