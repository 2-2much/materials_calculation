---
name: inas100-ma-copassiv-tree-08
description: 08-100Cl-MA_8L_par4x3_PBE-d — Cl/MA co-passivation 탐침 2셀. ⚠표준 N/C PAW가 ENMAX=400이라 ENCUT=400 필수 → 07(300)과 총에너지 비교 불가. 기준셀은 MA_i-In
metadata: 
  node_type: memory
  type: project
  originSessionId: 21521b3d-9090-4351-9826-e8574651dc0d
  modified: 2026-08-10T05:36:29.551Z
---

2026-08-10 생성. `12-Surace-defect_calculation/08-100Cl-MA_8L_par4x3_PBE-d`.
07(Cl 단독)에 **methylamine(CH3NH2) 1개**를 얹어 ChemComm 2017의 cp(100)(2×1)
(= dimer + Cl 1 + MA 1)에 한 발 다가간 탐침. 논문 노트에 적혀 있던 검증 과제
*"(100):Cl에 MA를 얹고 CBM의 1D 성격이 사라지는지 본다"*의 최소 실행판.

## 두 셀 (둘 다 133원자, 7종 POTCAR)
| case | 조성 | NELECT | MA 결합 |
|---|---|---|---|
| `MA_i-In` (=이 트리의 `pure`) | In_d48 As48 H.75 24 Cl6 N1 C1 H5 | 938 even | bare In23에 In–N 2.30 Å |
| `MA-As_In` | In_d47 As49 H.75 24 Cl6 N1 C1 H5 | 930 even | As_In antisite에 As–N 2.10 Å |

기하 seed = **07의 이완된 q0 CONTCAR**(`pure`, `As_In`의 `01_Spin-gam-relax`)에 MA 부착.
MA 내부는 표준 기하(N–C 1.471 / N–H 1.014 / C–H 1.093 Å, 사면체), N은 앵커의
**빈 배위 방향**(이웃 단위벡터 합의 반대)에, 메틸 방위각은 2°씩 스캔해 슬랩 접촉이
가장 느슨한 각도. MA는 L-type이라 14전자를 더해도 **패리티가 안 바뀐다**.

## ★ 기준셀을 MA_i-In으로 잡은 이유
두 셀은 MA가 **같은 자리(In23)** 위에 있어 차이가 정확히 In→As 하나다. 그래서
`E_f(MA-As_In) = E(MA-As_In) − E(MA_i-In) − μ_In + μ_As`가 성립하고, **7종 POTCAR
하나로 두 셀이 같은 발판**에 놓인다. 패키지는 프로젝트당 POTCAR 1개라 이게 유일하게
깔끔한 구성이었다.

## ⚠ ENCUT=400 — 07과 총에너지 비교 금지
표준 `N`·`C` PAW의 **ENMAX = 400 eV**. 07의 `ENCUT=300`은 이 종 구성에 미달이라
400으로 올렸다. ⇒ **이 트리의 에너지는 07(300)과 섞으면 안 된다.**
- soft `N_s`(280)/`C_s`(274)를 쓰면 300 유지가 가능하지만 정확도를 버린다. 표준을 택했다.
- **E_ads(MA)는 아직 못 구한다**: `E(슬랩+MA) − E(슬랩) − E(MA gas)`가 필요한데
  뒤 둘은 종 구성이 달라(4종 슬랩 / 3종 분자) 각자 POTCAR·트리가 있어야 한다. 미설치.

## 그 밖
- 진공이 **13.3 Å**(07은 14.5). MA가 1.2 Å를 먹는다.
- ⚠ 화학적 예상: As_In은 전자가 남는 double donor, MA는 전자를 **주는** L-type →
  Cl-As_In(X-type Cl이 전자를 받아 2.20 Å 결합)처럼 안 붙을 수 있다.
  **이완 중 MA가 떨어져 나가면 그 자체가 결과**("co-passivated 표면에서도 As_In은 도너").
- ⚠ **VASP는 CONTCAR 종 이름 줄에 `H.75`를 `H.`로 잘라 쓴다**(5칸 필드). 계산 자체는
  POTCAR 순서만 보므로 무해하지만, CONTCAR을 `Initial_POSCARs`로 수확해 다른 트리에
  넘기면 `check_species_order`가 막는다. 08의 `runtime.yaml`에 `H.: H.75` alias를
  넣어 뒀다. **07/HSE 이관 때도 같은 처리 필요.**
- 잡 55972(`MA-pure_q0`) / 55973(`MA-As_In_q0`). cascade 4노드, 4 stage 구성은 07과 동일.
  `pure` case의 잡 이름만 손으로 `MA-pure_q0`로 고쳤다(prepare에 prefix 기능 없음,
  [[slurm_jobname_distinct]]).

관련: [[inas100_par4x3_defect_set_07]] [[inas100_ligand_site_vs_electron]]
[[inas100_mu_cl_convention_cl2]] [[cqd_ntype_origin_goal]]
