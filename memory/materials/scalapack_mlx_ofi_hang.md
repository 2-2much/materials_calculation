---
name: scalapack_mlx_ofi_hang
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

## ★2026-09-07 g2 재발 (08-SEJM_Fig2, 64잡 중 3건)
**노드그룹 `n[034-036,047]` 에 국한**. 같은 n 끼리 정규화한 LOOP 배율:
그 그룹만 **최대 9.8배**, 나머지 6개 그룹은 전부 ≤1.96배(단순 셀크기 편차).
그 그룹을 거친 4잡 중 **3잡이 이상**(1 정상 / 1 은 9.8배 / 1 은 hang / 1 은 7배→walltime 초과).
같은 계산을 **다른 노드에서 재제출하니 정상**(n8/Lz18/VN: hang → LOOP 6.9 s 완주) → 입력·물리 원인 배제.
**증상 스펙트럼이 셋 다 나타났다: 정상 → 6~10배 지연 → 완전 hang.**

⚠**착시 주의**: 처음엔 "하전 셀이라 느리다"고 의심했으나 아니었다.
`n9/Lz30` 의 host_q0 vs host_qp1 은 **NBANDS 408 동일, FFT 격자 동일, ncg 167 vs 195(+17%)**
인데 **LOOP 16.9 vs 97.3 s (5.8배)** — 계산량이 아니라 통신/노드 문제라는 결정적 증거.
hang 잡이 같은 노드에 있어서라는 가설도 기각(hang 종료 38분 뒤에도 95.8 s).

**`LSCALAPACK=.FALSE.` 효과 실측**: 97.3 → 24.4 s (**약 4배**). 메모리의 "성능손해 0"이 아니라
**오히려 이득**이었다 — 밴드 408개면 subspace 가 작아 scaLAPACK 이 이득 없이 취약한 collective 만 탄다.

**핵심 교훈**: **노드 수 축소는 fix 아님** — 15→10노드는 hang을 step1→step44로 지연만 시킴(노출 빈도만↓). 근본은 rank수가 아니라 collective 버그.

**왜 Cl_i-As만?**: 구조/노드/전자홀짝 다 아님(홀수전자 Cl-As_In·V_As는 완주). 결정적 테스트: 같은 노드에서 known-good V_As를 scaLAPACK ON·fix없이 재실행→58step 정상완주 → **환경/노드 문제 기각**. Cl_i-As 고유(스펙트럼이 pdsyevx 취약경로 자극) 추정. 자료: `12-Surace-defect_calculation/03-InCl3-passv_6L_4x2x1_PBE-d/calc/Cl_i-As/__hang_analysis_20260707__/`(NOTES.md+백트레이스). 관련 [[surface_defect_oszicar_buffering]](OSZICAR 갱신 지연과는 다른 현상).
