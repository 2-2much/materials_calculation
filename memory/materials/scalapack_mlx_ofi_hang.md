---
name: scalapack-mlx-ofi-hang
description: VASP scaLAPACK BLACS Bcast가 Intel MPI mlx OFI collective에서 간헐 hang; fix=LSCALAPACK=.FALSE. 또는 I_MPI_COLL_DIRECT=off
metadata: 
  node_type: memory
  type: project
  originSessionId: 4bdb8095-e5d4-4295-a02d-c32a0f4a33c7
---

g1 파티션(n0xx, Intel MPI 2021.9 + MKL scaLAPACK + Mellanox mlx OFI provider)에서 VASP 6.5.1 잡이 **모든 rank 99% CPU(STAT=Rl)인데 OUTCAR/OSZICAR 정지**로 hang나는 현상. ping은 정상(이더넷만 봄), 100% CPU는 Intel MPI busy-wait spin이라 착시.

**원인 (gstack=gdb 백트레이스로 확정, 2026-07-07 Cl_i-As q0)**: VASP EDDAV → `scala_mp_pdssyex_zheevx` → scaLAPACK `pdsyevx`→`pdlatrd` → BLACS `MKLMPI_Bcast` → Intel MPI `MPIDI_OFI_Bcast_intra_direct_knomial`(OFI 하드웨어 오프로드 "direct" collective) → `libmlx-fi.so`/UCX에서 완료 안 됨. 즉 **mlx OFI direct-collective 버그**.

**진단법**: `ssh <node> 'gstack <vasp_pid>'` 로 스택 확인. `pdlatrd`/`MKLMPI_Bcast`/`ofi_cq_readfrom` 프레임이면 이 버그. OUTCAR mtime 정지 + rank 99% CPU가 시그니처.

**Fix (효과 확인됨)**: ① INCAR `LSCALAPACK=.FALSE.`(scaLAPACK/BLACS 경로 제거, 소행렬이라 성능손해0) ② job 스크립트 `export I_MPI_COLL_DIRECT=off`(버그 collective 전역 우회). Cl_i-As는 이 조합+step-44 CONTCAR restart로 173초 완주.

**핵심 교훈**: **노드 수 축소는 fix 아님** — 15→10노드는 hang을 step1→step44로 지연만 시킴(노출 빈도만↓). 근본은 rank수가 아니라 collective 버그.

**왜 Cl_i-As만?**: 구조/노드/전자홀짝 다 아님(홀수전자 Cl-As_In·V_As는 완주). 결정적 테스트: 같은 노드에서 known-good V_As를 scaLAPACK ON·fix없이 재실행→58step 정상완주 → **환경/노드 문제 기각**. Cl_i-As 고유(스펙트럼이 pdsyevx 취약경로 자극) 추정. 자료: `12-Surace-defect_calculation/03-InCl3-passv_6L_4x2x1_PBE-d/calc/Cl_i-As/__hang_analysis_20260707__/`(NOTES.md+백트레이스). 관련 [[surface_defect_oszicar_buffering]](OSZICAR 갱신 지연과는 다른 현상).
