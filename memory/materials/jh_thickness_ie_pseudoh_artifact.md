---
name: jh_thickness_ie_pseudoh_artifact
description: JH 두께스캔 (100)/(110)/(111) IE 0.5eV 차이는 물리가 아니라 (100)의 pseudo-H 미이완 아티팩트. 검증계산으로 확정
metadata:
  type: project
---

`33-inAs/02-LDA/slab/slab_JH_2023.10_thickness/JH-slab-thickness-cal` (LDA-PAW 기하 + HSE06 AEXX=0.3 one-shot, 2026-08-18 점검).

**보고된 IE**: (100) 5.30 / (110) 5.82 / (111) 5.79 eV.
→ (100)만 0.5 eV 낮은 것은 **표면 쌍극자 항 하나**에서 나옴.
IE = (V_vac−V_center) − (E_VBM−V_center) 분해 결과 벌크항은 100/110 모두 2.75 eV로 일치,
ΔV_surf만 8.06 / 8.57 / 8.66 으로 갈림.

**원인 = pseudo-H 미이완**. 제출 스크립트에서 확인:
- (100) `hfix.sh`: `passv_1.5A/POSCAR_*` 를 이완 없이 그대로 HSE. In–H = As–H = **1.500 Å 하드코딩**, 층간거리 전부 정확히 a0/4 (표면 이완 0).
- (110) `reconstruction.sh`: LDA relax (In 전부 고정 / As+H 자유) → In–H 1.774, As–H 1.561
- (111) `Ps_H_nfix.sh`: LDA relax (**H 2개만 자유**, 나머지 48개 고정) → In–H 1.771, As–H 1.558

**검증 계산** (`_verify_Hpos_2026-08-18/`, LDA 4-layer, job 54797):
- (100) H만 이완 (In–H 1.500→1.731): IE 4.594 → 5.367, **ΔIE = +0.77 eV**
- (110) H를 1.500 Å로 압축(역방향): IE 4.934 → 4.414, **ΔIE = −0.52 eV**
→ 역방향 테스트의 −0.52 eV가 관측된 (100)−(110) 격차 −0.52 eV와 정확히 일치.
**(100)을 같은 프로토콜로 이완하면 IE는 5.8~6.1 eV 대로 올라감. 5.30 eV 인용 금지.**

**부수 발견**
- `BandOffset.sh`가 `awk 'NR==55'`로 행번호 하드코딩 → 111은 POSCAR에 중복 원소명이 없어
  vaspkit Warning 2줄이 안 찍히고 행이 밀림 → **111/bandOffset.txt 의 진공준위·IE·EA가 통째로 깨져 있었음**.
  키워드 파싱판 `collect_bandOffset.py` 작성, 각 폴더에 `bandOffset_fixed.txt` 생성.
- 쌍극자 보정 전무(IDIPOL/LDIPOL 없음)인데 (100)·(111)은 In면/As면 비대칭 슬랩.
  슬랩 내부 잔류 전위차 (100) 0.12 eV / (111) 0.01 eV / (110) 0 (대칭). 극성 대재앙은 없음(전자수 세기 OK).
- 진공 8.27 / 7.08~**9.30**(110은 층마다 다름) / 6.67 Å. 셋 다 평탄역 미도달(최대점 ±1 Å에서 ~50 meV 하강).
- "1 layer" 정의가 6.06 / 8.57 / 10.49 Å로 달라 **Egap 두께의존성은 면끼리 비교 불가**.
- k 3×3×1 공통이나 셀이 달라 Δk = 0.489/0.489, 0.489/0.346, 0.565/0.565 Å⁻¹.

관련: [[inas100_ligand_site_vs_electron]] [[inas100_8ml_thickness_verdict]] [[pseudoh_lasph_footing]] (기하 재사용 시 footing 주의)
