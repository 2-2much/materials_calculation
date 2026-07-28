---
name: coffee_setup_and_arange_bug
description: "CoFFEE 설치 위치·현대 파이썬 대응 패치 4건, 그리고 격자 5.6%를 조용히 망치는 np.arange 상류 버그"
metadata: 
  node_type: memory
  type: reference
  originSessionId: b7156945-528e-49f3-88ff-00d1d5ec26f1
  modified: 2026-07-28T09:12:15.323Z
---

**설치**: `~/bin/CoFFEE` (github.com/qtm-iisc/CoFFEE). 검증 = MoS₂ Model_Scaling α=4/5/6/8/10이 배포판 README와 전부 일치(0.421/0.463/0.489/0.516/0.530 eV). `Ecut`은 **DFT ENCUT과 무관** — 단위 Hartree이고 모델 푸아송 G-격자 해상도만 정함(가우시안 σ와 erf 프로파일만 담으면 됨). slabcc가 VASP FFT 격자에 묶이는 것과 달리 자기 격자를 씀.

**⚠ 상류 버그 (2026-07-28 발견) — `PoissonSolver/classes.py`의 `np.arange(0,1,1./N)`**
부동소수 스텝이라 길이가 N이 아니라 **N+1이 되는 경우가 5.6%**(N≤1200 중 67개: 49, 98, 103, 107, 196, …, **509**). ε(z) 배열은 N=2·Nz−1로 만들어지는데 여기서 어긋나면 푸리에 성분 인덱싱이 통째로 밀려 **조용히 틀린 유전 응답**을 쓴다. 인덱스 에러도 경고도 없다.
- 실측 피해: In_As_1 vac50(Nz=255→N=509) **1.8848 → 1.3368 eV (0.55 eV)**, α=2@Ecut25(같은 Nz=255) **0.2016 → 0.4582 eV**.
- 지문: Ecut 사다리에서 **한 점만 튀고 나머지는 ±2 meV로 뭉침**. "Ecut 미수렴"으로 오진하기 쉬움 — 수렴은 매끄럽지, 한 점만 터지지 않는다.
- 조치: 3곳(`a1_list`/`a2_list` 372-3, `X`/`Y` 526-7, `a3_list` 571)을 `np.linspace(...,endpoint=False)`로 교체. `a1/a2`(전하격자) 쪽 어긋남은 무해했음(Ny=49로 실측 값 불변), **ε(z) 쪽만 치명적**.
- ⚠ CoFFEE를 재설치/업데이트하면 **이 패치가 날아간다**. 새 격자 크기로 돌릴 때 `len(np.arange(0,1,1./(2*Nz-1)))` 먼저 확인할 것.

**현대 파이썬 대응 패치 3건** (Python 3.12 / scipy ≥1.12):
1. 동봉 `.c`가 옛 Cython 산출물 → `longintrepr.h` 없음. `.pyx`부터 `cython -3`로 재생성 후 `python3 setup.py build_ext -b PoissonSolver/`.
2. `bicgstab(A,b,x0,tol,maxiter)` 위치인자 거부 → `rtol=`/`maxiter=` 키워드.
3. scipy ≥1.12 bicgstab이 고-G 라인에서 breakdown(info=−10) → 원본은 해를 **버려서** 배열이 ragged가 되며 죽음. 대각(Jacobi) 전처리 추가 + RHS가 수치적 0이면 V(G)=0 + 실패 시 조밀 LU(i=j=0은 랭크 1 부족이라 `lstsq`). ⚠ **잔차 검증은 버그 진단엔 무력했다** — bicgstab은 전 라인 info=0에 참잔차도 작았고, 오류는 ε(z) 쪽이었음.

**환경**: mpi4py는 pip로 설치(Intel MPI ABI 호환). MPI 병렬화는 **면내 i 인덱스 한 방향뿐**(`Irange[rank::size]`)이라 랭크 상한 = Nx, rank0가 V_G·rho_G 전체와 최종 IFFT를 혼자 처리(α=8에 ~11 GB). 관련: [[coffee_vs_slabcc_eiso_target]], [[server_fs_git_sync_scope]]
