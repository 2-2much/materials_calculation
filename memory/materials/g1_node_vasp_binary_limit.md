---
name: g1_node_vasp_binary_limit
description: "tgm-master(g1·g2)는 Sandy Bridge E5-2630(avx만) — VASP는 버전이 아니라 *빌드 변형*이 문제다. *.mpi.x 계열만 illegal instruction, 프로젝트 표준 6.5.1 lhfskip 빌드는 정상. slabcc는 SLURM+OMP12"
metadata:
  type: reference
---

## tgm-master 클러스터 하드웨어 (g1·g2 동일)
`Intel Xeon E5-2630 @2.30GHz` (Sandy Bridge-EP, 2012).
SIMD 실측: `sse4_2 avx` — **avx2/avx512/fma 없음**. g2 노드(n033/036/060/064)도 전부 동일.
cascade는 36코어의 별개 자원([[cascade_parallel_settings]]).

⚠**2026-08-18 정정 — 코어수·메모리**: sham에서 `scontrol show node n002` 실측 =
**CPUTot 8 (2소켓×4코어, ThreadsPerCore=1), RealMemory 32000 MB**. 위에 적혀 있던
"12코어/노드, 31GB"는 틀렸다(또는 그 사이 재구성됨). `sinfo -p g1` 도 496 CPU / 62 노드
= 8코어/노드로 일치. **g2는 현재 전 노드 down/drain** (56/56 O). 제출 전 `sinfo`로 확인할 것.

## ⚠VASP: 버전이 아니라 **빌드 변형**이 문제 (2026-07-23 확정)
같은 `6.5.1/` 폴더 안에서도 변형에 따라 갈린다. **폴더 이름만 보고 "이 버전은 안 된다"고 일반화하지 말 것.**

| 바이너리 | g1 |
|---|---|
| `6.5.1/vasp.6.5.1.dftd4.wan90.beef.plugin.lhfskip.std.x` ← **프로젝트 표준** | **OK** |
| `6.6.0/vasp.6.6.0.wan90.std.x` | **OK** |
| `6.4.3/vasp_std`, `6.4.2/vasp_std`, `6.3.2/vasp.6.3.2.std.x`, `5.4.4.pl2/...std.x` | **OK** |
| `6.4.3/vasp_std_master` (sham에 있는 그 6.4.3) | ✗ illegal instruction ← 2026-08-18 |
| `6.3.2/vasp.6.3.2.dftd4.std.x` | **OK** ← 2026-08-18 |
| `6.5.1/vasp.6.5.1.std.mpi.x` | ✗ illegal instruction |
| `6.5.0/vasp.6.5.0.std.mpi.x` | ✗ illegal instruction |
| `6.4.1/vasp.6.4.1.wan90v3.std.x` | ✗ illegal instruction |

→ **`*.mpi.x` 계열이 이 CPU에 안 맞게 빌드돼 있다.** 사용자 확인: VASP는 서버·노드마다 따로 컴파일해 두었고 표준 빌드는 여기서 잘 돈다.
검증: bulk Si 8원자 E0 = **−43.37823407 eV** 가 6.4.3과 6.5.1(lhfskip)과 6.6.0에서 **소수점 8자리까지 동일** → 어느 빌드를 써도 결과 동일.

## ★2026-08-18 sham 실측 — "6.4.3은 OK"를 그대로 믿지 말 것
`/TGM/Apps/VASP/VASP_BIN/` 에 **6.5.1도 6.6.0도 없다**(5.4.4.pl2/6.3.2/6.4.0/6.4.1/6.4.3/6.5.0).
그리고 6.4.3 폴더에 있는 것은 위 표의 `vasp_std` 가 아니라 **`vasp_std_master`** 라는 다른
빌드이고 **g1에서 illegal instruction 으로 죽는다.** 즉 "6.4.3 = OK" 는 파일명 단위로만 참이다.
→ **sham/g1 표준 = `/TGM/Apps/VASP/VASP_BIN/6.3.2/vasp.6.3.2.std.x`.**
같은 8원자 Si(ENCUT 300, Γ4×4×4, ISMEAR=0)로 `6.3.2.std.x` 와 `6.3.2.dftd4.std.x` 가
E0 = **−43.33259252 eV** 8자리 일치(위 −43.378 과는 INCAR가 달라 값이 다른 것이지 불일치 아님).
테스트 방법: 한 잡 안에서 후보 바이너리를 루프로 돌리고 `TOTEN` 유무만 보면 3분이면 끝난다.

증상: 시작 직후 전 rank가 `Caught signal 4 (Illegal instruction)` + `forrtl: severe (168)`. OUTCAR 0바이트, 백트레이스가 libucs만 가리켜 원인 오인하기 쉬움. **입력 문제 아님 — ISA 불일치.**
새 바이너리를 쓸 땐 **그 변형을 직접** 8원자 bulk Si로 30초 테스트할 것.

⚠**내가 저지른 오판 2단계**(같은 실수 반복 금지):
1. `6.5.1/` 에서 이름이 제일 단순한 `.std.mpi.x` **하나만** 테스트하고 "6.5.1 불가"로 일반화 → 실제로는 표준 빌드가 멀쩡했다.
2. 거기서 "g2도 같은 CPU니 클러스터 전체에서 6.5.1 불가"라는 **더 큰 잘못된 결론**까지 메모리에 적었다.
교훈: 폴더 단위가 아니라 **바이너리 파일 단위**로 테스트하고, 테스트 안 한 것을 추론으로 메우지 말 것.

## slabcc 실행 (검증됨)
⚠**로그인 노드 직접 실행 금지** — `nproc=1`, `OMP_NUM_THREADS=1`이라 단일 스레드로 기어감(변형당 20분 → SLURM 12스레드로 2~3분).
```sh
#SBATCH --partition=g1 --nodes=1 --ntasks-per-node=12 --mem=30G
module purge; module load compiler/2023.1.0; module load mkl/2023.1.0
export OMP_NUM_THREADS=12
~/bin/slabcc/bin/slabcc -i slabcc.in -o slabcc.out -l slabcc.log
```
동작 확인법: `/proc/<pid>/` 에서 NLWP=12, %CPU≈900, `libmkl_intel_thread.so`+`libiomp5.so` 로드, `libmkl_avx.so`(avx2/512 아님) 선택.
MKL은 런타임 CPU 디스패치를 하므로 같은 노드에서도 문제없다 — VASP는 컴파일 시점 고정이라 죽는 것.

## 대형 슬랩 relax 속도 (540원자 Si 슬랩 실측)
`LREAL=.FALSE., EDIFF=1E-6, ALGO=Normal` → SCF 1회 **900초**(이온스텝 73.5분, 총 ~20h).
`LREAL=Auto, EDIFF=1E-5, ALGO=Fast, KPAR=기약k점수` → **140초 (6.4배)**.
relax만 완화하고 **statics는 엄격 유지**하면 E_f에 영향 없음(기하는 EDIFFG가 결정).
⚠이 설정을 INCAR에 손으로 넣지 말 것 — 생성 스크립트에 넣어야 재실행 시 안 날아간다([[si_db_kp_reproduction]] 사고).

관련: [[si_db_kp_reproduction]], [[slurm_jobname_distinct]], [[server_fs_git_sync_scope]]
