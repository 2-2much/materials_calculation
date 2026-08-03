---
name: in_i_shallow_donor_cl_deactivation
description: "01/03 PBE-d 확정 결과 — In_i는 gap 준위 없는 얕은 도너(전자 1개→host CB), Cl 1개로 완전 비활성화. 단 03 In_i_2-Cl만 gap 내 점유 국소준위를 남김"
metadata: 
  node_type: memory
  type: project
  originSessionId: c112f7c9-ad4a-4a61-8428-865a9d3d4938
  modified: 2026-08-03T08:35:28.664Z
---

2026-08-03. `12-Surace-defect_calculation/{01-Cl-passv, 03-InCl3-passv_PBE-d}`,
`00_Gam-relax`(ISPIN=2, EDIFFG=-0.015) → `02_G221-DOS` → `03_Band`. 결과·그림·스크립트는
각 프로젝트 `results_In_i/`. 자리 정의는 [[in_i_surface_sites_01_03]].

## 판정 1: In_i = 얕은 도너, **gap 준위 없음**
전자 수는 예측대로 정확히 맞았다(잔여 전자 = pure 0 / In_i **1.000** / In_i-Cl **0.000**).
그 1개 전자가 어디 있는지가 핵심:

| | 분산 | IPR/균일 | w[In_i] |
|---|---|---|---|
| 도너 밴드 (01·03 전부) | **0.96~1.15 eV** | **1.6~3.2×** | **0.0008~0.0033** |
| (대조) pure CBM | — | 1.4~1.5× | — |
| (대조) 진짜 국소준위 기준 | — | ≥6× | — |

→ 분산 큰 host 전도대 밴드, In_i 무게 0.1~0.3%. **gap 안에 defect state 없음.**
[[cl_shallow_donor_no_gap_state]]의 Cl_As와 **같은 부류**: n형은 준위가 아니라 **전자 수**에서 온다.
"CBM에 donor-like surface state가 보이나?" → **안 보이는 게 정답이고 정상이다**
([[shallow_donor_inas_supercell_limit]], a_B=349 Å).

## 판정 2: Cl 1개 = 완전 비활성화
E_F 이동(VBM=0 기준): pure ≈0 → In_i **+0.81~+0.95** → In_i-Cl **−0.05~+0.01**.
`01 In_i_1-Cl`에서는 그 전자가 **국소 In–Cl 결합 상태**로 VB 안에 내려앉는 것이 직접 보인다
(IPR **7.6×**, w[In_i]=0.099, w[Cl]=0.035, E=−0.38~−0.05).
`03 In_i_1-Cl`은 Cl이 In_i를 떠나 In_L에 붙었는데도(해리) E_F가 pure와 동일(+0.008) — **전자는 가져간다.**

## ⚠ 예외: 03 `In_i_2-Cl` 은 gap 안에 점유 준위를 남긴다
E=**+0.10~+0.33 eV**(gap 0~0.372 내부), IPR **16.5×**, w[In_i]=**0.176**, 완전점유.
캐리어 0이라 **도너로선 죽었지만** 점유된 deep level → CQD에서 **트랩/재결합 중심 후보**.
n형 기여와 분리해서 평가할 것.

## 구조: 8케이스 중 표면에 제대로 앉는 건 2개뿐
- ✓ `01 In_i_2` (0.40 Å만 이동, Cl 3배위) / ✓ `03 In_i_2-Cl` (Cl 2.39 + As 2.89 앵커)
- ✗ 나머지는 In이 +1.9~2.97 Å 튕겨 **Cl층 위 무결합 adatom** (=[[in_i_2_adatom_ejection]] 재현)
- ⚠ **03의 `In_i_1`과 `In_i_2`는 최종 구조·전자구조가 완전히 동일** — 서로 다른 초기 자리가
  같은 bound state로 수렴한다. InCl₃ 표면에서 이 둘은 **구분되는 결함이 아니다**.

## 방법 함정 (재사용 시)
- **정렬**: 바닥층 z 최하위 In의 **4d semicore 가중평균**. ⚠기준 원자를 "z<12Å" 같은
  조건으로 잡으면 이완에 따라 개수가 12~17개로 흔들려 shift가 0.06 eV씩 튄다. **고정 개수**로 뽑을 것.
  그리고 shift는 **단계마다 따로** 구해야 한다(02_G221-DOS와 03_Band는 별개 계산).
- **PROCAR 파싱**: `k-point` 줄에 **선행 공백**이 있어 `startswith('k-point')`가 실패한다. strip 필수.
  대용량이라 순수 파이썬은 느림 → `awk 'NF==11 && $1~/^[0-9]+$/ {print $11}'` 로 tot 열만 뽑아 reshape.
- **03_Band의 밴드별 점유수를 전자 수로 읽지 말 것** — zero-weight 경로점이 섞여 합이 1을 넘는다.
  전자 수는 반드시 `02_G221-DOS`(tetrahedron) 쪽에서 셀 것.
- **STOPCAR(LSTOP) 함정**: stage 00이 "General timing"으로 정상 종료되면 run_case.sh가
  **곧바로 다음 stage로 진행해 미수렴 기하 위에서 DOS를 계산**한다. 중단 직후 scancel 필요.
- **힘 수렴 확인은 자유 원자만**: Selective Dynamics로 고정된 바닥층·pseudo-H는 힘이 0.29 eV/Å라도
  정상이다. 전체 최대힘으로 "미수렴" 판정하면 오독한다.

관련: [[cqd_ntype_origin_goal]] [[pbe_then_hse_workflow_plan]] [[bandfilling_measured_from_dos]]
