---
name: inas110_bare_surface_state_gap
description: "⚠bare (110)의 0.450 eV '갭'은 host 갭이 아니라 표면 As DB → 표면 In DB. frontier 양쪽 다 표면 상태 → band-filling 보정이 범주오류"
metadata:
  type: project
---

2026-08-18, `11-110bare_6L_par3x2_PBE-d` pure 셀 실측.
[[host_gap_localized_state_trap]] 의 진단법(PROCAR 밴드별 **최대 단일원자 무게**)을
적용하니 이 트리에도 그대로 걸렸다.

## ★ frontier 양쪽이 전부 표면 상태다

84 ion 셀이라 균일 단일원자 무게는 1.19 %.

| band | E−VBM | occ | 최대 단일원자 무게 | 정체 |
|---|---|---|---|---|
| 330 | **0.000 (VBM)** | 1 | 6.8 % @A69 (**5.7×**) | **최상층(L6) As lone pair** |
| 331 | **+0.450 (CBM 이라 부르던 것)** | 0 | 11.3 % @A36 (**9.5×**) | **최상층(L6) In dangling bond** |
| 332 | +1.103 | 0 | 11.3 % @A33 (9.5×) | 역시 L6 In |
| 333 | +1.184 | 0 | 6.7 % @A19 (5.6×) | L4 In, 여기서부터 bulk 성격 |

⚠ **그러니 내가 이 트리 내내 "E_g = 0.450 eV, pure VBM/CBM" 이라 부른 것은 host 갭이
아니라 "표면 As DB → 표면 In DB" 간격이다.** 기하 문제가 아니다 — production pure 는
제대로 재버클링했다(dz(As−In)=+0.755, p1x1 참조 0.753과 일치).

## 왜 이게 당연하고, 그래서 뭐가 달라지나

**bare 표면에는 깨끗한 host 갭이 없다.** 이완된 (110)은 채워진 As DB 를 VBM 근처에,
빈 In DB 를 그 위에 남기고, 6층 슬랩에서는 양자구속이 bulk 밴드를 밀어올려 두 표면
상태가 구속갭 안/근처에 앉는다. 01/03/07/08/09 처럼 **리간드로 DB 를 없앤 트리와는
frontier 의 성격 자체가 다르다** — 거기서는 frontier 가 host 성격이라 같은 도구가 통했다.

바뀌는 것:
1. **band-filling(PHS/MB) 보정이 범주오류**다. `E_CBM_pure` 로 표면 In DB 밴드를
   쓰므로 "CB 에 전자 N_e 개"는 실제로는 "표면 In DB 밴드에 N_e 개"다. 이 트리의
   band-filling 값(Cl_As +0.386, In_i2 +0.217, Cl_i2 +0.170, Cl_i1 +0.138,
   In_i1 +0.034, V_In −0.111)은 **인용하면 안 된다**. [[bandfill_correction_stage]]
2. "CBM 위 전자" 로 분류한 얕은 도너들(Cl_As, In_i1/2, Cl_i2)은 **표면 In DB 밴드를
   채우고 있는 것**이지 전도대가 아니다. 얕은/깊은 분류 자체를 다시 봐야 한다.
3. CTL 값은 표면상태 갭 기준으로는 여전히 의미가 있다(E_F 가 실제로 그 사이에 pin
   되므로). 다만 **bulk CBM 기준이 아니다**.
4. ★ 프로젝트 목표([[cqd_ntype_origin_goal]]) 관점에서는 오히려 결정적일 수 있다 —
   표면 In DB 밴드가 bulk CBM 아래에 있으면 **bare 표면 자체가 E_F 를 pin** 한다.
   n형 기원이 리간드/결함이라는 논지의 대조군이 된다.

## 진단 스니펫

```python
import sys; sys.path.insert(0,"/home/jaegwan97/bin/bandos")
from bandos.parse import ReadBasics, ReadEnergy
A,EF,ns = ReadBasics("OUTCAR"); E,O,P = ReadEnergy(slice(0,None), ns, "PROCAR")
w = P[0,:,b,:,-1]; frac = w/w.sum(axis=1)[:,None]
frac.max()          # / (1/nion) 이 5배 넘으면 표면 국소
```
02_G221-DOS 에서 볼 것(03_Band 는 E_F 가 무의미해 점유 판정이 안 된다).

관련: [[host_gap_localized_state_trap]] [[inas110_bare_par3x2_pure_cell]]
[[inas110_bare_q0_charged_dfe]] [[shallow_donor_inas_supercell_limit]]
