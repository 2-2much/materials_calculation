---
name: inas111-cl-ma-p4x3-tree
description: "21-111Cl-MA_4BL_p4x3_ 트리 — 셀 구성·결함 8종·q0 결과. 전자수지 excess와 E_F 이동이 완전 일치, n형 후보는 V_As_1"
metadata: 
  node_type: memory
  type: project
  originSessionId: f5c1c286-303c-4cef-b4bf-6b89adb7c5ce
  modified: 2026-08-14T02:01:38.965Z
---

2026-08-13~14, kohn `12-Surace-defect_calculation/21-111Cl-MA_4BL_p4x3_/`
(⚠ **폴더명 끝에 밑줄**. 사용자가 GitHub 에서 Defect_Package 를 따로 받아 배포한 트리다.)

## 셀
4×3 of 60° 육방 1×1 → 17.5075 × 13.1306 Å, c = 32.2699 (진공 15 Å), **4 BL**, 131 원자.
In_d 48 / As 48 / H.75 12 / Cl 9 / N 2 / C 2 / H 10. **NELECT 964 (짝수)**.
고정 = 맨 아래 1 BL(24) + pseudo-H(12) = 36. As–H = **1.5626 Å** ([[inas111_slab_generation]]).
표면 In 12개 = **Cl 9 + MA 2 + 노출 1**(LDA 선례 배치를 host In 기준 변위로 이식, 결합길이 1e-15 Å 보존).
노출 In 은 **In46**(면내 강체이동으로 In45→In46 자리로 옮김).
⚠ 60° 육방 = 비직교 → slabcc/CoFFEE 불가. ⚠ N/C PAW 때문에 **ENCUT=400**, 07/11(300) 과 혼용 금지.

## ★ 전자 수지 excess 와 E_F 이동이 8종 전부 일치한다 (독립 교차검증)

| 결함 | excess | NELECT | E_F−VBM(pure) |
|---|---|---|---|
| Cl_i (+Cl@In46) | −1 | 971 | −0.46 |
| V_In (−In46) | −3 | 951 | −0.36 |
| pure | 0 | 964 | +0.02 |
| As_In | 0 | 956 | +0.03 |
| Cl-As_In | **+1** | 963 | +0.30 |
| MA_i (+MA@In46) | 0 | 978 | +0.32 |
| V_As_2 (먼 As) | **+3** | 959 | +0.71 |
| MA-As_In | **+2** | 970 | +0.81 |
| V_As_1 (노출 In 옆 As) | **+3** | 959 | **+1.18 (CBM 위)** |

수지 계산: Cl(X-type) −1/4, MA(L-type) +3/4, 노출 In(DB 빔) +3/4, As_In 의 As–As 결합 3개 +3/2,
그 DB −3/4, As–Cl +1/4, As–N(dative) +5/4, V_As 로 드러난 In DB +3/4 each.

**★ n형 기원 후보는 V_As_1 하나로 좁혀진다** (E_F 를 CBM 위로 올리는 유일한 종). MA-As_In(+0.81)이 CBM(0.83)에 근접.
**★ As_In 은 (111)A 에서 도너가 아니다** — 남는 전자를 노출 In 의 빈 DB 가 흡수해 자체 상쇄(excess 0).
Cl 을 얹어 그 DB 를 없애야(Cl-As_In) 비로소 +1 도너가 된다. (110)/(100) 과 다른 점.
**★ μ 없이 읽히는 유일한 비교**: E(V_As_1) − E(V_As_2) = **−0.766 eV(Γ) / −0.910 eV(2×2×1)**
→ 노출 In 옆 As 공공이 먼 곳보다 0.8~0.9 eV 안정. 열역학·전자 양쪽에서 V_As_1 이 이긴다.

## ⚠ 함정 4종

1. **Γ-only 에너지 금지.** 같은 기하에서 k 만 2×2×1 로 바꾸면 ΔE(결함−pure)가 공공 3종·MA-As_In 에서
   **0.5~0.83 eV** 움직인다(V_As_2 +0.83). 종별로 오차가 달라 상쇄 안 됨. **E_f 는 02(2×2×1) 로 읽을 것.**
2. **스핀이 전부 죽는다.** 01_Spin 이 9종 모두 1스텝·mag≈0·ΔE 0.1 meV. WAVECAR 상속 버그가 아니다
   (ISTART=0, MAGMOM 정상). 원인은 **PBE 가 gap 을 거의 안 주는데 SIGMA=0.1 이 준위 간격(~0.05 eV)을
   뭉개는 것**. 홀수 NELECT 5종도 mag 0. → 스핀·gap·E_F 판정은 HSE 에서 재판정([[pbe_then_hse_workflow_plan]]).
3. **host gap 오인** → [[host_gap_localized_state_trap]]. 그냥 최저 비점유를 CBM 으로 잡으면 0.03 eV.
4. **μ 가 전부 ENCUT=300 계열**이다. μ_In/μ_As/μ_InAs/μ_Cl 모두 400 에서 새로 필요. μ_Ma(−35.660148)만 400 이라 재사용 가능.

## 도구 (트리 로컬)
`build_pure_p4x3.py` `shift_exposed_In45_to_In46.py` `verify_pure_p4x3.py` `make_defects.py`
`make_kpath.py`(검증기) `check_convergence.py` `analyze_relax.py` `analyze_bands.py` `align_and_plot.py`
`results/plot_bands_dos.py`(09 트리 plot10.py 형식 밴드+DOS 한 장)
⚠ `scripts/generate_surface_defect.py` 는 이 트리에 못 쓴다(라벨 열 요구·맨 vacancy 불가·개수 0 종 삭제·H 라벨 충돌).
⚠ 60° 셀은 frac (0.75,0) 과 (0.5,2/3) 의 데카르트 x 가 정확히 같아 **정렬 키를 반올림 안 하면 원자 번호가 뒤집힌다**.
