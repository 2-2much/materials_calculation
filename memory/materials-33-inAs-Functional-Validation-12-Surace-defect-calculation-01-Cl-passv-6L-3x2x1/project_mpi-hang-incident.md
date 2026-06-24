---
name: mpi-hang-incident
description: 2026-06-23 In_As q0 Relax 계산이 MPI Alltoallv 교착으로 hang — 서버 관리자에게 보고 필요
metadata: 
  node_type: memory
  type: project
  originSessionId: b145e4cd-c9d9-4369-8b63-7991e02cab0a
---

2026-06-23 In_As q0 01_Relax 계산이 PMPI_Alltoallv hang으로 중단됨.

**상황:**
- 경로: `calc/In_As/q0/01_Relax/`
- 12노드 144 MPI ranks, SLURM job 52264, 노드 n001 포함
- 15:02 시작 → 16:41 ionic step 88 SCF 13번째에서 출력 멈춤 → 20:06 수동 취소
- std.log에서 모든 rank가 `PMPI_Alltoallv`(병렬 FFT 집단 통신)에서 블로킹 확인
- `forrtl: error (78): process killed (SIGTERM)` 으로 종료

**원인 추정:** InfiniBand 네트워크 장애 또는 특정 노드 불안정 → MPI collective 교착

**Why:** 서버 관리자에게 InfiniBand/노드 상태 점검 요청 필요
**How to apply:** 재계산 시 동일 hang 발생하면 `--exclude` 옵션으로 의심 노드 제외, 관리자에게 n001 포함 노드 점검 요청
