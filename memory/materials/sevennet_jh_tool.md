---
name: sevennet_jh_tool
description: "JH가 준 SevenNet 7net-omni 래퍼(~/materials/__sevennet-test__) — ASE+LBFGS static relax 전용·CPU 단일프로세스. ⚠원본 env 소실(kuee1020 triqs 3.12→3.14). torch는 sevenn 의존성에 없어 CPU index로 따로 깔아야 함"
metadata:
  type: project
---

`~/materials/__sevennet-test__/JH-sevennet-cal/01-sevennet-cal/` (2026-09-17 분석).
연구실 동료(kuee1020)가 kohn 용으로 만든 것. 원본 = `/home/kuee1020/materials/HHTP-THB-HHB/01-sevennet-cal`.

## 무엇인가 — SevenNet 코드가 아니라 얇은 ASE 래퍼

```
submit_relax.sh (SLURM)
 └─ run_relax.py
      ├─ ase.io.vasp.read_vasp          POSCAR (Selective Dynamics → FixAtoms 자동)
      ├─ sevenn.calculator.SevenNetCalculator(model='7net-omni')   ← 사전학습, 학습 없음
      └─ ase.optimize.LBFGS
           → CONTCAR / XDATCAR / relax.traj / relax.log
```

- **static relax 전용. MD 스크립트는 없다**(원본 폴더 전체 확인)
- 체크포인트 103 MB 를 첫 실행 때 자동 다운로드 → site-packages 에 캐시
- **VASP 호환 I/O** — CONTCAR 를 그대로 VASP 에 넘기도록 설계

### 옵션 (물리적으로 중요)
| | |
|---|---|
| `--modal mpa` (기본) | MPtrj/sAlex(PBE) 학습, **분산력 없음** |
| `--modal odac23` | D3 내장 |
| `--d3` | `SevenNetD3Calculator` 로 D3-BJ/PBE 를 따로 얹음 (mpa 와 조합) |

예제 런은 `mpa` + `--d3` 없음 = **vdW 없이** 계산했다. 금속 표면 위 유기분자에는 가벼운 선택이 아님.

## 예제 런 (job 54141, 2026-05-29) — Au 표면 위 HHTP 자기조립
- `Au₅₃₇C₂₁₆O₇₂H₁₄₄` **969원자** (C216/O72/H144 = HHTP 분자 12개 + Au 슬랩)
- 셀 68.50×21.87×24.73 Å, γ=119.7°. **179/969 고정**(바닥 Au)
- **184 step / 3648 s (61분) / 19.8 s·step, 36코어 cascade**
- E −4435.64 → **−4623.77 eV**, 초기 fmax **262.7** → 최종 0.0442 eV/Å
- 원자 이동 최대 2.52 Å, **고정 원자는 정확히 0.000000 Å** (구속 정상)
- 초기 힘 262 eV/Å = vaspkit 로 손으로 쌓은 초기구조. **범용 MLIP 의 전형적 용처**

## kohn 맞춤 설계
1. **CPU 전용, 단일 프로세스 + 멀티스레드(MPI 아님).** `--nodes=1 --ntasks=1 --cpus-per-task=36`,
   OMP/MKL/OpenBLAS/NumExpr 를 `SLURM_CPUS_PER_TASK` 에 정렬, `CUDA_VISIBLE_DEVICES=""`
   - 이유가 로그에 있다: torch 가 cu130 빌드인데 **노드 드라이버가 12000이라 너무 낡아** CUDA 초기화 실패
2. `OMP_PROC_BIND=spread` / `OMP_PLACES=cores` / `KMP_AFFINITY` (dual-socket 스레드 이동 방지)
3. **파티션 `cascade`(36코어)**. cascade2(32) 로 옮기면 `--cpus-per-task=32` 로 같이 바꿀 것

## ⚠ 그대로는 안 돌아간다 (2026-09-17 확인)
- `submit_relax.sh` 가 `/home/kuee1020/.conda/envs/triqs/lib` 를 LD_LIBRARY_PATH 에 박아뒀는데,
  **그 env 의 python 이 3.12 → 3.14 로 바뀌었고 sevenn 이 없다.**
  kuee1020 의 env 6개(fuzzyqd·ocp-models·py27·py310·pyvasp·triqs) 전부 확인 → **sevenn 없음**
- 스크립트 40~47행의 env 활성화가 **전부 주석** — 제출 쉘에 의존하는 구조라 깨졌다
- jaegwan97 의 py310/py4vasp 에 torch 없음

## 설치 요점
- ★ **`torch` 가 sevenn 의 requires_dist 에 없다.** 따로 깔아야 하고 **반드시 CPU index**:
  `pip install torch --index-url https://download.pytorch.org/whl/cpu`
  기본 index 면 nvidia-* 4개 **~2.5 GB** 가 딸려오는데 **kohn 에선 GPU 를 못 쓴다**(위 드라이버 문제)
- sevenn 0.13.0 deps: ase, e3nn≥0.5, torch_geometric≥2.5, matscipy, scikit-learn, pandas, ninja 등
- **전부 휠 존재 → 컴파일 0** (matscipy 1.2.0 cp312 manylinux 휠 확인, torch 2.9.1+cpu cp312 확인)
- 계산 노드에 인터넷 됨(원본 런이 n001 에서 체크포인트를 받았다)

## MoTe2 작업과의 관계 — 원자·step 당 코어시간
| | core·s / (원자·step) |
|---|---|
| VASP DFT step (168원자, 384랭크) | **320** |
| SevenNet 7net-omni (969원자, 36코어) | **0.74** (DFT 대비 435배 싸다) |
| VASP 자체학습 MLFF 의 FF-step | **0.039** (SevenNet 이 19배 느리다) |

→ **추론은 자체 MLFF보다 20배 느리지만 학습 비용이 0.** Step 3 구조 생성기로 즉시 쓸 수 있다.
⚠ 단 `mpa` 는 PBE·분산력 없음 = `IVDW=13`+ENCUT400 과 footing 이 다르다.
**에너지 오라클이 아니라 구조 생성기로만.** MoTe2 V_Te 재구성을 맞히는지는
아는 답(5×5 distorted)으로 먼저 검증할 것.

관련: [[kohn_conda_forge_and_venv]] [[mote2_mlff_budget_and_scaling]] [[feedback_validate_diagnostic_first]]

## ★ 설치 완료 (2026-09-26, kohn)
- env = **conda `~/.conda/envs/sevennet`** (venv 아님, python 3.12.14 conda-forge). torch **2.14.0+cpu**, sevenn 0.13.0, ase 3.29.0
- ⚠ `~/.local` user-site(pymatgen 등)가 섞여 보인다 → 설치·실행 모두 **`PYTHONNOUSERSITE=1`**
- 제출 스크립트는 `conda activate` 대신 `export PATH=$HOME/.conda/envs/sevennet/bin:$PATH` (set -u 충돌 회피), kuee1020 LD_LIBRARY_PATH 줄 삭제
- 빠른 테스트 = `JH-sevennet-cal/02-hfo2-primitive/` — SevenNet 저장소 `tests/data/systems/hfo2.extxyz` 첫 프레임(단사정 Hf4O8 12원자). job 61387(cascade2 4코어) **39초·19 step 수렴, E=−121.803 eV(−10.15 eV/atom)**
  - ⚠ extxyz 안의 `energy=−347.81` 은 **비교 대상 아님**(−29 eV/atom = 다른 코드/기준). 7net 값은 MP-PBE 급(−10.1 eV/atom)과 맞다
- ⚠ **체크포인트는 wheel 에 안 들어 있다** — 첫 실행 때 site-packages 로 받는다(61387 std.log 에 `Checkpoint downloaded`). 한 번 받으면 재사용. `7net-omni-i12`(220 MB)는 로그인 노드에서 미리 받아둠(`sevenn.util.pretrained_name_to_path`)
- MD 노트북 = `~/materials/__sevennet-test__/01-temperature-MD/` — Colab cueq 노트북을 CPU/papermill 로 변환(원본 사본 동봉). `sbatch submit_md.sh [test]` → `out_<jobid>.ipynb`. env 에 papermill·ipykernel 추가, `python3` 커널이 env 것으로 잡힘(`~/.local` 커널은 `ipynb` 하나뿐)
