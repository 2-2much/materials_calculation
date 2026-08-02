---
name: coffee_setup_and_arange_bug
description: "CoFFEE 설치 위치·현대 파이썬 대응 패치 4건, 그리고 격자 5.6%를 조용히 망치는 np.arange 상류 버그"
metadata: 
  node_type: memory
  type: reference
  originSessionId: b7156945-528e-49f3-88ff-00d1d5ec26f1
  modified: 2026-08-02T21:06:19.082Z
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

**성능 패치 (2026-08-03, 로컬) — `classes.py` 두 함수 벡터화**
`construct_rho`와 `ComputeEnergy`가 격자 전체를 도는 **순수 파이썬 삼중루프**였다(각각 2.0·1.4 µs/point, rank0 전용 = MPI 병렬 영역 밖). Gaussian이 분리가능(x,y는 a1·a2에만, z는 a3에만)이라 (L,M) 블록과 (N,) 벡터의 외적으로 대체, 에너지는 `0.5*np.sum(V_r*rho_r)*dV` 한 줄.
- 검증: MoS₂ 사다리 8개(α=4~40) **0.0 meV**, rho 배열 원소별 **상대오차 2e-16**, 경계 wrap 3분기·전단(비직교) 셀 모두 통과.
- 효과: Amdahl 직렬항 **34.5초 → 3.5초**(α=20 기준, 병렬항 250초는 불변). 36랭크 41.4→10.5초.
- ⚠**결론이 바뀐 지점**: 벡터화 전엔 36랭크에서 직렬이 83%라 노드 증설이 무의미했으나, 지금은 34%로 떨어져 **2노드 72랭크가 1.47배 유효**하다. "노드 늘려도 소용없다"는 옛 판단은 폐기.
- ⚠재설치 시 이 패치도 [[coffee_setup_and_arange_bug]]의 arange 패치와 함께 날아간다. `~/bin/CoFFEE`와 11-Surface-defect_TOY-model/CoFFEE 두 곳에 반영돼 있음.
- ✅②③ 해결(2026-08-03): FFT를 `scipy.fft(workers=-1)`로(rank0가 FFT 도는 동안 나머지 랭크는 어차피 대기), `COFFEE_NO_DUMP=1`로 rho_r·V_r 덤프 생략(⚠기본값은 저장 — `V_r.npy`는 정렬 단계가 읽음, 사다리 전용 옵션).
- ✅**①도 해결 — bicgstab 제거, 정확해로 교체**. 슬랩은 ε가 z에만 의존해 G_x·G_y가 안 섞이고, 라인 행렬이 **M(i,j) = A + c·B (c=|G_∥|², A·B는 (i,j) 무관)** 이다. A는 에르미트 양반정치(A=D·T·D, D=diag(Gz)), B는 양정치(고유값=ε_∥ 범위 1~15) → **일반화 고유분해 1회**로 전 라인 대각화: `x = V(V^H b/(λ+c))`. 잔차 **1e-14**(bicgstab는 1e-5) = 더 빠르고 더 정확. 라인당 29회 matvec → 2회. 실측 **α=4 7.3× ~ α=20 16.2×**(크기 클수록 이득 큼), MoS₂ 7개 값 완전 일치. `COFFEE_SOLVER=bicgstab`로 복귀 가능.
  - ⚠**(0,0) 라인 게이지**: c=0이면 A가 특이(Gz=0 행·열이 0). 그 성분은 자유롭지만 **V(G=0)은 게이지가 아니라 에너지를 q·상수만큼 바꾼다** → 반드시 `Soln[kmax]=0`으로 못박을 것. 값 일치가 이걸 검증함.
  - ⚠**면내 등방 가정**: 새 제약 아님. `matvec2D.pyx`(실제로 도는 경로)가 이미 `epsGz_a1`을 Gx²·Gy² 둘 다에 쓰고 `epsGz_a2`는 **읽지도 않는다**. `classes.py`의 파이썬 참조 구현만 이방인 척함.
  - 부수효과: scipy 1.12 bicgstab breakdown 방어 패치(Jacobi 전처리+조밀 LU 폴백)가 **불필요해짐**.
- **Ecut은 크게 과잉이었다**(2026-08-03, MoS₂ α=20): 예제 기본 15 Ha 대비 **8 Ha가 0.6 meV·2배 빠름, 6 Ha가 0.8 meV·3.8배, 4 Ha가 1.1 meV·12.9배**. 작업량 ∝ Ecut^1.5. Ecut을 요구하는 건 가우시안이 아니라 **유전 계면**(σ=1.89 bohr 가우시안은 Ecut 15에서 exp(-G²σ²/2)=5e-24로 이미 무의미, Smoothness=0.378 bohr erf는 0.34로 살아있음). ⚠단 E_per 한 점이 아니라 **E_iso 외삽이 안 흔들리는지**를 확인해야 채택 가능.
- ⚠**로그인 노드에서 `source .../vars.sh` 가 셸 스냅샷의 `cd` 재정의 때문에 깨진다** → mpi4py가 libmpi.so를 못 찾음. 수동 설정: `I_MPI_ROOT=/opt/intel/oneapi/mpi/2021.9.0`, `LD_LIBRARY_PATH=$I_MPI_ROOT/lib/release:$I_MPI_ROOT/lib:$I_MPI_ROOT/libfabric/lib`. SLURM 배치 셸에서는 정상.
- **진행률 출력 추가**: stock CoFFEE는 헤더 후 완전 침묵 + 파이썬 버퍼링으로 `out`이 0바이트 → 도는 잡과 멈춘 잡 구분 불가였다. 단계 표시(모델전하→FFT→분배→풀이→취합→IFFT→적분)와 rank0 진척률/ETA를 flush 출력. `PYTHONUNBUFFERED=1` 필수(run 스크립트에 포함), `COFFEE_PROGRESS=0`으로 끔.
- ⚠**CoFFEE엔 OpenMP가 없다**(`#pragma omp` 0건, .so에 libgomp/libiomp 링크 0건) → `OMP_NUM_THREADS`는 무의미. slabcc는 반대로 OMP 코드(`slabcc_math.cpp:266`). 실행 지침은 [[no_compute_on_login_node]].

**환경**: mpi4py는 pip로 설치(Intel MPI ABI 호환). MPI 병렬화는 **면내 i 인덱스 한 방향뿐**(`Irange[rank::size]`)이라 랭크 상한 = Nx, rank0가 V_G·rho_G 전체와 최종 IFFT를 혼자 처리(α=8에 ~11 GB). 관련: [[coffee_vs_slabcc_eiso_target]], [[server_fs_git_sync_scope]]
