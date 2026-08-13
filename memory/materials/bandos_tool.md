---
name: bandos_tool
description: "~/bin/bandos — Line-Mode KPOINTS 밴드 플로터. ⚠ion 인덱스가 0-based(VASP 번호 −1). zeroband는 zero-weight 전용이라 line-mode 불가"
metadata:
  type: reference
---

`~/bin/band` (= `~/bin/bandos/bandos/band.py`), `dos`, `locpot`, `band_opt`.

## zeroband 와의 분담

- **[[zeroband_fatband_tool]]** = zero-weight k점(하이브리드 밴드) 전용.
  일반 Line-Mode KPOINTS 를 주면 `ERROR: Unsupported KPOINTS coordinate mode on
  line 3: 'Line-Mode'` 로 거부한다.
- **bandos `band`** = Line-Mode 를 그대로 읽는다(2행에서 구간당 점 개수, 이후 라벨
  달린 점 쌍). ICHARG=11 로 돌린 03_Band 단계는 이쪽을 써야 한다.

## 호출

`key=value` 형식. 위치인자는 `text`(밴드번호 표시) 정도.

```
band E0=0 line="k,k" ylim="-1.7,1.0" markersize=400 \
     proj="62 66 67 tot" title="'...'" filename=/abs/path/out
```
옵션: `outcar= procar= kpoints= index= E0= line= proj= markersize= filename=
format= xlim= ylim= xticks= yticks= title= figsize= style=`
- `E0` 기본값은 OUTCAR 의 Fermi. **절대 에너지축을 쓰려면 `E0=0`.**
- `line` 은 스핀별 색 리스트(ISPIN=2 기본 `["r","b"]`).
- 출력은 `filename+"."+format`, 기본 `plot.png` (cwd).

## ⚠ ion 인덱스가 0-based

`proj="62 66 67 tot"` 는 **VASP 1-based 번호 63, 67, 68** 을 뜻한다.
확인법: 원자 N개일 때 `proj="N tot"` 를 주면 `IndexError: index N is out of
bounds for axis 1 with size N` 가 난다(83원자 셀에서 실측).
투영 문법: `"<ion들> <궤도들>"`, `+` 로 항 추가, `,` 로 채널 분리(최대 3채널 =
RGB 색혼합). 궤도 키: s py pz px dxy dyz dz2 dxz dx2-y2 tot.

## 파이썬에서 직접

```python
import sys; sys.path.insert(0,"/home/jaegwan97/bin/bandos")
from bandos.parse import ReadBasics, ReadEnergy, ReadPoints
A, EF, nspin = ReadBasics("OUTCAR")
E, O, P = ReadEnergy(slice(0,None), nspin, "PROCAR")   # (nspin,nk,nb), P:(...,nion,10)
klength, klabel, kname = ReadPoints(A, "KPOINTS")
```
`P[...,-1]` 이 이온별 tot. 밴드 폭·투영 무게를 수치로 뽑을 때 편하다.

관련: [[zeroband_fatband_tool]] [[inas110_bare_par3x2_pure_cell]]
