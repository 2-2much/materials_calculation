---
name: inas100_inplane_scan_todo
description: InAs(100) As_In+Cl in-plane(b축) 분산 스캔 — 2026-07-27 착수·제출 완료. mono-alt는 b홀수 불가라 mono-A로 전환한 것이 핵심 결정
metadata: 
  node_type: memory
  type: project
  originSessionId: bc80c5b5-7478-4d31-a59b-c06425588c04
  modified: 2026-07-27T09:12:05.948Z
---

2026-07-27 **착수·제출 완료**. 두께 8 ML 확정([[inas100_8ml_thickness_verdict]]) 다음 단계.
위치: `10-Primitive-slab/00-Convergence_test_unitcell/04-inplane_100_As_In-Cl/`
(README.md 에 전모, 스크립트 6개 자립)

## ⚠ 최대 발견: mono-alt 로는 p4×3 / p4×5 를 만들 수 없다

`make_100slab.py` L151-160 의 `cl_mode` 규칙상 **mono-alt 는 Cl 소속 In 이 `iy % 2`
함수** = **b축 주기 정확히 2** (p(2×2)). b 를 홀수배 하면 주기경계에 **antiphase
domain wall** 이 생겨 배치가 깨진다.
⚠⚠ **스크립트는 a축(dimer축) 홀수만 `raise` 하고 b축 홀수는 조용히 통과시킨다** —
경고를 기대하지 말 것. `verify()` 도 배위수만 보므로 못 잡는다.

| cl_mode | a 배수 | b 배수 | p4×3 | p4×4 | p4×5 |
|---|---|---|---|---|---|
| mono-alt p(2×2) | 짝수 | **짝수** | ✗ | ✓ | ✗ |
| **mono-A p(2×1)** | 짝수 | 제한 없음 | ✓ | ✓ | ✓ |

**결정 = mono-A 로 전환**(사용자 승인). 근거: ⑴ 비용이 **8.3 meV / 2×2 셀**(4.2 meV/Cl)
뿐이고 갭도 열린다, ⑵ **b축 주기가 1이라 표면 자체가 b\* zone-folding 을 안 만든다**
→ 결함 밴드의 b-분산을 깨끗하게 읽는 데 오히려 유리, ⑶ LDA 선례(acetate 전면 균일)와
같은 성격. 이완된 mono-A 2×2 의 b-주기-1 은 실측 **0.000018 Å** 로 엄밀 → 타일링 정당.

## 결함 정의 (확정)

표면 In-dimer 의 **맨(Cl 없는) In → As**, 그 위에 Cl 1개 추가(파트너 Cl 의 거울상).
Δn_Cl=+1. As_In 이 +2e, Cl 이 −1e → **NELECT 홀수 = 홑전자 1개** → **ISPIN=2 필수**.
LDA 선례의 "antibonding 에 전자가 차서 갭 안으로 내려온다" 와 정확히 일치.
As_In 은 아래 As 2 + dimer 파트너 In 1 + 새 Cl 1 = 4배위, Cl–Cl 최소 3.09 Å.

| cell | b (Å) | 원자수 | NELECT | As_In idx | NBANDS |
|---|---|---|---|---|---|
| p4×3 | 13.131 | 127 | 923 | 80 | 552 |
| p4×4 | 17.508 | 169 | 1231 | 104 | 708 |
| p4×5 | 21.884 | 211 | 1539 | 136 | 864 |
| pure p4×3 | 13.131 | 126 | 924 | — | 552 |

(a 는 17.508 Å 고정 — LDA 선례에서 Γ→X 는 이미 평탄. 휘는 건 Γ→Y·X→S 뿐)

## 제출 상태 (2026-07-27)

**현재: 53506 p4×3 → (afterok) 53509 p4×4 / 53510 p4×5. 53503 pure_p4×3 완주.** 전부 g2 12노드.
밴드 KPOINTS 는 세그먼트당 20 → **10** 으로 줄임(pure 만 아직 20).

⚠ **이완 설정 번복**: 처음 EDIFF=1E-4 + IBRION=1(속도용)로 갔더니 **131 이온 스텝에서
dE 가 ±5e-5 eV 로 부호 진동**하며 수렴 실패 — 힘 노이즈가 EDIFFG 0.015 와 같은 자릿수.
`INCAR0` 주석이 경고하던 그 현상. → **EDIFF=1E-6 + IBRION=2** 로 전환(ISIF=0 유지).
STOPCAR(LSTOP=.TRUE.)로 정지 → CONTCAR 이어받아 재시작(53502 폐기, run1 은
`p4x3/00_Gam-relax/__run1_EDIFF1e-4_IBRION1/` 에 보존).
⚠⚠ **이완 단계에 LWAVE/LCHARG=.FALSE. 를 두면 STOPCAR 재시작 때 WAVECAR/CHGCAR 가
0바이트라 못 물려받는다** — 지금은 둘 다 .TRUE.. run_*.sh 는 재개 가능(STOPCAR 삭제 →
CONTCAR→POSCAR → WAVECAR 유효시 ISTART=1/ICHARG=0).
⚠ 의존 잡 재연결 순서: **먼저 p4×4/p4×5 를 scancel** 하고 p4×3 을 멈춰야 레이스가 없다.
run1 성과: As_In–Cl **2.374 → 2.205 Å 로 결합**(AsCl₃ 2.16 Å 정합), 아래 As 2.682 → 2.517 Å.
**(110) 에서 겪은 Cl 탈착은 (100) 에선 안 일어났다.** mag = 0.70 μB (자성해 확인).
p4×4/p4×5 는 잡 시작 시 `expand_from_p4x3.py --install N` 이 **이완된 p4×3 를 통째로
유지하고 pristine b-row 를 끝단에 삽입**해 POSCAR 를 만든다(=(110) a-스캔의 strip
insertion. 이상 위치 재구성은 Cl 탈착을 부른다). registry 는 b-주기-1 덕에 엄밀.

## MAGMOM 초기화 (2026-07-27 추가)

`set_magmom.py`: As_In + 결합 4원자(표면 In 1·아래 As 2·캡 Cl 1)에 **2 μB**, 나머지 0.
근거: VASP 기본 MAGMOM 은 **전 원자 1.0** 인 균일 강자성 시작점이라 대칭성은 깨도
**국소 라디칼로 유도하지 못한다** → 홑전자 결함이 비편재 저모멘트 최소에 갇힐 수 있다.
p4×4/p4×5 는 run script 의 `setmag` 훅이 각 단계 POSCAR 에서 매번 재유도, p4×3 은
배치 스크립트가 이미 스냅샷돼 있어 01_1shot/02_band INCAR 에 정적으로 주입.

⚠ **결함 식별자 = Cl 과 결합한 유일한 As**(pristine 엔 그런 As 없음).
**"최고 z 의 As" 로 찾으면 틀린다** — 이완하면 As_In 이 **표면 In 면보다 아래로 가라앉는다**
(p4×3 실측 z 0.6693 → 0.6601, 표면 In 은 위에 남음). analyze_band.py 도 같은 함정이었음.

⚠ **SLURM 은 sbatch 시점에 배치 스크립트를 스냅샷한다** — 제출 후 run_*.sh 를 고쳐도
PENDING 잡에 반영 안 됨. 반드시 scancel → 수정 → 재제출. (INCAR/KPOINTS/POSCAR 는
런타임에 읽으므로 그냥 고치면 됨.)

**게이트 3겹(2026-07-27 밤)**: ⓐ p4×3 1shot/band = `01_1shot` 디렉토리를
`01_1shot.__on-hold__` 로 옮겨 53506 이 relax 직후 exit 1, ⓑ p4×4(53509)·ⓒ p4×5(53510)
= `scontrol hold`. 순서는 relax 수렴 → 프로브 → MAGMOM 결정 → p4×3 1shot/band → release.
진행 상태는 폴더의 **STATUS.md** 에 유지한다.

**p4×3 재이완 판정 = `p4x3/00b_magmom-probe`** (변형은 **m2 = 클러스터 2 μB 하나만**;
기준선은 이완 최종 SCF 자체가 같은 기하·Γ·같은 EDIFF 의 기본-MAGMOM 단일점이라 별도 런 불요): 기본 MAGMOM 이완이 `mag≈0.70 μB` 로
앉았는데, 같은 기하·같은 k(Γ)·같은 EDIFF 로 **MAGMOM 만 targeted 로 바꾼 단일점**을 돌려
이완 최종 E0 와 직접 비교한다. MAGMOM 은 초기 추측일 뿐이고 01_1shot 은 ISTART=0 이라
스핀을 재수렴하므로, 이완의 스핀해는 **기하를 통해서만** 하류에 영향을 준다.
|ΔE| 작고 mag 일치 → 재이완 불필요. E 더 낮거나 mag 다름 → 재이완 + p4×4/p4×5 재시드.

⏭ 수확: `analyze_band.py` (PROCAR 투영으로 결함 밴드 식별 — 밴드 인덱스로 세지 말 것.
⚠ VASP 가 CONTCAR 타이틀을 잘라서 결함 인덱스를 못 물려주므로 **기하로 재탐색**한다).
읽을 값 = bDisp(E_Y−E_Γ), aDisp(E_X−E_Γ, 대조군), X→S. 목표는 bDisp 가 충분히
작아지는 b 를 고르는 것.

⚠ 결론은 **HSE06 + spin** 에서 재확인해야 한다. PBE-d 는 추세 스캔용.
⚠ 정량값(CTL/형성E)은 분산이 아니라 total energy + 유한크기 보정 경로로 낸다.
⚠ InAs 도너 a_B=349 Å — 얕은 도너가 밴드에 안 보이는 건 정상([[shallow_donor_inas_supercell_limit]]).
   여기서 보는 건 국소 As_In–Cl antibonding 이지 hydrogenic 도너가 아니다.

관련: [[inas100_pseudoh_lasph_footing]] [[cqd_ntype_origin_goal]] [[inas100_slab_generation]]
[[passivated_surface_tiling_shortcut]] [[slabcc_delocalized_defect_policy]]
