---
name: jcc_acceptor_vacuum_ghost_state
description: "JCC(Zhang2023) BN 재현 — 도너 δE0(+1)=−0.894(논문 −0.943) 성공, 억셉터 δE0(−1)=−0.073 실패. 원인=진공 ghost state. 정량 판정식: |δE0| ≳ EA면 전자가 진공으로 샌다"
metadata:
  type: project
---

2026-09-03. `~/materials/__JCC_Reproduction__/01-dE0_BN_6x6_Lz30`
hBN 6×6, a=2.5148(우리 PBE), S=197.170 Å², **Lz = 셀 높이 c = 30.000 Å**,
ENCUT400 / PREC=A / LREAL=A / ISYM=0 / NSW=0 / Γ-only / EDIFF 1E-6.

## 결과 — 도너만 재현된다
| q | 우리 δE0 | 논문 Table II | 역산 ε⊥ |
|---|---|---|---|
| **+1** | **−0.894 eV** | −0.943 | **1.283** ✅ 5% 이내 |
| −1 | −0.073 eV | −0.943 | 15.6 ❌ |

## ★원인 = 진공 ghost state (논문 §III 경고의 실측)
CHGCAR 차분 평면평균 (시트 ±4 Å 기준):
- q=+1 정공: **−0.9998 e 전량이 시트 안** → JCC 전제(z-국재) 성립
- q=−1 전자: 시트 0.394 e / **진공 0.604 e** → 프로파일이 셀 경계에서 최대

정량 판정식(이번에 세운 것):
- LOCPOT 진공준위 = +0.8938 eV(평탄도 0.04 meV), ε_CBM=−0.277 → **EA = 1.17 eV**
- 젤리움이 진공준위를 끌어내리는 크기 ≈ |δE0| ≈ **0.94 eV** (∝ Lz)
- 0.94 가 1.17 에 육박 → 부분 유출. **|δE0| ≳ EA 이면 억셉터는 깨진다.**
- Lz 줄이면 ∝Lz 로 작아짐: Lz=20 → ~0.63, Lz=15 → ~0.47 eV (안전)

증거 보강: q0의 CBM은 2중 축퇴(−0.2770)인데 qm1에서 −0.3486/−0.2234로 0.125 eV 갈라짐
= 하전 셀에서 진공유래 상태가 π* 아래로 내려와 band 144의 정체가 바뀐 것.

## How to apply
- **JCC를 억셉터(q<0)에 쓰기 전에 반드시** ① CHGCAR 차분 평면평균으로 진공 유출 확인
  ② |δE0| vs EA 비교. 이건 사후보정으로 못 고친다 — 바탕 3DJM 계산 자체가 망가진 것.
- 도너(q>0)는 정공이 항상 시트에 묶여 있어 안전. InAs n형 기원 연구는 주로 도너라 다행이나,
  V_In·Cl_In 같은 억셉터에는 이 게이트를 걸 것([[inas110_bare_q0_charged_dfe]]).
- **Lz 를 키우는 것이 항상 안전하지 않다** — 진공 수렴 직관과 반대. [[vacuum_scan_vbm_reference_trap]]
  의 "15Å도 OK"와 같은 방향의 교훈.

## 미해결
논문은 같은 Lz=30에서 q=−1 도 −0.943 을 얻었다(=q² 대칭). QE/NC vs VASP/PAW 차이인지,
그들의 Lz 규약이 다른지 미확인. **Lz 스캔(15/20/25/30/35)으로 억셉터 붕괴 문턱을 찾는 것이 다음 단계.**

관련: [[dfe_p1_vacuum_asrich_fixed]], [[shallow_donor_inas_supercell_limit]], [[charged_defect_vbm_ref]]
