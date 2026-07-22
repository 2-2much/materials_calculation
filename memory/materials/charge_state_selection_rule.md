---
name: charge_state_selection_rule
description: 전하상태 선택 규칙 — q0 실측 캐리어 수가 gap 내 CTL 개수의 상한. 04 defect별 확정표와 Cl-As_In 부호 정정
metadata: 
  node_type: memory
  type: project
  originSessionId: a36501db-d568-4425-8924-3511e61d9a67
  modified: 2026-07-22T11:16:33.343Z
---

**규칙: q0의 실측 캐리어 수가 gap 안에 들어갈 수 있는 CTL 개수의 상한을 준다.**
그 이상 이온화하면 host 밴드에서 전자를 빼야 하므로 CTL이 VBM 아래(또는 CBM 위)로
떨어져 **gap 밖**이 되고, DFE 다이어그램에서 아무 역할도 못 한다.

**Why:** 전자수 계산(electron counting)만으로 q를 나열하면 경우의 수가 폭발한다(04에서 ~29건).
실제로 필요한 것은 "형식 산화수 범위"가 아니라 "gap 안에서 실제로 일어날 수 있는 전이"다.
여기에 shallow-limit 작도 `E_f(q,E_F)=E_f(0)+q(E_F−E_g)`가 **q0 총에너지만 쓴다**는 사실을
결합하면, PHS 결함은 하전 계산 자체가 불필요해진다. → [[shallow_limit_dfe_construction]]

**How to apply:** ① q0 PROCAR에서 frontier 점유수와 IPR을 읽어 캐리어 수를 센다
② 셀-내부 비편재 밴드(1/IPR: VB~60, CB~105)로 host VBM/CBM을 잡고 그 **사이에 낀** 국소
준위(1/IPR<30)만 진짜 gap state로 센다 — 셀 간 고유값 정렬이 필요 없다
③ bound만 하전 계산, PHS는 shallow-limit.

## 04-InCl3-passv 확정표 (2026-07-22)

gap 창 전 밴드 IPR 스윕 결과 **11개 중 `In_As_1`(2.03×)·`In_As_2`(5.75× 채운 b512 +
6.51× 빈 b513) 둘만 gap 내부에 국소 준위를 가진다.** 나머지 8개는 전부 없음.

| defect | q0 캐리어 | 판정 q |
|---|---|---|
| In_As_2 | 채운+빈 국소준위 | **0,+1,−1** (+2는 b512가 VBM+0.08이라 gap 밖) |
| Cl_As_1 / Cl_As_2 | CB 전자 **2개**(occ 2.00) | 0,+1,+2 |
| Cl_i-As | CB 전자 **1개** | 0,+1 (⚠아래 단서) |
| V_As · In_i_2 | CB 전자 1개 | 0,+1 |
| V_In · **Cl-As_In** | **VB 홀 1개** | 0,**−1** |
| As_In | 닫힌껍질 | 0 |

## ⚠ 정정 2건

- **`Cl-As_In`은 도너가 아니라 얕은 억셉터다.** HOMO b508이 occ 1.0013/2.0 반점유 +
  IPR 1.037×(host VBM) = **VB에 홀 1개**. 02에서 +1/+2를 쓰던 관성으로 04에도 +1/+2를
  붙이면 **부호가 반대**다. 04는 Cl이 As_In이 아니라 표면 In에 결합한 다른 구조.
  → [[incl3_cl_as_in_unbound]] n형 기원 주제에선 오히려 보상 억셉터라 의미가 크다.
- **`V_In` EDGE-AMBIGUOUS는 계산 0시간으로 해소된다.** LUMO b503의 1/IPR=96.9 ≈ pure CBM 105,
  그리고 b503−b502=1.217 ≈ host gap 1.256 → b502가 VBM. 결정타: **1.1935 × 1.7379(pure
  VBM/CBM IPR비) = 2.074** 로 CBM 기준 2.07×가 정규화 인공물임이 산술로 확인된다 → shallow.

## ⚠ `Cl_i-As` 단일도너는 **잠정**이다

근거가 `00_Gam-relax`의 **Γ-only** EIGENVAL/PROCAR뿐이다(DOS·밴드 없음). occ=1.00은
NELECT 1023이 홀수라 **물리와 무관하게 강제**되므로 그 자체론 순환논증이다. 판정을
지탱하는 건 **b512의 1/IPR=103.5가 pure CBM(105)과 1.01× 일치**하고 b511(53.6)은
VB유래라 **점유된 CB유래 밴드가 하나뿐**이라는 점. Γ-only는 분산을 못 준다.
**결정적 확인 = DOS(2×2×1 tetrahedron, job 55606)** — [[bandfilling_measured_from_dos]]에서
V_Cl-Cl_As 전자수를 "총합 정확히 1.0000"으로 뽑은 그 방법. **CB 전자 2개로 나오면
`Cl_i-As` q+2를 추가해야 한다.**

## 검증 — 총에너지 ↔ 전자구조 대응은 이미 통과했다

기존 `In_As_1` 데이터만으로(추가계산 0) Koopmans 대조:
- bound(q+1): ΔE + E_corr = 1.0542 vs −E_HOMO = 1.0137 → **41 meV**
- delocalized(q−1): ΔE = 0.1897 vs E_LUMO = 0.1218 → **68 meV**

HSE AEXX 불확실성(수백 meV)보다 훨씬 작다. 즉 하전 총에너지 파이프라인이 건전하고
shallow-limit 작도가 ~68 meV에서 유효하다. 부수 결과: `In_As_1`의 유일한 gap 내 CTL이
ε(+1/0)=VBM+0.166 eV → **얕은 hole trap이지 n형 기원이 아니다**(검증 필요).
→ [[cqd_ntype_origin_goal]] [[ipr_gate_tool]] [[slabcc_delocalized_defect_policy]]
