---
name: cl_shallow_donor_no_gap_state
description: "Cl_As·Cl_i-As shallow donor의 defect state 위치 — gap엔 없음. 깊은 결합공명(Cl 3p, 비특이적)+host CB로 기증된 delocalized 전자. IPR 검증 완료"
metadata: 
  node_type: memory
  type: project
  originSessionId: a36501db-d568-4425-8924-3511e61d9a67
  modified: 2026-07-24T06:48:06.399Z
---

2026-07-24. 02 `V_Cl-Cl_As`(Cl_As antisite)·04 `Cl_As_1/Cl_As_2`(Cl_As antisite)·`Cl_i-As`(Cl 흡착)
— DFE 최저 shallow donor들. "CTL 없는데 밴드구조에서 defect state는 어디냐"에 대한 정공법 답.

## 방법
defect 원자에 projection한 fatband(`zeroband.py`) + 03_Band PROCAR 밴드별 무게 + IPR.
**defect 원자는 기하학으로 확정**(defects.yaml 인덱스는 초기 POSCAR 순서라 03_Band와 다름 주의):
- 02 V_Cl-Cl_As: antisite Cl = **atom 95**(z=17.97, In 3배위)
- 04 Cl_As_1/Cl_As_2: antisite Cl = **atom 116**(In 3배위, former As site)
- 04 Cl_i-As: 흡착 Cl = **atom 129** + 파트너 surface As = **atom 85**(Cl-As 2.18Å)

## 결과 (독립 검증 에이전트 IPR로 CONFIRMED)
**gap 안 defect 무게 = 정확히 0.0000.** defect state는 두 곳에만 있다:

1. **깊은 결합 공명** Cl 3p ↔ In/As, **-5~-6.5 eV**(VBM 아래), 완전점유. Cl 무게 91–93%가 VBM 아래.
   ⚠**비특이적**: antisite Cl과 passivation Cl 무게 거의 동일(총 2.75 vs 2.70, 3p창 1.54 vs 1.44)
   → "-6 eV 깊은 공명"은 defect준위 아니라 일반 Cl 3p 화학. **Cl_i-As만 예외**=셀 내 유일한
   Cl-As σ 결합(Cl129+As85 공유 ~-5 eV)이라 진짜 defect 고유 상태.

2. **host 전도대로 기증된 delocalized 전자**(도너). 부분점유 밴드:
   Cl_As_1/2 = 509+510(전자 **2.0**개=이중도너), Cl_i-As = 512+513(**1.0**개=단일도너).
   IPR: Cl_As 0.041–0.042, Cl_i-As 0.018–0.022 (host VBM 0.025 수준, N_eff 24–55원자).
   진짜 localized 밴드 IPR 0.66–0.99 대비 **15–40× 낮음**. 분산폭 0.83–1.05 eV.
   defect-Cl 성분 3–4× bg(Cl_As, >96% host) / 1.7× bg(Cl_i-As, ~99% host).

## 전자 수 세기 (2026-07-24 검증)
Cl_As는 **새 밴드(상태)를 만들지 않는다**: As(s+p)↔Cl(s+p) 교환이라 궤도·상태 총수 보존
(pure NBANDS=Cl_As NBANDS=544, 원자수 128 동일). 늘어난 건 **전자 2개뿐**
(pure NELECT=1016→508밴드 채움 VBM=508; Cl_As_1 NELECT=1018). 그 2전자가 **최저 전도대
band 509를 채운다**(밴드≤508 occ=2 전부, 밴드≥509 적분=정확히 2.0e). VBM은 pure·doped 모두 508.
"defect band를 weight 작아 못 잡는다"는 오해 — band 509를 이미 정확히 포착했고, weight 작음(≈host)이
물리적 진실. band 509=약한 antisite Cl(최대 6.4×bg, IPR 3.7×균일)+최대분산(0.83eV)=host CBM에
혼성된 resonant/shallow 도너 지문(순수 host와 국소준위의 중간), 그래도 localized 준위 아님.
유효질량: E_B=1.36meV, a_B=348.6Å(셀 27배). 셀↑→pull-down 0.33eV→1.4meV로 줄어 band 509가
CBM에 merge(gap에 준위 나타나는 게 아니라 사라짐)+파동함수 349Å로 퍼져 Cl성분→0. 작은 셀이 과장.

## 결론
gap엔 아무 준위도 없다. **n형은 gap 도너준위가 아니라 순전히 전자수**(Cl 여분 전자가
host CB 채움)에서 나온다 = 슬라이드 "excess carriers in CB in neutral state"와 일치.
CTL 부재도 이 때문(국소준위 없음→전이시킬 준위 없음). 도너밴드가 gap 안으로 ~1 eV
끌려내려와 보이는 건 셀 작음(도너 a_B 349Å≫셀) 아티팩트, 실제 CBM 바로 아래 shallow.

관련: [[charge_state_selection_rule]] [[shallow_donor_inas_supercell_limit]]
[[defect_states_02_clpassv]] [[bandfilling_measured_from_dos]]
