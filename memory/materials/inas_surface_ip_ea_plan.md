---
name: inas_surface_ip_ea_plan
description: "InAs (100)/(110)/(111) IP/EA — 2026-08-18 착수 확정: bare 셀은 (110)에만 있었고, primitive 생성기가 bloch에 다 있어 sham에 전용 트리를 새로 팠다. PLAN.md 위치·확정 파라미터·bare 셀 재고"
metadata:
  type: project
---

2026-08-18 설계 단계(계산 미착수). 동기: **어셉터 형성에너지가 표면 방향에 따라
달라졌고 특히 (100)에서 낮았다.** 이게 밴드정렬(각 슬랩의 VBM이 진공 기준 어디냐)
때문인지 국소 화학 때문인지를 가르려면 세 표면을 **공통 절대 눈금(진공준위)**에
올려야 한다. → [[cqd_ntype_origin_goal]]

## ⚠ 작업 위치 제약

표면 트리(`05/06-(100)`, `11-110bare`, `21-111Cl-MA`)는 **kohn 로컬 /home 에만** 있다
([[inas100_worktree_on_kohn]]). sham → kohn 은 SSH 공개키 미등록이라 거부됨
(sham→bloch 도 동일). **이 작업은 kohn 세션에서 할 것.** 서버 판별은 `hostname -A`.

## 설계 결론 5가지

### 1. ★ 진공준위를 읽는 면이 지금 틀려 있다
슬랩이 전부 비대칭(앞=실제 표면 / 뒤=pseudo-H)이고 **dipole correction 전량 OFF** →
진공 전위가 기울어짐(실측 63~91 meV/Å, [[surface_defect_dipole_correction]]).
`11-110bare/04-summary` 가 진공창을 **pseudo-H 면에 고정**한 것은 셀 간 정렬 기준으로는
옳지만 **IP/EA 로는 반대쪽 면**이다. 거기 나온 `pure VBM −4.9209 / CBM −4.4705`
([[inas110_bare_q0_charged_dfe]])는 IP 로 인용 금지 — 실험 (110) IP≈5.3 eV 와도 안 맞는다.

→ **처방: pure 셀만 `LDIPOL=.TRUE., IDIPOL=3, DIPOL=<고정값>` 으로 PBE-d NSW=0 재실행.**
HSE 미수렴 사고는 결함 셀 HSE 얘기였고 pure PBE 3개는 싸다. 그래야 양쪽에 평탄한
plateau 가 생겨 표면 쪽 진공준위를 직접 읽는다. DIPOL 은 반드시 고정값(auto-center 금지).

### 2. "VBM" 을 두 트랙으로 분리
[[inas110_bare_surface_state_gap]] 이 직격한다 — bare (110) frontier 는 표면 As DB /
In DB 라 슬랩 고유값 직독은 IP 가 아니라 **표면상태 준위**를 준다. (100):Cl, (111)A:Cl 은
리간드로 DB 를 없앴으니 성격이 또 달라, 셋을 같은 방식으로 읽으면 **서로 다른 물리량을
비교**하게 된다.

- **트랙 A = macroscopic average 정렬** (이게 목적에 필요한 것).
  bulk 계산에서 `E_VBM − V̄_bulk` → 슬랩 내부 `V̄` 를 진공에 맞춤 → `IP = V_vac − E_VBM^bulk`.
  표면상태 유무와 무관하게 잘 정의되고, **DFE/CTL 을 절대 눈금으로 옮기는 데 필요한 건 정확히 이 양**.
  ⚠ 슬랩 중앙에 bulk 주기가 최소 2주기 있어야 함 — 6L 은 아슬아슬, 두께 점검 필요.
- **트랙 B = 슬랩 고유값 직독**. 표면상태가 진공 기준 어디 앉는지 = 실제 E_F pinning 위치.
  덤으로 "bare (110) In DB 밴드가 bulk CBM 아래냐"에 답한다.

### 3. 슬랩 HSE 는 불필요 — 정렬 PBE / 밴드엣지 bulk-HSE
PBE-d bulk InAs gap = 0.0000 ([[bulk_vas_jt_isym_artifact]]) 이라 EA=IP−E_g 가 PBE 로는 무의미.
그러나 정렬항 `V_vac − V̄_slab` 은 정전기량이라 범함수 의존이 거의 없다.
→ **정렬 = 슬랩 PBE-d, `E_VBM − V̄_bulk` 와 `E_g` = bulk HSE06+PBE-d.** 비용 1/20.
SOC(Δ_SO≈0.38 eV → VBM +0.13)는 세 표면 공통 bulk 항이라 **상대 정렬에는 안 들어온다**;
실험 절대 비교 때만 상수로 얹는다.

### 4. ★ 비교 footing — 리간드가 교란변수
종단이 제각각이다: (100)=In종단+Cl 0.75 ML / (110)=bare / (111)A=Cl·MA.
**Cl 은 전기음성도가 커서 표면 쌍극자로 IP 를 수백 meV 올린다.** 이 상태로 비교하면
"표면 방향성" 이 실은 "리간드 피복률 차이" 일 수 있다.
→ 최소 두 세트: **bare 3종**(순수 방향 효과) + **Cl-passivated 3종**(CQD 실물).
권고 순서 = bare 3종 먼저. 셀도 작고, 결과가 애매하면 리간드까지 안 가도 5번 답이 나온다.
⚠ (100)/(111)A 의 bare 셀, (110) 의 Cl 셀이 있는지 kohn 에서 확인 필요.

### 5. 검증 가능한 정량 명제
E_f^acc 가 (100)에서 낮은 게 밴드정렬 탓이라면, 어셉터(q=−1)를 **절대 E_F 눈금**으로
옮겼을 때 표면 간 차이가 **정확히 ΔIP 만큼 상쇄**돼야 한다. 즉 IP(100) > IP(110),(111)
이면서 **차이의 크기까지** E_f 차이와 맞아야 한다.
안 맞으면 원인은 정렬이 아니라 **국소 화학**(결함 자리 배위 환경). 어느 쪽이든 결론이 난다.

## ★2026-08-18 착수 — 위 설계의 4·5번이 실제 재고로 갈렸다

### 미해결 2개 해소
1. **어셉터 = V_In 과 Cl_In 둘 다.** V_In 이 (100)에서 (110)/(111)보다 **약 1 eV 낮다**.
   Cl_In 은 V_In 보다 훨씬 더 낮지만 **μ_Cl 범위를 고려하면 순서가 뒤집힐 수 있다.**
   IP/EA 비교는 **결함 없는 깨끗한 표면 기준**으로 계산한다.
2. 순서 = 사용자 지정 사다리로 확정: 전 표면 **아래면 pseudo-H 고정**,
   **① top bare** ((100)은 unreconstructed/reconstructed 2종) → **② top pseudo-H** ((100) 2종)
   → **③ 리간드**(Cl / Cl-MA / AA).

### ⚠ bare 셀 재고 (실측) — 설계 4번의 "bare 먼저" 권고를 뒤집었다
결함 트리 4개 중 **bare 는 `11-110bare` 하나뿐**. `05/06/07`(100)은 Cl 0.75 ML,
`21`(111)A는 Cl9+MA2. 반대로 Cl 세트는 3개 중 2개 보유. 그리고 (111)A bare 는
NELECT 홀수라 (2×2) In-vacancy 재구성부터 필요 → bare 신규 제작이 오히려 비싸다.
(07 CONTCAR 실측으로 (100) 표면이 **(2×1) In-dimer** 확인: In–In 2.896~2.898 Å,
표면 In 12 = dimer 6, Cl 6 = dimer당 1개.)

### ★ 그런데 결함 트리는 애초에 IP/EA용이 아니다 — primitive 생성기가 bloch에 다 있다
`bloch:~/materials/33-inAs/__Functional_Validation__/10-Primitive-slab/01-Slab_generation_PBE-d/01-PBE-d-lat/`
(564 KB, kohn엔 없음). `make_100slab.py`(`--reconstruct none|dimer --ligand none|Cl
--cl-mode mono-A|mono-alt|bridge --termination In|As --supercell --vacuum`),
`make_111slab.py`, (110) 노트북 + 완성 POSCAR 세트((100) 4~16 ML, (110) 4~40 L, (111) 2~8 BL).
★ **(110) 생성기가 내놓는 슬랩은 양면 대칭 = 순 쌍극자 0** → 파이프라인 검증셀이 공짜.
🔧 없는 것 3개: (100)/(111) **top pseudo-H 옵션**, (111) **In-vacancy 재구성**, (110) **비대칭판**.

### 작업 트리 (신규)
`sham:~/materials/33-inAs/__Functional_Validation__/10-Primitive-slab/04-Facet_IP-EA/`
→ **상세 플랜은 그 안의 `PLAN.md`.** kohn·bloch가 계산자원 포화라 sham 선택
(g1 62노드×8코어, 488/496 idle). 생성기는 kohn 경유로 이관 완료(sham→bloch SSH는 막혀 있음).

확정 파라미터: **a0 = 6.189842 (PBE-d)**, **ENCUT = 400**, 진공 20 Å, `LVHAR=.TRUE.`,
`IDIPOL=3 + LDIPOL + DIPOL 고정값`, ISYM=0, k는 그리드가 아니라 **밀도**(n·|a| ≥ 50 Å) 정합,
VASP = **6.3.2/vasp.6.3.2.std.x** ([[g1_node_vasp_binary_limit]] 2026-08-18 정정 참조).
⚠ 기존 05·07·11(ENCUT 300)과 **절대에너지 혼용 금지** — 자립 눈금이다.

⚠ pseudo-H 결합길이 `In–H 1.70 / As–H 1.52` 는 (110) 노트북 v2.6 물림값이고 (111)에서
1.5626으로 갈렸다([[inas111_slab_generation]]). **top In–H 는 아예 처음 쓰는 값** →
1×1이라 공짜이니 표면·자리별 재최적화를 Step 1로 먼저 한다.

### 아직 못 찾은 것
`slabthicknessLJH_2025.12.16.xlsx` 와 옛 IE/EA 런 디렉토리가 **kohn·sham·bloch 어디에도 없다**
(`/mnt/hohenberg` 도 비어 있음). bloch `10-Primitive-slab` 의 67 GB 선행계산은 **(110) 전용
두께 스캔**이지 3-facet 스캔이 아니다.
