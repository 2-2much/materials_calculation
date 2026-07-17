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

**Why:** "gap level 그림"을 뽑으려던 시도가 실패한 게 아니라, 뽑을 대상이 없는 것이었다. deliverable은 "국소 준위 부재 + 도너 전자의 CB 점유 증명"으로 재설정해야 한다.

**How to apply:** 논문 논거는 (1) IPR 대조표(pure CBM 0.0128 = defect b370 0.0128 vs In4d 0.94), (2) 위 ICOBI 반차수 표, (3) band370 COHP≈0. 셋 다 이미 계산 완료. 보강하려면 LPARD(`IBAND=370 371 KPUSE=1`, WAVECAR 있음)로 실공간 PARCHG를 pure CBM과 나란히 보이면 "PAW 구 밖 40% charge" 반론이 차단됨. ⚠difference DOS는 pure(`LREAL=A`, ISPIN=2, NBANDS=450) vs defect(`LREAL=.FALSE.`, ISPIN=1, NBANDS=740) 설정 불일치로 후순위. LOBSTER 셋업 함정은 [[lobster_cohp_setup]].
