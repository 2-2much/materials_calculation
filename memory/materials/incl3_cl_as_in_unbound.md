---
name: incl3_cl_as_in_unbound
description: "03-InCl3-passv Cl-As_In q0 — Cl이 As_In에서 떨어져 표면 In으로 감. ⚠2026-08-04 갱신: bound minimum은 존재하나(T2) 해리상태보다 +183meV metastable"
metadata: 
  node_type: memory
  type: project
  originSessionId: be2e35fe-68fd-4740-909f-1cf615f9ce7d
  modified: 2026-08-04T08:48:26.967Z
---

**03-InCl3-passv_6L_4x2x1_PBE-d의 Cl-As_In q0 결과 해석 (2026-07-08)**

모델 구성(원자수): pure=Cl 12(=InCl3 passivation, In_L 4 : Cl 12 = 1:3). As_In=Cl 12. Cl-As_In=Cl **13**(passivation 12 + defect Cl 1개). 즉 defect는 "As_In antisite에 Cl 원자 1개 추가".

초기구조: As_In q0 CONTCAR 위에 Cl을 As_In 바로 위 수직(Cl–As≈2.0Å)으로 삽입. **최종(CONTCAR)**: As_In(As001)은 antisite 자리 거의 유지, 그러나 **Cl(Cl013)은 As_In에서 떨어져 표면 In으로 이동(In–Cl 2.41Å = 전형 In-Cl 결합)** → 사실상 InClx 재형성.

**결론**: "Cl–As_In complex"는 bound state가 아님(=As_In + In에 붙은 Cl 두 독립 defect). Cl은 강전기음성 음이온이라 In(양이온)에 붙는 게 화학적으로 옳음 → 계산 오류 아님, 올바른 물리. (같은 패턴 [[adispersion_scan_pbed]] ideal 배치→desorption.)

## 2026-08-04 갱신 — Cl 자리를 틀어서 재시도(T2): bound minimum은 **존재한다**

위 결과(=T1, Cl을 antisite 바로 위 수직 1.99Å)의 초기구조를 보면 Cl이 이미 In_L(113)에서 3.68Å,
즉 반쯤 이웃이었다. Cl을 그 In에서 멀어지도록(In_L113까지 5.50Å) 기울여 놓은 것이
`inputs/defects/Cl-As_In_T2/POSCAR` — **POSCAR 마지막 한 줄(Cl013 = 원자 129)만 다르고 나머지 128원자는 동일**.

| case | Cl129–As48 | Cl129–In_L | E(σ→0) |
|---|---|---|---|
| T1r (원래 자리 재실행) | 3.383 Å (해리) | **In_L113 : 2.409 Å** | −466.29725 eV |
| T2 (자리 조절) | **2.306 Å (결합 유지)** | 최근접 In 3.61Å = In_d(기판), 결합 아님 | −466.11394 eV |

- **ΔE = E(T2) − E(T1r) = +183 meV.** → Cl–As_In bound complex는 **진짜 local minimum이지만
  해리상태(Cl이 InCl3 ligand In으로 이동)보다 183 meV 불안정한 metastable 상태**.
  따라서 "bound complex 아님"이라는 위 결론은 **바닥상태 판정으로는 그대로 유효**하고,
  DFE에는 T1r(해리) 에너지를 쓴다. 다만 "결합 자체가 불가능"은 아니었음 — 표현을 구분할 것.
- T2에서 As48은 As 3개(2.50/2.57/2.85Å) + Cl 1개로 4배위, As–Cl 2.31Å(공유반경합 2.21Å 대비 +4%)로
  약하지만 실재하는 결합. 이완 중 Cl129는 0.71Å만 움직였다(국소 basin).

### T1r = 기존 계산의 완전 재현 (설정 차이는 무의미했다)
기존 `calc/Cl-As_In/q0`는 ISPIN=1 / NBANDS=540 / EDIFFG=−0.01 / g1의 `dftd4` gam 바이너리였고,
T1r은 ISPIN=2 / 594 / −0.015 / cascade의 `wan90` 바이너리다. 그런데 결과는
**구조 max|Δr| = 0.028 Å, E(σ→0) 차이 0.04 meV**로 사실상 동일.
→ 이 계에서는 옛 ISPIN=1 값을 새 값과 **그대로 섞어 써도 된다**.

### ⚠ 03에서는 Cl-As_In q0가 **비자성**이다 (02와 다름)
NELECT=1015(홀수)인데 ISPIN=2 + MAGMOM 시드로 출발해도 **mag = 0.0000으로 수렴**,
EIGENVAL에서 e_up ≡ e_dn(교환분리 0), 최상단 밴드가 spin당 occ≈0.5로 반쯤 참 —
남은 홀전자가 E_F의 **비국소 밴드에 들어가 있어서 국소 모멘트가 생기지 않는다**
([[cl_shallow_donor_no_gap_state]], [[shallow_donor_inas_supercell_limit]]와 일관).
02-Cl-passv에서 같은 이름 결함이 −171 meV 자성이었던 것([[surface_defect_gam_relax_spin_comparison]])은
**passivation이 달라서(bare Cl vs InCl3) 03로 이월되지 않는다.** 03에서 ISPIN=2는 해가 없지만 이득도 없음.

**defect 설계 권고**: complex를 여기저기 배치 스캔하는 것보다(대부분 같은 In-Cl basin으로 흘러감) **독립 donor 후보로 재정렬** — As_In 단독, In_i(석출 In), Cl_i/Cl_As 각각 계산 후 CTL을 μ-diagram에서 비교. 이번 구조도 버리지 말고 전자준위(DOS/band) 확인: As_In이 CBM 근처 donor 유지 & Cl 비활성이면 "As_In=n-type origin, Cl=passivant 재형성" 스토리. 상위목표 [[cqd_ntype_origin_goal]]. ⚠사용자가 ~/papers 논문 정리 후 defect 리스트 확정 예정.
