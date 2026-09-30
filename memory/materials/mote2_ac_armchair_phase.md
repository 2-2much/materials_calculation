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

## ★A 300K-hold 결과 (2026-09-28, md_20260928_021859_855700_15DiV_1.07strained_300K-hold)
- ★**0 K LBFGS 이완만으로 AC가 붕괴**: 최근접방향 0°/60°/120° = 1.00/0/0 → 0.17/0.17/0.67 (64 step, E −6122.7→−6215.3). MD 이전에 결론
- 300K 5ps: 0.13~0.18 유지(추가 변화 거의 없음). 300K→0K E=−6219.2 · 이전 1000K→0K E=−6244.2 (고온이 29 eV 더 낮은 1Tp 정돈)
- ★해석: 9×10+DiV로 대칭이 깨지면 SevenNet의 AC는 **극소점이 아니라 안장점**일 가능성. Tile1(4 f.u.) SevenNet/DFT의 'AC 준안정'은 작은 셀 대칭이 1Tp 방향 힘을 0으로 막은 결과일 수 있음
- 다음 판정자 = pristine AC에 rattle(0.02Å) 후 이완 — Tile1·3×3·9×10, SevenNet 먼저, 살아남지 못하면 DFT(Tile1 rattle 또는 Γ phonon)로 확인

## ★AC 결합 위상 확정 + 문헌 선례 (2026-09-28)
- `Armchair_9x10_SingV_1.07strained.vasp` 분석: Mo **360개 전부 짧은 결합(2.9Å) 정확히 1개, 전부 0° 평행** → **고립 Mo₂ 이량체 180개**(나머지 3.5/3.6Å). 1T'(Mo당 2개, 지그재그 사슬)와 위상이 다르다
- 문헌조사: 같은 패턴을 **다른 6족 TMD에서 보고한 것 못 찾음**. 최근접 선례 = **단층 IrTe₂ 2×1 이량체상**(Nat Commun 2022, 벌크엔 없음, 갭>1eV, Ir–Ir 3.12 vs 3.88Å, 국소 singlet) — 단 Ir d⁵(단일결합) vs Mo d², Fig.4b로 Ir당 결합 1개인지 미확인
- d² 고립 이량체 선례는 TMD 밖: 비틀린 루틸 MoO₂/WO₂. "1T't'"(홀도핑 MoS₂)는 1T'과 같은 셀·부분 이량화라 AC 아님. "2×1"만으로는 1T'(chains of dimers)와 구분 안 됨
- 제안(미실행): MoS₂/MoSe₂/WTe₂/WSe₂에 AC 만들어 SevenNet 추세 → DFT 확인

## ★rattle 시험 (2026-09-28, Drive Armchair_9x10/sevennet_rattle_results/20260928_104438_AC_4x5_vol-rlx_rattle, 노트북 sevennet_AC_rattle_test.ipynb)
- 입력 AC_4x5_vol-rlx.vasp = DFT로 AC 격자까지 이완(무변형), 240원자, dimer ∥x 2.81Å
- ★SevenNet에서 **AC는 진짜 극소점**: rattle ±0.02Å ×3 seed 모두 AC 1.00 복귀, E_final 비트 동일(−1413.1406), 29 step 수렴(FMAX 0.005)
- ★격자 비교: AC 이완 tile a=7.192 b=6.010 (b/a 0.836 vs 육각 0.866). 2H 격자 대비 a +2.7%, b −0.9%. **"1.07" 셀은 AC 기준 a +4.2%, b +8.0%**(비등방)
- → 9×10 15DiV 붕괴 원인 후보 = (a) AC에 비등방 인장 (b) DiV. 분리 시험 필요: pristine AC를 2H 격자·1.07 격자에서 rattle

## ★스트레인 rattle v2 (2026-09-28, 20260928_110613_AC_4x5_strain_rattle, 노트북 v2_cueq)
- DiV 없이 격자만: `2H_x1.07`(a×1.042,b×1.080) · `AC_iso_x1.07` 둘 다 **안장점**. no_rattle만 AC 유지(대칭 갇힘)
- rattle 후 AC 0.33~0.48, 60/120 섞인 다도메인. ΔE: 2H_x1.07 −67~−72 meV/f.u., iso −41~−53 meV/f.u.(비등방이 더 불안정)
- ★결론: **7% 인장 자체가 AC를 안장점으로 만든다(SevenNet)**. 지금까지 1.07 셀 MD(1/15/30/45 DiV)가 1Tp만 낸 건 셀 선택 탓. DiV 효과는 아직 미시험
- 다음: 등방 배율 1.00→1.06 스캔(+2H_x1.00=a×0.974,b×1.009)으로 임계 스트레인 · AC 이완격자 8×10 MD · DiV를 AC 격자에서. 실험팀 주장 전 DFT로 7% 불안정 확인 권장

## ★vol-rlx 9×10 300K MD (2026-09-30, md_20260930_013231_…_AC_9x10_vol-rlx / md_20260930_014605_…_DiV)
- 셀 = AC 이완 격자(tile 7.192×6.010, 64.73×60.10 Å). DiV = Te idx 675/945. do_relax 없음(DFT 좌표 그대로)
- ★**AC 이완 격자에서도 300K에서 무너짐**: AC 비율 pristine 1.00→0.85(0.5ps)→0.53(1ps)→0.24(2ps)→0.10(5ps); DiV도 거의 동일(0.88→0.47→0.17→0.09)
- → SevenNet의 AC는 0K 극소점이지만 **장벽이 수 kT 수준**(300K에서 ~1–2ps). v1 rattle의 '극소점' 판정과 모순 아님
- ★DiV 주변 국소 AC **없음**: 0K 이완 후 DiV로부터 거리별 AC 비율 <5Å 0.11(9 Mo), 5–8Å 0.00, 전체 0.10 ≈ pristine 같은 자리 0.00/0.00/0.13. 빨간 0° 결합은 두 셀 모두 도메인 경계에 ~10% 흩어져 있음(사용자는 DiV 주변 AC로 봤음)
- 다음 판정자 = DFT AIMD(작은 AC 셀 300K 1–2ps) 또는 AC→1T' NEB(DFT vs SevenNet)로 **장벽 크기**가 SevenNet 오차인지 확인
