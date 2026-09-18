---
name: trsm_1d_nanotube_literature
description: "TRSM/JCC 의 1D 적용 문헌 전수조사 — 발표된 것은 Zhang2023 의 (3,3) BNNT 단 하나. CNT 는 전무. 1D 가능 보정 스킴은 3개뿐이고 나노튜브 적용은 0"
metadata:
  type: reference
---

2026-09-18. 워크플로 37 에이전트(오류 0, 3.2M 토큰). 6 검색각도 → 26편 원문검증 → 3렌즈 반증.
질문: "TRSM(Xiao PRB 101, 165306 (2020)) 으로 나노튜브 등 1D 하전결함을 계산한 논문이 있는가"

## ★답: 정확히 한 편 — 우리가 재현 중인 JCC 논문 자체
**Zhang et al., PRB 108, 245305 (2023)** 가 (3,3) BNNT (Lx=Ly=25 Å, alatt=9) 에 TRSM·JCC 를 나란히 돌린다.
Table I (Appendix D, eV): C_B¹⁺ 1.590(JCC)/1.561(TRSM) · C_N¹⁻ 5.101/5.098 · V_N¹⁺ 4.187/4.159. 전체 RMSE 0.017.
Table II δE₀: q=+1 −0.434, q=−1 −0.458. §V: "success of the JCC method in (3,3) BN nanotube has also
proved its applicability in 1D systems." Fig.4(a) 의 hollow squares 가 이 튜브.
(표 열 배정은 PDF 7쪽을 PNG 렌더해 육안 확인 — pdftotext 가 2단 표를 뒤섞는다.)

## 음성 확인 4경로
- TRSM 원논문에 1D **없음**: bulk Si/c-BN/ZnO/MoS₂ + 단층 BN + GaAs 양자점. nanowire 는 향후과제 문장 2회
- TRSM 인용 전수(OpenAlex 46 + S2 28) 1D 0건 / JCC 인용 전수(OpenAlex 6) 1D 0건
- `"transfer to real state"` 전문검색 전 세계 **5건**뿐
- Scholar 전문 동시출현(제목구 AND nanotube/nanowire) 5~8건, 실제 1D 계산은 위 BNNT 하나
★**CNT 는 어떤 1D 보정을 쓴 하전결함 계산도 발표된 적 없다.**

## 1D 가능 보정 스킴 = 3개 (나노튜브 적용은 전부 0)
| 스킴 | ref | 나노튜브 |
|---|---|---|
| CoFFEE | Naik & Jain, CPC 226, 114 (2018) | ⚠ `construct_wire()` 가 **속 찬 단면**만 만든다 → 튜브 벽(환형)은 커스텀 ε(x,y) 필요. 논문에 nanotube 0회 |
| Kim·Chang·Park | PRB 90, 085435 (2014), arXiv:1402.5733 | 목적설계 1D FNV(비등방 유전텐서). 인용 10건 전수확인, 0건 |
| Rozzi exact Coulomb cutoff | PRB 73, 205119 (2006) | 젤리움이 아예 없는 유일한 길. 결함 응용 미발표 |
구조적으로 불가: Makov-Payne, FNV/sxdefectalign, Kumagai-Oba/pydefect, Komsa-Pasquarello, NK,
sxdefectalign2d, slabcc, pydefect_2d, SEJM(진공축 하나 가정 — 튜브는 진공축이 둘이라 스케일링 재유도 필요).
SCPC(PRL 126, 076401)는 "wires(1D)"를 주장하나 wire 계산 0건이고 VASP 구현은 ZLOW/ZHIG 슬랩만 노출.

## ★TRSM 의 쌍둥이 — CCJM
Zhu, Gong, Yang, **PRB 102, 035202 (2020)**, arXiv:2001.03895. 젤리움 배경밀도를 밴드끝 밀도로 바꾸는
같은 논리를 거의 동시에 독립 제안(자기일관 기하이완 포함). 동기에 nanotube 를 적지만 계산은 전부 2D.
→ 1D 를 쓰면 TRSM 과 나란히 인용할 논문.

## How to apply
- **우리 프로젝트는 재현이 아니라 신규 영역**이다. 고정점은 위 5개 숫자뿐 —
  논문에 튜브의 **진공(Lx=Ly) 수렴 스캔도, 축방향 L_S 외삽도, ε 값도 없다**(Fig.4(a)는 parity plot,
  4(b) 무한외삽은 BN 단층 Si_N¹⁻ 전용).
- 우리 `12-TableII_materials/BNNT33` 은 δE₀ 만 재현(−0.487/−0.459). **Table I 형성에너지 3개는 미계산** —
  결함셀을 넣으면 1D 에서 JCC↔TRSM 일치(3/29/28 meV)를 독립 검증할 수 있다. 자연스러운 다음 단계.
- 튜브는 진공축이 **둘**이고 원자당 진공부피가 커서 [[jcc_acceptor_vacuum_ghost_state]] 의
  **|δE₀| ≳ EA 판정식이 가장 세게 물릴 곳**이다. C_N¹⁻ 이 그 시험대.
- 공개 구현 없음: GitHub 인증 코드검색 `IN.RHO_ADD` 전 세계 0건, `"jellium charge correction"` 0건.
- ⚠미개척 경로(결론 뒤집을 확률 낮으나 남아 있음): **CNKI 학위논문**(Deng Hui-Xiong 지도 — 1D 확장이 있을
  1순위 후보), **APS March Meeting 초록**(Scholar 에서 BAPS 초록 1건 확인됨), ChinaXiv, 출판사 자체 전문검색.
- ⚠스윕이 놓친 TRSM 응용 1건: Shen·Zhang·Qiu·Deng et al., **APL (2022)** 2D Ga₂O₃. abstract 수준 열거의 한계.
- 미확인 BNNT 선행연구(중성 baseline): Schmidt et al. **PRB 67, 113407 (2003)**,
  Piquini et al. **Nanotechnology 16, 827 (2005)** — 하전상태 포함 여부 미확인.

관련: [[jcc_tableII_reproduction]], [[jcc_acceptor_vacuum_ghost_state]], [[coffee_setup_and_arange_bug]],
[[jcc_coffee_correction_tree]]
