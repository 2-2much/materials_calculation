---
name: cascade2_sbatch_workflow
description: "cascade2는 32코어/191GB×18노드. 마스터노드 대비 7배. NCORE=16/NSIM=32, 단 1원자 셀만 NCORE=1+KPAR. case당 잡 1개 제출기 = 20-mu_window_PBE/config/sbatch_case.sh"
metadata:
  type: reference
---

2026-08-19 확정. `sinfo`: **cascade** n[001-010] 36코어 / **cascade2** n[011-028] 32코어·191GB.
cascade2 가 기본 파티션(`cascade2*`)이고 idle 이 자주 있다.

## 속도 (실측, H₂ 20 Å 박스 ENCUT400/PREC=Accurate, 280³ fine grid)
- 마스터노드(kohn, Xeon Silver 4214 24코어) `mpirun -np 20`: 이온스텝 **24 s**
- cascade2 1노드 32코어: 이온스텝 **3.5 s** → **7배**
- 에너지는 −6.76019008 로 **8자리 동일**. gam↔std 도 8자리 동일.

## 제출기 정본
`33-inAs/__Ligands_and_Chemicals__/20-mu_window_PBE/config/sbatch_case.sh`
```sh
config/sbatch_case.sh <case_dir> [<case_dir> ...]
```
- case 당 `--nodes=1 --ntasks-per-node=32 --partition=cascade2` 잡 하나.
- **KPOINTS 4행이 `1 1 1` 이면 gam, 아니면 std** 바이너리를 자동 선택.
- 잡 이름을 경로에서 만들어 전부 구분되게 한다([[slurm_jobname_distinct]]).
- `.done` 있는 case 는 건너뛴다 → 재제출이 안전(idempotent).
- 완료 판정 = OUTCAR 에 `General timing` → `.done` touch.

## 병렬 파라미터
**NCORE=16 / NSIM=32** (32랭크 → 밴드 2개 병렬).
⚠ **예외: In metal 같은 1원자 셀은 NCORE=1 + KPAR=8.** 평면파가 수백 개뿐이라
NCORE 가 크면 ACE/ZPOTRF 에서 죽는다([[ncore_ace_zpotrf_small_cell]]).

## 바이너리 (kohn/cascade2)
`/TGM/Apps/VASP/VASP_BIN/6.6.0/vasp.6.6.0.dftd4.scpc.beef.mbd.libxc.sdftd3.wan90.lhfskip.{std,gam,ncl}.x`
⚠ **여기 6.5.1 폴더에는 dftd4 빌드가 없다**(g1 의 목록과 다르다, [[g1_node_vasp_binary_limit]]).
IVDW=13(D4) 를 쓰려면 6.6.0 이어야 한다. IVDW=12(D3-BJ) 는 native 라 아무 빌드나 된다.

관련: [[no_compute_on_login_node]] [[mu_window_pbe_20]]
