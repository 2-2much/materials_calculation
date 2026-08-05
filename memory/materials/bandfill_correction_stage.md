---
name: bandfill_correction_stage
description: "PHS/band-filling이 slabcc와 동급의 correction 단계로 구현됨(bandfill_correct.sh). 주입값 0.78eV는 폐기, 계산값 V_Cl-Cl_As=−0.125eV. 파서/판정 함정 5종"
metadata: 
  node_type: memory
  type: project
  originSessionId: 340ad81d-e5d9-4a40-9b89-2322800c2b2a
  modified: 2026-08-02T09:20:40.807Z
---

2026-08-02, 02-Cl-passv_6L_3x2x1_HSE06. 검증 에이전트 2인(물리·코드) 교차검증 후 확정.

## 파이프라인 (신규 단계)
`bandfill_correct.sh` → `results/corrections/bandfill_01-spin-gam/bandfill_corrections.csv`
→ `plot_DFE.sh`가 **소비만** 함 → `plot_shallow_limit_DFE.py --mode all`.
`slab_correct.sh`(slabcc)와 **배타적**: bound=slabcc, delocalized=이쪽.
구현 = `scripts/run_bandfill_corrections.py`. `ipr_gate.py`는 06 폴더 최신본으로 교체
(`STAGE=01_Spin-gam-relax`, ISPIN=2) — DFE 에너지와 같은 계산에서 판정하기 위함.

## ⚠주입값 0.78 eV 폐기
`E_bf(V_Cl-Cl_As q0) = **−0.125 eV**` (PHS 가지). **부호도 크기도 달랐다**(0.78은 앵커를
내리고, 실제는 **올린다**). In-rich VBM 형성E: −3.05 → **−2.18 eV**.
옛 `DFE_shallow_limit.{csv,png}`는 `results/DFE_plots/_superseded_2026-08-02/`로 이관.

## 검증 (k-사다리, 정답을 아는 케이스)
`calc/__k-point_test__/Vcl_neutral_PBEd` 5 rung을 `--pair`로 채점 → `analyze_kpt_conv_ctl.py`와
**소수점 4자리 일치**: Γ −0.0504 / 2×2×1_G +0.3057 / 3×3×1_G +0.4307 / 4×4×1_G +0.4188,
N_e=1.0000 전 rung. Γ=PHS(음수) → mesh=MB(양수) 부호 반전까지 재현.

## 프로덕션 값 (Γ-only이라 MB=0, PHS만)
donor 5개: V_Cl-Cl_As −0.125 / In_As −0.336(N_e=2) / In_i_Td_In −0.179 /
In_i_Td_As −0.053 / As_i_Td_In −0.028. 나머지(As_In·Cl-As_In·V_Cl-Cl_In·V_Cl-V_As·V_Cl-V_In)=0.
**As_In은 q0에 CB 전자가 없어 shallow donor가 아니다**(공여자 아님과 일치).
신뢰도: **V_Cl-Cl_As만 플래그 0개**. In_As는 IPR 1.46×(bound 문턱 2.0에 근접)+정렬민감 0.40 eV
→ 단독 인용 금지.

## ⚠함정 5종 (전부 실측으로 확인)
1. **EIGENVAL ISPIN=1 occ는 [0,1], PROCAR는 [0,2]** → ×2 안 하면 전 가전자상태에 유령 정공,
   `E_bf=+3537 eV`가 `status:ok`로 나감. `analyze_kpt_conv_ctl.py`도 `2.0*w*o`를 씀.
2. **OUTCAR core potential이 −101.2268이면 인덱스와 값이 붙는다**(`1-101.2268`). HSE(−94.58)는
   안 붙어서 안 드러남 → `split()` 페어링은 PBE-d에서 조용히 실패.
3. **IPR 기준은 k점별로 잡아야 함**. pure 전도모서리 IPR이 Γ 0.0119 vs 존 모서리 0.0285(2.4배)
   → Γ 기준으로 재면 2×2×1_G에서 도너 전자 1/3을 날림(N_e 0.666).
4. **하전 셀은 보정 불가**. q+1의 비워진 도너 준위가 갭 안으로 끌려가 가전자 정공으로 오분류
   (V_Cl-Cl_As q+1: 캐리어 0개인데 N_h=2.0, E_bf=−0.227). 정렬로 못 고침 → `n/a (charged)`로 출력.
5. **pure에 PROCAR 없으면 IPR 필터가 조용히 무력화**(임계값 NaN → 전부 통과). 이제 양쪽을 확인.

## ⚠정렬(ΔV)은 기본 OFF, 그러나 논거가 중요
"중성이라 불필요"는 **틀린 논거**(q·ΔV 에너지항과 고유값 영점 공유는 다른 문제).
진짜 이유: 이 슬랩은 상수를 정의할 수 없다 — ΔV가 z축으로 **0.13~0.64 eV 기울어짐**
(층 내부 산포는 0.005 eV). pure 자신의 쌍극자는 차분에서 상쇄되므로 이 잔여 기울기는
**결함이 쌍극자를 추가**한다는 뜻(dipole correction OFF 상태).
→ **미해결 항**: 이 결함 유발 쌍극자는 `E_f(0)` 자체에 든 미보정 유한크기 항이고 여러 E_bf보다
크다. 이걸 처리하기 전엔 고유값 정렬 자체가 well-posed하지 않다.
CSV에 `E_bf_unaligned_eV`/`E_bf_aligned_eV` 병기, 50 meV 초과는 `ALIGN-SENSITIVE` 플래그.

## 부수
- `plot_DFE.sh`에 `--energy-column energy_sigma0_eV` 명시 → 홀수전자 행 **+22~29 meV 이동**
  (기존 CSV는 `toten`=F−TS 기반이었음). VBM·E_g도 하드코딩 제거하고 pure에서 측정(−0.7746 / 1.2505).
- `V_Cl-Cl_In q0` 게이트 판정이 ISPIN=1→2에서 bound(5.56×)→shallow(1.22×)로 뒤집힘. 단
  q0에 캐리어가 없어 보정=0, 그림에서도 bound로 그려져 **결과 영향 없음**.

관련: [[shallow_limit_dfe_construction]], [[bandfilling_measured_from_dos]],
[[vclclas_kpt_ladder_two_routes]], [[slabcc_delocalized_defect_policy]], [[ipr_gate_tool]]

## ⏭pydefect 대조 (2026-08-03, 착수 전)
노트=`02-Cl-passv.../PYDEFECT_COMPARISON.md`. 로컬 미설치(vise 0.9.5만), GitHub master 직독.
**pydefect는 band-filling을 아예 안 한다** — PHS는 검출해서 다이어그램에서 **뺀다**
(`allow_shallow=False`). 즉 우리 E_bf 숫자를 검증해 주지 않음. 빌려올 건 **판정기**다:
결함 셀 안에서 host VBM/CBM을 **원소투영 궤도 지문**으로 찾고(`orbital_diff < 0.2`,
에너지창 0.5eV) PHS는 **그 모서리의 점유수 > 0.20**으로만 판정 → `midgap` 하드스위치·하전셀
오분류·**정렬 딜레마가 통째로 사라짐**(두 셀 고유값을 안 뺌). 선행작업=`read_procar`가 지금
`tot` 컬럼만 읽으므로 궤도별 컬럼 파싱 확장 필요.
⚠pydefect PR(지정 원자군 weight 분율)은 우리 IPR과 **다른 양**(대체재 아닌 보완재).
⚠eFNV는 3D 가정이라 슬랩 하전보정·결함 쌍극자는 여전히 미해결.

## ⏭pydefect_2d 대조 (2026-08-03, 소스 직독)
**q=0을 아예 건너뛴다** (`if defect_entry.charge == 0: return`). 보정식도 `-q·alignment`라
중성에서 0, `eigenvalue_shift`도 q 비례. → **pydefect·pydefect_2d 둘 다 중성 결함의 슬랩
쌍극자를 다루지 않는다** = 우리 미해결 항은 상류에서도 미해결(우리 실수 아님).
얻은 것: 저들의 1D FP 퍼텐셜 `-(V_def_xyavg − V_perf_xyavg)`가 **우리 z-ramp와 같은 양**.
차이는 상수로 줄이지 않고 ε(z)+가우시안 전하로 **모델링**하고 잔차만 정렬로 쓴다는 것.
⚠정렬 지점 = `z_defect − L/2` **단일 격자점**(층평균·진공plateau 아님). 자유부유 2D엔 맞지만
우리 03-pydefect_2d 셋업(L=26.26, 결함 z_frac 0.74~0.81)에선 z≈6.3~8.1Å = 원자span 6.22~20.99의
**pseudo-H 아랫면**에 떨어짐(진공 아님, 가파른 구간) → 그 런의 E_corr=−0.038 vs SCPC~1.8 불일치와
연관 가능성. **재확인 필요, 단정 아님**.
쓸모: `extrapolation_models.py` Komsa 외삽 `c0+c1x+c2x²`(1/mul), `cli/special_vacuum/`(진공 스캔).
제약: tetragonal·VASP 전용.

## ⚠2026-08-05 plot_DFE.py 버그 2건 (사용자 발견, 둘 다 수정·푸시)

**① band-filling이 `--shallow-limit no`에서 완전한 no-op이었다** (커밋 72facf3).
`curves_for_defect`가 E_bf를 **shallow-limit 가지에서만** 썼고 charged 가지는 원본 절편을
그대로 그림 → 제목만 "band-filling on"으로 바뀌고 곡선은 한 줄도 안 움직임. 04에서
Cl_As_1/Cl_As_2가 E_bf −0.54/−0.31인데 그림이 동일해서 발각됨.
**E_bf는 중성 셀 총에너지를 고치는 항이므로 작도 방식과 무관하게 q=0 절편에 붙는다** —
이제 절편 생성 지점에서 한 번만 적용하고 두 방식이 같은 보정본을 소비.
CTL도 같은 split-brain이었음(공유 플로터가 밴드필링 CSV를 읽기 전에 계산) → 보정 절편에서
`base.compute_all_ctls`로 재계산. ⚠`compute_envelope_ctl`은 **(조건,defect) 한 조**만 받는다
(전체를 넘기면 조용히 0개 반환 — 실제로 당함). 밴드필링 OFF면 공유 플로터 출력과 동일(회귀 확인).
효과: 02에서 In_As(+1/0)는 갭 밖으로 나가고, In_i_1·In_i_2는 E_bf가 **양수(MB)**라 q0가 내려가며
1.16 eV에 갭 내 전이가 새로 생김. Cl-As_In(bound, E_bf=0)은 불변.

**② shallow-limit 기울기가 +1로 하드코딩돼 있었다** (커밋 997b4bb).
완전이온화 전하는 **q0의 캐리어 수**다: `E_f(+N)=E_f(0)+N(E_F−E_g)` / `E_f(−N)=E_f(0)−N·E_F`.
N은 이미 `band_edge_states.csv`의 `N_e_CB`/`N_h_VB`에 있었는데 플롯이 무시했음.
이중도너의 VBM 형성E를 **정확히 E_g만큼** 과소평가: Cl_As_1 In-rich −1.42→**−2.67**,
02 In_As −0.59→**−1.84**. 중간 전하상태는 안 그림(shallow 극한에선 모든 전이가 같은 모서리라
+1 선이 +2 선 위에 놓여 포락선에 기여 안 함). `q_ionized` 컬럼 추가.

## Cl_As_1 E_bf=−0.54 는 맞다 (2026-08-05 재검증)
이중도너 2.000전자 × **−0.2715/개**. pure CBM +0.0949 vs 도너밴드 −0.1767(band 509, 양 스핀).
2026-07-23 검증 에이전트 2인의 두 경로 교차검증값(전자당 0.335, 정렬 후 총 0.670)과
**aligned 0.6413 → 29 meV 일치**. 기본값 unaligned는 0.5430.
⚠단 `IPR-GRAY-ZONE(1.36×)` + `ALIGN-SENSITIVE(−0.098eV)` 플래그 동반 → 인용 시 불확실도 병기.

## ⚠파일명이 설정을 담는다 — stale 파일 착각 주의
tag = `{shallow-limit|charged}_{ic|noic}_{bf|nobf}[_부분집합]`. 스위치를 바꾸면 **다른 파일**로
나가므로 옛 파일이 그대로 남는다. 두 번 착각함(2026-08-03 나, 08-05 사용자). 판별은 **그림 제목**
(`DFE (charged construction, image-charge on, band-filling off)`)으로.
