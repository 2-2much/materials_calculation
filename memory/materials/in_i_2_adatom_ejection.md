---
name: in_i_2_adatom_ejection
description: In_i_2/q0 (03-InCl3-passv)는 안정 결함 아님 — interstitial In이 3.76Å 튕겨나가 Cl층 위 저배위 adatom으로 배출. 음의 E_form은 In이 금속기준으로 회귀한 신호. 내일 재검토 TODO
metadata: 
  node_type: memory
  type: project
  originSessionId: 128f0b2e-1225-49fa-96e0-d9a67bd6705e
<<<<<<< HEAD
  modified: 2026-08-03T04:15:07.946Z
=======
  modified: 2026-08-03T02:45:56.498Z
>>>>>>> 906cdaf (Auto-sync: Claude Code session (bloch))
---

12-Surace-defect_calculation/03-InCl3-passv_6L_4x2x1_PBE-d, defect **In_i_2/q0** (Gam-relax, 힘 수렴 EDIFFG -0.01).

**증상**: interstitial In(atom49)이 이완 중 초기 frac_z 0.615(격자 내부) → 최종 0.719(Cl passivation 층보다 위)로 **3.76 Å 튕겨나감**(다른 원자는 최대 0.74 Å). 최종 최근접 이웃 = As86 **3.09 Å**, Cl **3.21 Å** → 정상 결합(In–As≈2.6, In–Cl≈2.4) 대비 전부 무결합. 즉 In이 격자에서 배출되어 Cl-passivated 표면 위 **저배위 In adatom**으로 떠 있음. "Cl에 붙었다"는 시각적 인상은 실제 결합 아님(3.2Å).

**형성에너지**: In-rich **−0.20 eV(음수)**, As-rich +0.29 eV (results/DFE_plots/DFE_at_EF0_summary.csv). 
⚠️해석: 음의 E_form = "In interstitial이 안정" 이 아니라, **In이 결함 대신 거의 금속 In 기준상태(μ_In metal)로 회귀** → 결함형성 비용 소멸의 신호. 이 표면에서 In_i는 존재 못하고 adatom으로 배출된다는 뜻. −0.20 eV 값 자체는 약결합 adatom이라 fragile(진공두께/lateral셀/PBE-d dispersion/초기배치에 민감).

**✅2026-08-03 해소**: 전자구조 판정 완료 — 이 adatom은 **shallow donor**(전자 1개가 host CBM). 그리고 01-Cl-passv/In_i도 z=22.13 Å에 Cl 2.96–3.12 Å로 **동일한 adatom 구조**이며 같은 결론. 즉 adatom 배출은 termination 무관한 재현 현상이고, "배출됐으니 결함이 아니다"와 별개로 **도너로는 멀쩡히 작동**한다. 자리 안정성도 역전 없음 — adatom이 Td보다 1.5–1.9 eV 안정(=바닥상태). 상세·근거 → [[in_i_shallow_donor_both_terminations]]

**남은 TODO**:
1. ISPIN/magmom 확인 — In⁰ adatom open-shell 가능(In_i 자성 애매 이력, cf [[surface_defect_spin_screening_full]]). 단 frontier가 완전 delocalized CBM(IPR 0.0095)이라 스핀분극은 거의 0일 것으로 예상
2. 이 adatom이 saddle인지 진짜 local min인지 판정
3. ~~In이 3-fold hollow/bridge에서 결합 만드는 배치 재탐색~~ → 01 트리에서 아표면 자리(In_i2)·Td 두 자리 모두 확인했고 전부 adatom보다 높음. 대신 **Cl 캡을 씌운 InCl_i**를 볼 것 → [[next_steps_in_i_kohn]]

관련: [[cqd_ntype_origin_goal]] μ-diagram에 이 fragile 값 올리기 전 검증 필요. [[incl3_cl_as_in_unbound]]와 유사 패턴(ideal 배치→표면종 이탈).

---
## ⚠ 2026-08-03 정정 2건 (kohn 실측)

1. **이 계산의 자리는 In2+As1이 아니라 In 3개 hollow였다.** 초기 최근접 = In35 2.56 /
   In37 2.56 / In45 2.74 (As 없음). 새 정의의 In_i_2 = In37/In45/As85 hollow는 **다른 자리**다.
   → 이 폴더는 `03-.../__legacy_calc_2026-07__/In_i_3In-site/`로 격리 보존. 새 계산과 혼동 금지.
   자리 정의·좌표는 [[in_i_surface_sites_01_03]].

2. **adatom 배출은 InCl3 표면 고유 현상이 아니다.** 01-Cl-passv의 2026-06-15 `In_i`
   (Cl 사이 배치)도 **똑같이** 배출됐다: z 19.17→22.13 Å(+2.95), 최종 최근접 Cl 2.96~3.12 Å
   = 전부 무결합. 즉 "passivation 층 아래엔 In이 앉을 자리가 없다"는 게 두 표면 공통.
   같은 폴더의 `In_i2`는 초기 구조가 Cl과 **1.32 Å**로 겹쳐 Cl이 슬랩 밖으로 탈출한
   무의미한 계산 → `__legacy_calc_2026-06__/In_i2_BROKEN-1.32A-start/`로 격리.

TODO 1(ISPIN)은 새 셋업에서 해결됨: 00_Gam-relax부터 ISPIN=2 seed로 돌린다.
