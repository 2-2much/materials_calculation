---
name: host-gap-localized-state-trap
description: "슬랩 host gap 을 '최저 비점유'로 잡으면 안 된다 — 표면 국소 준위를 CBM 으로 오인한다. PROCAR 단일원자 무게로 걸러낼 것"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f5c1c286-303c-4cef-b4bf-6b89adb7c5ce
  modified: 2026-08-14T02:01:59.967Z
---

2026-08-14, 21-111Cl-MA 트리에서 실측. **pure 의 host gap 이 0.034 eV 로 나와서** 09 트리 (100)
acetate 의 0.76 eV 와 20배 차이가 났다. 원인은 계산이 아니라 **gap 정의**였다.

02_G221-DOS 의 PROCAR 로 밴드별 **최대 단일원자 무게**를 재니:

| pure 의 빈 밴드 | E − VBM | 최대 단일원자 무게 | 정체 |
|---|---|---|---|
| 483 | +0.034 | **10.8 % @ In46** (균일값 0.76 % 의 **14배**) | 노출 In 의 **빈 dangling bond** |
| 484 | +0.826 | 1.9 % | 진짜 host CBM |

즉 0.034 eV 는 gap 이 아니라 **VBM → 표면 국소 준위** 간격이었다. 비국소 상태만으로 다시 잡으면
**host gap = 0.826 eV** 로 09 트리 값과 같은 수준이 된다.

**Why**: 결함/표면 계산에서 host 밴드 가장자리는 "pure 의 최고 점유 / 최저 비점유"가 아니라
**pure 의 비국소(연장) 상태**로 정의해야 한다. pure 셀 자체가 표면 국소 준위를 갖는 경우
(여기서는 리간드가 안 붙은 노출 In) 그 준위가 gap 안에 앉아 CBM 행세를 한다.
이걸 놓치면 gap 이 0 에 가깝게 보이고, 그 위에 세운 CTL·E_F 판정이 전부 무너진다.

**How to apply**:
```python
import sys; sys.path.insert(0, "/home/jaegwan97/bin/bandos")
from bandos.parse import ReadBasics, ReadEnergy
A, EF, ns = ReadBasics("OUTCAR"); E, O, P = ReadEnergy(slice(0,None), ns, "PROCAR")
w = P[0,:,:,:,-1].mean(axis=0); w /= w.sum(axis=1, keepdims=True)   # (nb, nion)
LOCAL = set(np.where(w.max(axis=1) > 0.05)[0])      # 단일원자 무게 > 5 % = 국소
```
문턱 5 % 는 131 원자 셀에서 균일값(0.76 %)의 6.5배 — 국소 준위(10.8 %)와 host 밴드(≤2.5 %)가
확실히 갈린다. 원자 수가 크게 다르면 "균일값의 5~7배"로 환산해서 쓸 것.
IPR 만으로는 안 갈린다(이 셀은 가전자 밴드도 IPR 비가 2~3 이라 문턱을 못 세운다).

관련: [[inas111_cl_ma_p4x3_tree]] [[ipr_gate_tool]] [[cl_shallow_donor_no_gap_state]]
