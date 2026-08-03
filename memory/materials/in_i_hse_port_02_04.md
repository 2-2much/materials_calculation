---
name: in_i_hse_port_02_04
description: "PBE-d In_i 결과를 02/04 HSE06로 이관한 절차 — 등방 배율 0.9852099996 정의, 04 In_i_2 이름충돌, q+1의 01_opt가 q0에 하드 의존"
metadata: 
  node_type: memory
  type: project
  originSessionId: c112f7c9-ad4a-4a61-8428-865a9d3d4938
  modified: 2026-08-03T11:05:31.877Z
---

2026-08-03. `01→02`, `03→04` 이관. 결함 정의는 [[in_i_surface_sites_01_03]],
PBE-d 결론은 [[in_i_shallow_donor_cl_deactivation]].

## "배율"의 정확한 정의 (재현용)
**등방 단일 인자 s = a₀(HSE06-PBEd)/a₀(PBE-d) = 0.9852099996** 를
**세 격자벡터 전부**에 곱하고 **분율좌표는 그대로**. → 모든 원자간 거리가 정확히 **−1.4790%**.
01→02 와 03→04 의 s 가 **동일**하다(같은 입방 a₀에서 파생된 셀이므로).

```
scripts/redefine_initial_poscars_lattice.py \
  --input-dir <raw> --output-root <scaled> \
  --target-cell-length-A 12.936436   # 02용 (04는 17.248581) \
  --base-lattice-source actual-lattice --overwrite
```
검증: 결과 셀이 pure HSE 셀과 일치 + **max|Δfrac| = 0.0**. 원본/변환본은
각 프로젝트 `__from_PBEd_In_i__/{raw_PBEd,scaled_HSE}/` 에 보존.

⚠**CONTCAR는 종 라벨을 잘라 쓴다** (`In_d`→`In`, `H1.25`→`H1`, `In_L`→`In`).
이관 전에 POSCAR 6행을 복원하지 않으면 04의 `species_aliases: {In_L: In_d}` 검증이 깨진다.

## ⚠ 04 `In_i_2` 이름 충돌 — 덮어쓰기 사고
04에는 **이미 `In_i_2`가 있었다**(2026-07의 3-In hollow, HSE `00_Gam-relax` 완료).
`defects.yaml` 에 같은 이름을 추가하면 **yaml이 뒤 항목만 남겨 조용히 기존 정의를 잃고**,
`Initial_POSCARs/In_i_2/CONTCAR_In_i_2_q0` 도 덮어써진다. 둘 다 복구함.
→ **기존 defects.yaml 은 반드시 백업 후, `defects:` 키를 재선언하지 말고 블록에 이어붙일 것.**
(`.bak_pre_In_i_2026-08-03` 남김)

## 물리적 발견: InCl₃ 표면의 In_i 자리는 사실상 하나
기존 04 `In_i_2`(3-In 출발) 이완 In 위치 frac (0.4359, 0.3962, 0.7185) vs
새 In2+As1 출발 (0.4398, 0.3915, 0.7179) → **0.09 Å 차이 = 같은 adatom**.
03 PBE에서 In_i_1≡In_i_2(ΔE 0.2 meV)였던 것과 합치면, **어느 자리에서 출발해도 하나로 수렴**한다.
→ 04에는 중성 In_i를 **기존 In_i_2 하나만** 두고(q+1 추가), 새로 넣은 건 `In_i_1-Cl`,`In_i_2-Cl` 뿐.
반면 **02는 In_i_1과 In_i_2가 진짜 다른 구조**(PBE ΔE **872 meV**, In_i_1이 바닥).
`In_i_2-Cl`이 `In_i_1-Cl`보다 **1655 meV 낮다**(02) / `In_i_1-Cl`이 586 meV 낮다(04).

## ⚠ q+1 은 q0 에 하드 의존 → `--dependency=afterok` 필수
`01_Spin-gam-optical_Rq0` 는 `reference_charge: 0` 이라 run_case.sh 안에서
`../q0/01_Spin-gam-relax` 가 안 끝났으면 **exit 1** 한다. 동시 제출하면 q+1이 마지막 단계에서 죽는다.
```
q0id=$(sbatch --parsable -D <q0dir> <q0dir>/run_case.sh)
sbatch -D <q+1dir> --dependency=afterok:$q0id <q+1dir>/run_case.sh
```

## 파티션 전환 (cascade2 → cascade)
cascade2가 타 사용자 16노드 잡으로 막혀 cascade(36코어/노드)로 전환.
**partition + ntasks_per_node(32→36) + INCAR NCORE/NSIM(16/32→18/36) 을 반드시 함께** 바꿔야 한다.
잡당 **5노드 × 36 = 180 ranks** → 10노드 파티션에 정확히 2잡 동시.
비용 기준선: 129원자 HSE Gam-relax가 **256 ranks에서 248 s/이온step**.
`runtime.yaml.bak_cascade2_2026-08-03` 로 되돌릴 수 있음. cf [[cascade_parallel_settings]]

## 셸 함정
이 환경의 `cd` 는 `ls` 를 출력한다 → `id=$( (cd dir && sbatch --parsable x) )` 하면
**변수에 디렉토리 목록이 섞여** 들어가 뒤이은 `--dependency` 가 깨진다. `sbatch -D <dir>` 를 쓸 것.

관련: [[slurm_jobname_distinct]] (02/04 둘 다 In_i_2 등 동명 → `C2-`/`C4-` 접두), [[pbe_then_hse_workflow_plan]]
