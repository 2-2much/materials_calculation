---
name: vclclas_cohp_donor_evidence
description: "V_Cl-Cl_As/q0 COHP+COBI+Mulliken이 shallow donor 미시기원 확정: Cl_As는 이온성 반차수 결합(ICOBI 0.4 vs host In-As 0.8), 도너 전자 밴드의 Cl-In COHP≈0"
metadata: 
  node_type: memory
  type: project
  originSessionId: c6f88bf4-31fa-4e2c-90db-76d7de8a9d21
---

02-Cl-passv_6L_3x2x1_HSE06 / V_Cl-Cl_As / q0 COHP 분석 결론 (2026-07-17).
경로: `.../q0/02_G221-DOS/01-DOS_NBANDS=740/01-COHP/02-Cl_As-In_v2/` (v2 = reference 결합 + COBI + pDOS + `pbeVaspFit2015`).

**"defect state가 다른 원자와 섞여 보인다"는 분석 artifact가 아니다 — 국소화된 결함 준위가 애초에 없다.**
pure 슬랩 CBM과 defect band 370의 IPR이 **0.0128로 소수점까지 동일**(N_loc=78). 같은 PROCAR에서 진짜 국소 상태는 선명히 잡히므로(In 4d semicore IPR 0.94, Cl95 3s IPR 0.67) 도구 문제가 아니다. gap 창에서 Cl95 weight는 최대 3.1%로 균일분포(1/95=1.05%)와 다를 바 없다.

**핵심 정량 근거 (전부 v2에서 재현됨):**

| 결합 | d(Å) | ICOHP(eV) | ICOBI |
|---|---|---|---|
| Cl95–In28 / In30 / In33 | 2.77/2.75/2.64 | −2.62/−2.69/−3.50 | 0.359/0.367/0.472 |
| In33–As68 / As70 (같은 In 위 host 결합) | 2.61 | −4.66/−4.67 | **0.828/0.827** |
| In13–As49 (bulk-like, 결함서 8.9Å) | 2.64 | −4.42 | **0.790** |

- Cl은 As보다 원자가 전자가 2개 많은데 **결합 차수는 정확히 절반** → 여분 전자가 결합에 안 들어감.
- **도너 전자가 점유한 band 370(E_F−0.78 eV)에서 Cl_As–In |COHP| = 0.006 ≈ 0.** Cl–In 결합은 전부 −9~−5 eV(Cl 3p)에서 포화. 즉 도너 전자는 결합에 무관한 자유 캐리어.
- Gross population: Cl95 total **7.37** ≈ passivation Cl84 **7.43** ≫ host As49 **5.46**. Cl_As는 As 자리에 앉아도 전자수가 이온성 Cl⁻와 같다.
- Mulliken: Cl95 **−0.370** vs 치환당한 host As **−0.46~−0.52**. Cl이 As보다 전기음성도 높은데 **덜** 음전하 → 전자를 격자에 내놓음.

**미시 그림:** Cl_As는 As 자리의 공유결합 네트워크에 참여하지 않고 닫힌 껍질 이온성 Cl로 앉아 반차수 In–Cl 결합 3개만 맺는다. 그 자리가 공유결합에 필요로 하던 전자는 갈 곳이 없어 전도대로 올라간다 → 축퇴 n형. 미결합 라디칼이 없으므로 자성도 없고([[vclclas_atom95_fatband]]) gap도 깨끗하다([[defect_states_02_clpassv]]). [[cqd_ntype_origin_goal]]의 표면 결함 n형 기원에 직접 대응.

**LPARD 실공간 검증 완료 (2026-07-17).** PAW 구를 전혀 쓰지 않는 독립 증거로, IPR 결론을 재확인했다.
경로: defect `.../01-DOS_NBANDS=740/02-LPARD/` (PARCHG.0369/0370/0371.0001), pure `.../pure/q0/02_G221-DOS/02-LPARD/` (PARCHG.0372/0373.0001).

- 국소화 부피 V_loc = V_cell·(Σρ)²/(N·Σρ²): **defect b370 = 748 Å³ vs pure CBM(b373) = 771 Å³ (3% 이내 일치)**. 대조로 VBM은 defect 282 / pure 386 Å³. V_cell=4082 Å³.
- z planar-average 프로파일 **overlap coefficient 0.958, Pearson 0.990** — 결함 평면에서조차 갈라지지 않음. 그림: `calc/__defect-states-summary__/06_V_Cl-Cl_As_LPARD_zprofile.png` (스크립트 `plot_lpard_zprofile.py` 동봉).
- Cl_As 자리 구적분: r=2/3/4/5 Å에서 균일분포 대비 enhancement **1.57/1.55/1.59/1.58× — 반경 무관하게 평평**. 전하가 정확히 r³로 자람 = 균일밀도. 속박상태라면 작은 r에서 급증해야 함. 이 1.57배도 결함이 아니라 슬랩이 셀의 ~58%인 데서 나옴(1/0.58≈1.7). pure CBM을 같은 자리(pure As64, 0.142 Å 일치)에서 재보면 3.25% vs defect 4.28%로 사실상 동일.

**Why:** "gap level 그림"을 뽑으려던 시도가 실패한 게 아니라, 뽑을 대상이 없는 것이었다. deliverable은 "국소 준위 부재 + 도너 전자의 CB 점유 증명"으로 재설정해야 한다.

**How to apply:** 논문 논거 4종 모두 계산 완료 — (1) IPR 대조표(pure CBM 0.0128 = defect b370 0.0128 vs In4d 0.94), (2) ICOBI 반차수 표, (3) band370 COHP≈0.006, (4) LPARD V_loc 748≈771 Å³ + z-프로파일 겹침 0.958.
⚠**LPARD 재현 시 함정 2개**: HSE(LHFCALC)에 `ICHARG>10`을 주면 VASP가 "I REFUSE TO CONTINUE"로 즉사 → **ICHARG=0**(WAVECAR에서 ρ 생성) 쓸 것. 그리고 WAVECAR이 부모 심링크이므로 **LWAVE=.FALSE./LCHARG=.FALSE. 필수**(안 하면 부모 DOS 계산 파손). 노드 수는 NBANDS 보존으로 결정 — 1노드(32랭크)+NCORE=16 → band group 2 → 740/2, 450/2 정수라 안전. cf. [[lobster_cohp_setup]] 병렬화 항.
⚠difference DOS는 pure(`LREAL=A`, ISPIN=2, NBANDS=450) vs defect(`LREAL=.FALSE.`, ISPIN=1, NBANDS=740) 설정 불일치로 후순위이며, 위 4종이 이미 충분해 불필요.
