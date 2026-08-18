---
name: feedback_figure_extract_white_bg
description: 논문 docx/PDF에서 그림 추출 시 투명 배경(P/RGBA)을 흰 배경으로 합성해야 축·라벨이 사라지지 않는다
metadata:
  type: feedback
---

논문 Supplementary(.docx)나 PDF에서 그림을 뽑아 `lecture_assets/`에 넣을 때는
**반드시 투명 배경 여부를 확인하고 흰 배경에 합성**한 뒤 저장한다.

```python
im = Image.open(src).convert('RGBA')
bg = Image.new('RGBA', im.size, (255,255,255,255))
Image.alpha_composite(bg, im).convert('RGB').save(dst, optimize=True)
```

**Why:** Origin/Excel로 그린 논문 그래프는 축·눈금·축라벨이 **검은색**이고 배경이 **투명**인 경우가 많다.
그냥 `.convert('RGB')` 하면 투명이 **검정**으로 flatten되어 "검은 배경 위 검은 글씨"가 되고,
컬러 데이터 점만 남아 그림 전체가 새까맣게 보인다. (2026-08-18 Kim et al. SI Fig S3/S4/S5/S6/S10에서 실제 발생)

**How to apply:** docx는 `unzip`으로 `word/media/image*.png`가 원본. `im.mode`가 `P`(+`transparency`)나 `RGBA`면 위 합성을 적용.
추출 후에는 Read 툴로 이미지를 직접 눈으로 확인하고 렉노에 넣는다. [[feedback_interactive_lecture_notes]]
