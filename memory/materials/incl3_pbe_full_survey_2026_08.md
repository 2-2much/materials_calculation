---
name: incl3_pbe_full_survey_2026_08
description: "bloch 03-InCl3-passv PBE-d 전수 스윕(중성 11 + 하전 13) 완료 — 하전 판정 3축 표, 무보정 CTL 전량, HSE와 갈린 V_As/In_As_1"
metadata:
  node_type: memory
  type: project
---

2026-08-25~26, **bloch** `12-Surace-defect_calculation/03-InCl3-passv_6L_4x2x1_PBE-d`.
4단계 체인(00 Gam-relax → 01 Spin-gam-relax → 02 G221-DOS → 03 Band) 신설 후 전수 계산.
중성 11건(33 스테이지) + 하전 13건(26 스테이지) **전부 정상 종료, NELM 소진 0건**.

## 기준값 (pure, 02_G221-DOS, Γ 2×2×1 tetrahedron)
`VBM = −0.9598 / CBM = −0.5878 / **gap = 0.3720 eV**`, 1/IPR: **VBM 47.9 · CBM 75.3**, CBM 분산 1.096 eV.
⚠IPR 기준자는 **에너지를 뽑는 것과 같은 스테이지의 pure**를 써야 한다(Γ-only 02 값과 다르다).

## 하전 판정 3축 (BZ적분 점유수 / 1-IPR / 분산)
| 결함 | NELECT | 캐리어 | 성격 | q |
|---|---|---|---|---|
| As_In | 1008 짝 | 0 | HOMO 1.01× · LUMO 분산 0.850 | **0** |
| Cl-As_In | 1015 홀 | 홀 1 | 1.17/1.31× · 0.16/0.31 | 0, −1 |
| V_In | 1003 홀 | 홀 1 | 1.09/1.20× · 0.20/0.31 | 0, −1 |
| Cl_i-As | 1023 홀 | 전자 1 | 1.13× CBM · **0.997** | 0, +1 |
| In_i_2 | 1029 홀 | 전자 1 | 0.89× CBM · **1.004** | 0, +1 |
| Cl_As_1 / Cl_As_2 | 1018 짝 | 전자 2 | b509 분산 0.888 / 0.859 | 0, +1, +2 |
| In_As_1 | 1024 짝 | **0** | HOMO **2.46× 국소**, LUMO host CB | 0, +1 |
| In_As_2 | 1024 짝 | **0** | b512 **2.79× 채움** + b513 **4.03× 빔** | 0, +1, −1 |
| V_As | 1011 홀 | 전자 1 | **1.45× · 0.362**(CB 아님) + b507 2.47× 빔 | 0, +1, (−1) |

⚠**"잔여=0 → q0만"은 틀린 지름길이다.** `In_As_1`·`In_As_2`는 캐리어 0의 닫힌껍질인데도
밴드 가장자리에서 갈라져 나온 국소 준위를 갖는다. 판정은 **캐리어 수 + 국소 준위** 둘 다 봐야 한다.
`As_In`만이 진짜로 gap 안에 아무것도 없다.

## 무보정 CTL (02_G221-DOS 총에너지, VBM 기준, gap 0.372)
```
Cl-As_In  e(0/-1) = -0.064            V_In     e(0/-1) = -0.043     <- VBM 아래(얕은 억셉터)
Cl_i-As   e(+1/0) = +0.497            In_i_2   e(+1/0) = +0.665     <- CBM 위(공명 도너)
In_As_1   e(+1/0) = -0.075                                          <- gap 밖 ⚠HSE는 +0.166
In_As_2   e(+1/0) = +0.007 , e(0/-1) = +0.225   U=+0.218   <- 둘 다 gap 안(유일)
Cl_As_1   e(+2/+1)= +0.132 , e(+1/0) = +0.830   U=+0.697
Cl_As_2   e(+2/+1)= +0.233 , e(+1/0) = +0.869   U=+0.636
V_As      e(+1/0) = +0.237 , e(0/-1) = +0.848   U=+0.611
```
**gap 내부 CTL 보유**: `In_As_2`(2개), `Cl_As_1`·`Cl_As_2`·`V_As`(각 1개). 나머지는 band-edge에
못박힌 얕은 결함 → shallow-limit 작도 대상([[shallow_limit_dfe_construction]]).

## ⚠ HSE(04)와 갈린 두 건 — 재판정 대상
- **`V_As`**: 04는 "CB 전자 1개 → 0,+1"(얕은 도너). PBE는 **깊은 도너**다 — 분산 0.362 eV는
  host CB(1.096)의 1/3이고, ε(+1/0)=**+0.237**로 CBM보다 135 meV **아래**다. 전자구조와
  총에너지가 독립적으로 같은 결론. (0/−1)=+0.848은 CBM 위라 양쪽성은 아니다.
- **`In_As_1`**: PBE ε(+1/0)=−0.075(gap 밖) vs HSE +0.166(gap 안). 0.24 eV 차이로 안팎이 갈린다.
  HSE가 홀을 더 국소화시키는 방향. 보정은 ε(+1/0)을 더 내리므로 PBE에선 보정 후에도 밖.

## ⚠ negative-U 판정의 부등호 방향 (내가 한 번 틀렸다)
E_F가 커지면 안정 전하가 **낮아**진다. 그래서 전하 사다리를 **q 내림차순**(= E_F 작은 쪽부터)으로
늘어놓고 `(+2/+1) → (+1/0) → (0/−1)` 수열이 **증가**해야 정상(positive-U)이다.
(+1/0)과 (+2/+1)을 단순 대소 비교하면 도너에서 **부호가 뒤집힌다** — `Cl_As_1`을 negative-U로
오판했다가 정정했다. 이 세트는 **전부 positive-U**다.

## 다음 단계
무보정 값이므로 (1) 깊은 것(In_As_2·Cl_As_*·V_As)은 slabcc image-charge 보정,
(2) 얕은 q0는 band-filling 보정 + shallow-limit 작도 → DFE. 얕은 것에 model-charge 보정을
씌우는 것은 범주 오류([[slabcc_delocalized_defect_policy]]).

관련: [[charge_state_selection_rule]] [[incl3_cl_as_in_unbound]] [[pbe_then_hse_workflow_plan]]
[[stages_yaml_dos_band_contamination]] [[server_fs_git_sync_scope]]
