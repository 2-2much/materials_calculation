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

**현재: 53506 p4×3 → (afterok) 53507 p4×4 / 53508 p4×5, 53503 pure_p4×3.** 전부 g2 12노드.

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
