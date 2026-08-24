---
name: inas_vin_facet_trees_10_23
description: "V_In 중성 형성에너지 facet 비교 트리 10/23 — ★2x2 리간드면 p4x3 불가, 대신 p2x2의 √3 셀. git clone 운용법"
metadata: 
  node_type: memory
  type: project
  originSessionId: 21c58ffa-0ee4-4c70-8beb-441f19e036c9
  modified: 2026-08-24T11:11:25.884Z
---

2026-08-24 착수. 목표 = **표면·패시베이션별 V_In 중성 형성에너지 비교**.
작업트리(kohn=tgm-master, 홈 공유): `12-Surace-defect_calculation/`
- `10-100AA-unrecon_8L_par4x3_PBE-d` — (100) **미재구성** acetate 1.5ML, 246원자 (09의 재구성 짝)
- `23-111AA_4BL_2r3_PBE-d` — (111)A acetate 0.75ML, 171원자

## ★ 2×2 주기 리간드면 p4x3가 불가능하다
(111)A acetate는 **3 AA / 4 In 자리 = 진짜 p(2×2) 주기**다. 수퍼셀 벡터는 p(2×2)의 정수조합이어야 하는데
21번의 p4x3(1×1 기준 4A×3B)는 `3B`가 p2x2 기저에서 반정수 → **구조적으로 불가**(불편한 게 아니라 불가능).
대안 = **p(2×2)의 √3×√3 R30**, `M=[[1,1],[-1,2]]` (det 3).
- 60° 육방이라 `|a+b|² = 3|a|²` → `|a'| = √3·8.7538 = 15.162 Å`, a에서 정확히 30° 회전
- 1×1 기준 **(2√3×2√3)R30, det 12** — 21번 p4x3와 원자수 동일한데 image 거리는 **13.13 → 15.16 Å**
- 12개 셀에 대한 이론적 최적(등방 육방). p4x4는 17.51 Å이지만 228원자 + (100) 트리의 15.78 Å과 어긋남
- 마지막에 셀 전체를 −30° **강체회전**해 a를 x축에 맞춤 → 분수좌표 불변이라 registry·이완기하 100% 보존
  (메모리의 "자유회전 금지"는 셀 간 원자 *이식* 얘기지 셀 통째 회전이 아니다)

(100) 쪽은 sham `04-Facet_IP-EA/03-runs` C4 p2×1 → `M=[[2,0],[1,3]]` → 09와 **격자 완전 동일**(15.78 Å).

## V_In만 계산 가능한 이유
`delta_atoms = {In: -1}` 하나뿐 → **μ_acetate 불필요**. 09의 다른 결함들이 μ_Aa에 막혀 있는 것과 대조.
```
E_f(V_In,q0) = E(V_In) − E(pure) + μ_In      [02_G221-DOS 의 energy_sigma0]
μ_In(In-rich) = −2.56234363 eV   (PBE-d, ENCUT400, In_d)
  = 04-Chemical-reservoir/01-In-metal/01-Functional/results_In.txt 의 [PBE-d] E0
```
앵커: 09(재구성 (100):AA) → **E_f = 0.9411 eV** (In-rich). V_In q0은 05/07/09/11/21에 이미 존재 → 총 6면 비교표.

## 결정 사항 (2026-08-24, 재론 금지)
- **PREC=N 유지, μ_In 기존값 그대로.** 슬랩 PREC=N vs μ_In PREC=Accurate 불일치는 Δn_In=−1이라 형식상
  상쇄되지 않지만 **수용**. 모든 트리가 같은 offset을 지니므로 facet *비교*에서는 빠진다.
- **Γ-only 이완 확정.** (111) 2×2×1 재이완 스팟체크 안 함. 단 **에너지는 반드시 02_G221-DOS(Γ 2×2×1)**
  — 21 트리에서 Γ-only 총에너지가 0.8 eV 틀렸던 함정은 이 규칙으로 구조적 회피.
- 노드 2개 × 36코어(cascade) = 72 rank. **NCORE=18/NSIM=36** (09의 16/32는 cascade2용이라 36을 못 나눔).

## ★ git clone 운용 (`__Defect_Package_Reference__` 복사 대신)
각 트리를 `git clone https://github.com/2-2much/Defect_Package.git <tree>` 로 받아 `.git` 유지 → `git pull`로 업데이트.
repo `.gitignore`가 allowlist(`/*` → `!scripts/ !example/ !README.md ...`)라
**root의 `config/` `POTCAR` `calc/` `results/` `Initial_POSCARs/` 복사한 `*.sh`가 전부 untracked** → pull 영구 충돌 없음.
유일한 금기 = `scripts/`·`example/` 안에 뭔가 넣거나 고치는 것. (인증은 `gh` credential helper로 이미 통과)
⚠ prepare 스크립트는 SLURM **job-name 접두어를 지원하지 않음**(`{case}_{q}` 하드코딩) → 생성 후 sed로 붙였고
`--mode overwrite` 재prepare 시 되돌아간다.

관련: [[inas100_par4x3_sheared_cell]] [[inas111_cl_ma_p4x3_tree]] [[inas100_acetate_tree_09]]
[[defect_package_repo]] [[cascade_parallel_settings]] [[slurm_jobname_distinct]] [[precfock_fast_policy]]
[[inas_facet_ipea_workflow]]
