---
name: mote2_ac_armchair_phase
description: "MoTe2 armchair(AC=1Tpp=LD2) 상 — 1T'의 대칭변종 아님(90°), 벌점은 셀당(4 f.u.) 값. 2V_Te 안정화 임계농도·SevenNet vs DFT 오차·MD T_anneal의 한계"
metadata:
  node_type: memory
  type: project
  originSessionId: 5617dea8-2982-4bbf-bc24-a593e179e1bc
  modified: 2026-09-27T05:39:40.892Z
---

2026-09-27 정리. 발표자료: `Armchair_distortion_induced_by_charge_and_defect_20260923.pdf`(서재욱·정재관), weekly 2026-09-23. SevenNet 값은 사용자 xlsx(SevennEnergetics/SevennStrain).

- 명칭: 사용자 1Tpp = 슬라이드 AC = xlsx `LD2`(AC 중 낮은 쪽, `LD`는 +0.56 eV 높은 다른 AC). `Tp`=1T'.
- ★AC는 60° 대칭변종이 아니라 **다른 준안정상**(90° 회전은 육각격자 대칭 아님).
- ★DFT 표 "eV/f.u."는 실제로 **4 f.u. 직사각셀당**(SevenNet Tile1과 크기 일치, weekly도 eV/cell). DFT: 1T' 0.364, AC 0.969 (vs 1H, 고정셀=1H 격자).
- SevenNet(7net-omni-i12) Tile1: Tp−H 0.443, LD2−Tp **0.802**(DFT 0.605, +33%). mono-V long 이득 0.310(DFT 0.145, ×2).
- Tile1(4 f.u.)+DiV: LD2_alt − Tp = **−0.011 eV** → SevenNet상 1 DiV/4 f.u.(Te 25% 제거)에서 겨우 역전. SevenNet 오차(0.2 eV/cell)보다 훨씬 작아 판정 불가 → DFT Tile1 DiV 필요.
- DFT 2×2(16 f.u.): DiV 이득 0.409 eV → 국소이득 가정시 임계 ≈ 2.7 f.u./DiV.
- 스트레인(SevenNet): LD2−Tp 0.80(1.00) → 0.588(1.07) → 0.549(1.10), 포화. H가 1.00에서 최저, Tp<H는 ~1.085 이상.
- MD(weekly): 2V_Te in AC 시작, 600→1000K(2ps)→hold 6ps→300K(4ps), dt 1fs, Langevin 10 THz, NVT → 1Tp로 감. 1000K 6ps 안에 AC→1T' = 장벽 낮음.
- ★핵심: 고정 조성 MD의 T_anneal은 V_Te 농도를 못 바꾼다. 실험의 T_anneal은 Te 탈착(μ_Te)을 통해 농도를 바꿈 → 다리는 μ_Te(T,P).

관련: [[sevennet_jh_tool]] [[gdrive_colab_sevennet_bridge]] [[mote2_vte_defect_setup]]

## 고농도 DiV AC 구조 (2026-09-27, 사용자 요청 — "빠르게 실험팀에 metastable 보여주기")
Drive `Armchair_9x10.vasp`(pristine AC, 1080원자, Mo dimer 전부 0°·2.94Å@1.07) 에 DiV 모티프(Te idx 675/955)를 Tile1 평행이동 복제.
9×10 셀은 직사각 부분격자만 가능 → 15/30/45/90 DiV만 가능. A=15(흩음, Te−4.2%) · C=30(세로줄, −8.3%) · B=45(가로줄, −12.5%). 90은 분해위험으로 제외.
생성기 = Drive `Armchair_9x10/make_AC_DiV.py`, 로컬 사본은 세션 scratchpad(휘발).

## ★A(15DiV) 결과 (2026-09-27, Drive md_20260927_061655_473437_15DiV_1.07strained)
- run_config: **dt_fs=5.0**(weekly의 1fs 아님)·tau 100fs·seed 42·**do_relax=False**(→ energy_comparison의 "E_initial_relaxed"는 미이완 이상구조라 ΔE −121.6eV는 상 비교 아님)
- 층 유지: Te 690 전부 Mo 3배위, Te 한 개만 위→아래 이동. 분해 없음
- 결과 = **1Tp**(zigzag ∥ x, 60°/120° 짧은결합), AC 0° 짧은결합 180→21(잔존은 DiV 근처 무질서 영역)
- ★순서변수(Mo마다 최근접 Mo 방향) 시간변화: AC 1.00 → 0.56(0.5ps, ~700K) → 0.27(1ps, ~800K). **승온 램프 중에 이미 붕괴**, 1000K hold는 무관. → AC는 SevenNet에서 ≥700K 0.5ps도 못 버팀. 다음=0K relax 후 300K hold로 준안정성 자체 시험
- 분석 스크립트는 scratchpad(휘발) — 순서변수 정의: 각 Mo의 최근접 Mo 벡터 각도를 60° 단위로 반올림(0°=AC)
- 2026-09-28: B(45DiV)·C(30DiV)도 600→1000K 프로파일에서 **전부 1Tp**(사용자 보고, 미분석). → 다음 = A를 do_relax=True + 300K 5ps 유지(승온 없음)로 준안정성 시험
- dt=5fs는 타당(사용자 지적 수용): MoTe2 최고 포논 ~290 cm⁻¹ → 주기 ~115fs, 5fs=1/23 주기. H 1fs(~3000cm⁻¹, 주기 11fs)보다 여유 큼. A 런 온도경고 0회. "공격적" 발언 철회
