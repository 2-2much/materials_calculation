---
name: facet_ip_pseudoh_top_face_rule
description: 면별 IP 비교의 함정 — IP는 top 면만 읽으므로 그 면의 pseudo-H 조성이 값을 지배. (110)만 H1.25/H0.75가 상쇄되어 낮게 나옴
metadata:
  type: project
---

`sham:~/materials/33-inAs/__Functional_Validation__/10-Primitive-slab/04-Facet_IP-EA` (PBE-d, a0=6.189842,
쌍극자 보정 ON, macroscopic-average로 **bulk 유래** 밴드엣지 정렬, ΔV_bulk=3.8258 eV, E_g=0.4485 eV(bulk HSE06 AEXX=0.27)).

**IP는 `vaclevel.py`가 top 면 진공 plateau만 읽는다(`--side top` 기본).**
따라서 값은 **top 면에 무엇이 종단돼 있는지**가 결정한다:

| 그룹 | top 면 종단 | H1.25 밀도 | H0.75 밀도 | IP |
|---|---|---|---|---|
| B1 (100) In-1x1 | In + **H1.25만** | 0.1044 Å⁻² | — | 5.48 |
| B3 (111) In-2x2 | In + **H1.25만** | 0.0603 Å⁻² | — | 5.43 |
| B2 (110) sym | In+As + **H1.25·H0.75 1:1** | 0.0369 | 0.0369 | 4.86 |
| S1 (110) bare | H 없음 | — | — | 4.78 |

★ **(110)의 IP가 작은 건 (110) 표면 물리가 아니라 유일하게 상쇄되는 면이기 때문.**
H1.25(양이온 DB 채움, H가 음전하 → IP↑)와 H0.75(음이온에 전자 줌 → IP↓)가 같은 면에 1:1.
**직접 증거: (110) bare 4.78 → pseudo-H 4.86, 겨우 +0.08 eV.** H 4개를 붙였는데 안 움직임 = 상쇄.

**정량**: Helmholtz ΔV=180.9·Σ(q_eff·Δz)/A. top 면 순 쌍극자 밀도 n·Δz/A =
(100) 0.1211 / (111) 0.1065 / (110) 0.0528−0.0468=0.0060 Å⁻¹.
예측비 1.145 vs 실측비 (0.62/0.57)=1.088 — 5% 이내. q_eff≈0.030 e/pseudo-H로 두 면 공통.

**함의**: 이 세 IP는 서로 비교 가능한 양이 아니다(리간드가 다른 세 표면과 같음).
면끼리 비교하려면 **세 면을 같은 종단으로** 통일해야 함 → CQD 목표상 Cl 종단이 맞음
(`03-Top-Cl_Bottom-H-Fixed` 확장). 극성면 bare는 금속(In DB 부분점유)이라 IP 정의 자체가 안 됨;
A1(100 bare)·A4(111 bare)는 vac_slope 1.85~2.10 meV/Å로 PLAN §6 G3 게이트(1.0) 탈락해 그림에서 빠짐.

**교차 확인**: 독립적인 LDA 두께맞춤 세트(~43 Å, H 이완 통일, bloch)에서 서열 재현 —
(100) 5.451 > (111) 5.204 > (110) 4.957. 내 세트는 쌍극자 보정이 없어 **양면 평균**이라
면간 격차가 sham(top 면 전용)의 약 절반. 서열은 동일.

관련: [[jh_thickness_ie_pseudoh_artifact]] [[inas100_ligand_site_vs_electron]] [[surface_defect_dipole_correction]]
