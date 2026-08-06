---
name: in_i_shallow_donor_both_terminations
description: "In_i는 Cl-passv(01)·InCl3-passv(03) 양쪽 모두 shallow donor(전자 1개→host CBM). 03에서 E_F가 VB에 걸린 듯 보인 건 Γ-only 아티팩트. 가설 \"In_i+Cl→도너 상실\"은 아직 미검증"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6cac9ee2-5f63-46c0-8b3f-65bd6bb8d24d
  modified: 2026-08-03T02:45:25.510Z
---

12-Surace-defect_calculation, 2026-08-03 판정.

## 결론
**01-Cl-passv/In_i 와 03-InCl3-passv/In_i_2 는 둘 다 shallow donor.** 전자 정확히 1개가 host CBM으로 들어간다. 03에서 "E_F가 VB 쪽에 걸린다"는 인상은 **틀렸다** — Γ-only 아티팩트.

## 두 In_i는 사실상 같은 구조
| | 01/In_i (atom37) | 03/In_i_2 (atom49) |
|---|---|---|
| z_cart | 22.13 Å (Cl층 위) | 21.74 Å (Cl층 위) |
| 최근접 | Cl 2.96–3.12 Å ×4 | As 3.09, Cl 3.21/3.24 Å |

정상 결합(In–Cl 2.41, In–As 2.6) 대비 전부 무결합 → **halide 층 위 저배위 adatom**. 같은 구조라 같은 전자구조가 나오는 게 당연. cf [[in_i_2_adatom_ejection]]

## 근거 (03/In_i_2, Γ-only, pure 1016e → 1029e)
band 515가 결함준위가 아니라 host CBM이라는 4중 증거:
1. **IPR** pure CBM(band509) 0.0101/N_eff 99.2 ↔ 결함 band515 **0.0095/N_eff 105.7** (129원자)
2. **궤도성분** As 47.4%/In_d 40.3% ↔ **As 45.4%/In_d 41.4%**, 최대기여 원자도 As85–88 ↔ As86–89
3. **코어퍼텐셜 정렬** ΔV=+0.178 eV(In_d·As 일치) → pure VBM −0.9269→−0.749 vs band514 −0.7278(**21 meV**), pure CBM −0.5786→−0.401 vs band515 −0.4475(**47 meV**)
4. **interstitial In(atom49) 기여 1.16%** = 균등분포의 1.5배뿐

occ(band515)=0.5 → 전자 **정확히 1개**. E_F가 여기 pin.

## ⚠️ 왜 VB처럼 보였나 (재발 방지)
`bandos.png`에서 E_F 바로 위 갭은 **fundamental gap이 아니라 CB 부분밴드 간격**(band515→516 = **0.647 eV**). 진짜 VBM은 E_F −0.28 eV 아래. Γ-only는 k점이 하나라 반쯤 찬 CBM에 E_F가 정확히 얹혀 "점유 매니폴드 꼭대기"로 보인다.
→ **Γ-only DOS에서 E_F 위 갭을 gap으로 읽지 말 것.** pure와 정렬해서 밴드를 세라.

## 01/In_i 쪽 (2×2×1, ⚠Γ-only 아님)
정렬 ΔV=+0.263 → pure CBM(Γ) −0.021 vs band379(Γ) −0.0495 (28 meV 일치).
**E_F = 0.6952 = CBM + 0.745 eV** — Burstein–Moss (3×2 셀에 전자 1개 = 고농도). mesh를 써야 보이는 것이지 다른 물리가 아니다. cf [[bandfilling_measured_from_dos]]

## 자리별 안정성 (01 트리, ΔE = E_defect − E_pure, 같은 k끼리만 비교)
| 자리 | ΔE | frontier |
|---|---|---|
| In_i **adatom** (k221) | **−3.08 eV** | CBM (IPR 0.0120 vs pure 0.0118) |
| In_i_Td_As (Γ) | −1.28 eV | CBM계열 (0.0127 vs pure 0.0118) |
| In_i_Td_In (Γ) | −1.21 eV | CBM계열 (0.0213, 경계) |
| In_i2 **아표면** (k221) | **+0.45 eV** | deep localized |
03/In_i_2 adatom (Γ): −2.71 eV. → **adatom이 Td보다 1.5–1.9 eV 안정 = 바닥상태.**

## 가설이 맞는 곳은 있으나 무효
`01/In_i2`(슬랩 **내부** 격자간)는 실제로 도너를 잃는다: half-filled 준위가 CBM −0.375 eV, **IPR 0.080–0.209 (N_eff 5–12)**, Cl95 22–37% + As46 15–25% + In37 12–29%로 강한 국소화. 하지만 In_i(adatom)보다 **+3.54 eV** 높아 바닥상태 아님 → 배제.

## ⚠️ 02-HSE06 트리에 adatom 자리가 없다
02에는 In_i_Td_As / In_i_Td_In q0만 있고, **1.5 eV 이상 안정한 adatom 자리가 빠져 있다**. HSE 최종판정 전 반드시 추가.

## 미검증 — "In_i + Cl → 도너 상실" 가설
03/In_i_2는 termination만 InCl₃일 뿐 결함 자체는 **Δn_Cl = 0인 맨 In adatom**이라 가설의 대상이 아니다. 전자수 세기로는 가설이 타당: 맨 In adatom = 5s² lone pair + 5p¹ → CB에 1전자(계산과 일치, 두 트리 모두 1e). Cl 하나 씌우면 In–Cl σ가 그 전자를 먹어 closed shell → 캐리어 0.
→ 검증 계산은 [[next_steps_in_i_kohn]]

관련: [[cqd_ntype_origin_goal]] [[shallow_donor_inas_supercell_limit]] [[cl_shallow_donor_no_gap_state]] [[ipr_gate_tool]]
