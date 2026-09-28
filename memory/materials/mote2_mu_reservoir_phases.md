---
name: mote2_mu_reservoir_phases
description: "MoTe2 결함 μ 기준상 문헌조사(2026-09-28) — Te=α-Te 벌크(T,P는 Te2+JANAF), Mo=bcc지만 Te-poor 한계는 Mo3Te4(실험 2상 공존), W=bcc·상한 WTe2 → W_Mo는 μ_Te 약분"
metadata:
  type: project
---

2026-09-28 사용자 요청 문헌조사. W 는 W_Mo 치환 도펀트로 가정(사용자 미확인).

| 원소 | 기준(Δμ=0) | 반대 한계 경쟁상 |
|---|---|---|
| Te | 삼방정 α-Te 벌크 | — |
| Mo | bcc Mo | **Mo3Te4** (Knudsen MS: MoTe2+Mo3Te4 2상 영역 820–950 K) → Δμ_Te ≥ [3ΔH(MoTe2) − ΔH(Mo3Te4)]/2. bcc Mo 하한은 Te-poor 과대평가 |
| W | bcc W | **WTe2**(Td) 용해도 한계 → 둘 다 텔루라이드로 묶이면 **E_f(W_Mo)에서 μ_Te 약분** |
| host | 단층 2H-MoTe2 (벌크 쓰면 창이 박리에너지만큼 이동) | |

- 단층 특유 Te-poor 상: Mo6Te6 NW·MTB 계열 MoTe2-x(Mo5Te8) — 어닐링 150→550°C 에서 T'→H→MoTe2-x→Mo6Te6 (arXiv 2407.14360). hull 에 같이 넣어 확인
- Mo1-xWxTe2 벌크는 x≈0.07–0.08 까지만 2H, 이상은 Td (arXiv 1610.02480)
- ★ T_anneal 연결은 μ_Te(T,P) = Te2 기체. DFT Te2 는 결합오차 커서 α-Te + 실험 승화엔탈피(JANAF)로 붙이는 게 관례
- 전 기준상 같은 footing(IVDW=13, ENCUT400). 계산 목록: α-Te, bcc Mo, bcc W, Mo3Te4, WTe2(Td), 단층 2H(+선택 Mo6Te6)

관련: [[mote2_ac_armchair_phase]] [[mote2_vte_defect_setup]] [[mu_reference_phases]]
