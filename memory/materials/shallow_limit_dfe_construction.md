---
name: shallow_limit_dfe_construction
description: shallow donor DFE를 하전상태 보정 없이 중성 에너지만으로 그리는 작도법 + 선결조건인 band-filling(Moss-Burstein) 보정과 Γ-only 함정
metadata: 
  node_type: memory
  type: project
  originSessionId: 5c11235d-04bd-4ac0-b00c-45768164ae48
---

**shallow donor([[ipr_gate_tool]] 게이트가 delocalized로 찍은 것)의 DFE를 어떻게 그릴 것인가.** 사용자 제안을 채택 (2026-07-17). 판정 방침은 [[slabcc_delocalized_defect_policy]].

## 작도 (채택)
E_f 기울기는 항상 q. shallow 한계에서 (+1/0)을 CBM에 못박아 절편을 정한다:

> **E_f(+1, E_F) = E_f(0) + (E_F − E_g)**   (E_F는 VBM 기준, E_g=gap)

**근사가 아니라 shallow의 정의 그 자체**다. 진짜 shallow donor면 q0는 속박 상태가 아니라 문자 그대로 D⁺ + e⁻(CB)이므로, 무한셀 극한에서 E_tot(q0)=E_tot(+1)+ε_CBM이 성립 → 두 선은 CBM에서 **반드시** 만난다.

**최대 장점: 하전 상태의 total energy를 아예 쓰지 않는다** → 우리가 못 푸는 charged-defect correction 문제를 통째로 우회. 중성 에너지 하나로 다이어그램 전체가 나온다. (PHS에 model-charge 보정을 강제하는 건 범주 오류이므로 이게 정공법 — [[slabcc_delocalized_defect_policy]])

**부르는 이름**: *"shallow-limit 작도(bound), band-filling 보정된 E_f(0) 앵커"*.

## 조건 3개 (빠뜨리면 틀림)
1. **측정이 아니라 bound**. CTL=CBM이라 단정하는 것. 실제 CTL이 CBM 위(공명)면 진짜 E_f(+1)은 CBM에서 E_f(0)보다 낮음 → 이 작도는 E_f(+1)의 **상한(보수적)**. "CTL ≥ CBM, gap 전역에서 이온화"까지만 주장하고 **점선**으로 그릴 것.
2. **E_f(0)에 band-filling(Moss-Burstein) 보정이 선행돼야 함**(아래). 앵커를 q0에 두는 순간 q0가 오차를 짊어진 상태가 되고, 그 오차가 +1 선 전체로 전파됨.
3. **V_Cl-Cl_As에 +2 선을 그리지 말 것** — single donor다(ε(+2/+1)=−0.28eV로 VBM 아래 = gap 안에 존재 안 함). 상세 [[defect_states_02_clpassv]].

## band-filling 보정 — 지금 파이프라인에 **없다**(진짜 구멍)
`grep -riE "band.?fill|moss|burstein" scripts/` → **0건**. 표준 처방은 Lany & Zunger, PRB 78, 235104 (2008).
- 크기: V_Cl-Cl_As q0에서 **~0.78eV**(셀-내부 기준). 형성에너지 자체와 맞먹음. **V_Cl-Cl_As 선이 틀린 규모는 E_corr의 ~0.1eV가 아니라 band-filling의 ~1eV 쪽.**
- 정체: 전자 1개/157.78Å² = 6.3e13 cm⁻²(≈5.8e20 cm⁻³)라는 인공 고농도 → **supercell artifact**(희박극한선 CBM에 앉음). E_tot(q0)가 그만큼 부풀려져 있음.
- ⚠**Γ-only의 함정(치명적)**: Γ-only에선 전자가 그 셀의 CBM에 그대로 있어 **자기 기준 band-filling = 0으로 오판**. 4k 기준 ⟨ε⟩−CBmin = **0.33eV**, 진공정렬 기준 0.70eV, 셀-내부 기준 0.78eV — **기준에 따라 0/0.33/0.78로 제각각**. 에너지 뽑는 `00_Gam-relax`가 KPOINTS `1 1 1`이라 그대로는 계산 불가.
- **필요 조건**: 최소 `02_G221-DOS`(2×2×1, 존재)로 ≈0.33eV 산정 가능하나 **1.19eV 분산 밴드엔 4k도 부족** → 실제로는 **4×4×1 이상**. 근본 해법은 **lateral 셀 확대(3×2 → 4×3)**로 캐리어 밀도를 낮춰 artifact 자체를 줄이는 것.
- ⚠정렬 필요한 기준(진공정렬)은 이 셀에서 ill-defined([[defect_states_02_clpassv]]) → **셀-내부 기준만 쓸 것**.

## 미확인 함의
E_f(V_Cl-Cl_As q0)는 이미 In-rich에서 −1.08eV인데, band-filling 보정을 넣으면 E_tot 과대평가가 걷혀 **더 음수로 내려간다** → 표면 donor 안정성 주장이 오히려 강해지는 방향. [[cqd_ntype_origin_goal]]에 직접 영향.

## 구현 (2026-07-20, fork 검증 완료) — `scripts/plot_shallow_limit_DFE.py`
plot_DFE 본체(1120줄) 건드리지 않고 그 출력 `DFE_at_EF0_summary.csv`(q0의 E_f(0))를 소비하는 전용 스크립트. **donor/acceptor 대칭**:
- shallow **donor**: `E_f(+1,E_F)=anchor+(E_F−E_g)` (CBM에서 anchor와 만남, 점선 dashed)
- shallow **acceptor**: `E_f(−1,E_F)=anchor−E_F` (VBM에서 anchor와 만남, 점선 dotted). 채택 사유=donor의 부호대칭(VBM 앵커, 기울기 −1).
- **band-filling 부호**: `anchor=E_f(0)−E_bf` (E_bf≥0 **차감**, Lany-Zunger는 밴드모서리서 밀려난 캐리어 초과에너지 제거 → E_f 더 음수로). V_Cl-Cl_As In-rich raw −1.078 → 0.78 차감 → −1.858. **`+E_bf`는 부호오류**(초판 버그, 수정됨).
- 미입력 시 `PRELIMINARY` 태그(raw 앵커, Moss-Burstein 안 걷힘). CTL 미작도. shallow 집합은 IPR_gate.csv 자동추론(`--donor/--acceptor` override).
- ⚠**auto-inference는 +1·−1 둘 다 delocalized면(예 As_In) 양쪽 라벨=모호** → 자동에서 제외+경고, 명시 지정 요구(전하부호는 이상격자 대비 전자수가 정함, "이 전하가 delocalized"만으론 결정 못 함).
- ⚠CSV 컬럼: `Ef0_raw_eV, bandfill_eV, anchor_eV, Ef_at_VBM_eV, Ef_at_CBM_eV`. 초판서 VBM/CBM 스왑 버그 있었음(수정됨, PNG는 원래 정상).

물리적 배경(왜 도너 준위가 안 보이는가, 공명 vs 닫힌껍질 이온성 도너): [[shallow_donor_inas_supercell_limit]]
