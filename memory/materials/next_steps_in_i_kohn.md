---
name: next_steps_in_i_kohn
description: "kohn에서 돌릴 In_i 후속 계산 3건 — (1)InCl_i 복합결함으로 \"In_i+Cl→도너 상실\" 가설 검증 (2)In_i adatom q+1로 CTL (3)02-HSE에 adatom 자리 추가"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6cac9ee2-5f63-46c0-8b3f-65bd6bb8d24d
  modified: 2026-08-03T02:45:40.016Z
---

2026-08-03 결정. 작업 서버 = **kohn**. 근거·판정은 [[in_i_shallow_donor_both_terminations]]

## 왜 필요한가
현재 In_i 데이터는 **q0만** 있고, 모두 "전자 1개가 host CBM으로" = shallow donor로 끝난다. CTL도 없고, 가설(In_i+Cl→도너 상실)의 대상 결함이 아예 계산된 적 없다.

## 우선순위
1. **`InCl_i` (Δn_In=+1, Δn_Cl=+1), q0** — 가설의 결정적 시험.
   - 01 트리 In_i adatom 자리(In37, z≈22.1)에 Cl 캡을 씌워 In–Cl ≈ 2.4 Å로 seed.
   - 짝수 전자 → ISPIN=1로 충분(맨 In_i는 홀수 1e였음).
   - 판정: 갭이 깨끗하게 비고 CBM에 점유 전자 0이면 가설 확정. IPR 게이트로 확인.
   - μ_Cl은 InCl₃ pinning 구속 적용 필수 — 안 넣으면 음의 E_f가 나온다. cf [[mu_reference_phases]] [[cl_as_negative_eform_reference_slab]]
2. **In_i(adatom) q+1** — 두 트리 다 q0뿐이라 **ε(+1/0) CTL을 못 뽑는다**. CQD n-type 판정의 본체. 하전이므로 slabcc 보정 필요(진공 40~50 Å 하한 주의).
3. **02-HSE06에 adatom 자리 추가** — 최종 판정용. 현재 HSE에는 Td 두 자리(준안정)만 있음.

## 주의
- 로그인 노드 계산 금지, SLURM 제출. cf [[no_compute_on_login_node]]
- jobname을 calc별로 구분. cf [[slurm_jobname_distinct]]
- ⚠계산 폴더는 git 동기화 대상이 아님(memory/·.claude만) → kohn에 결과 복사는 공유 NFS/수동. cf [[server_fs_git_sync_scope]]
- Γ-only DOS로 gap 판독 금지(위 메모의 함정). pure와 코어퍼텐셜 정렬 후 밴드를 셀 것.
