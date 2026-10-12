---
name: inas_bulk_scfermi_frozen_13
description: kohn 13번 벌크 DFE의 py-sc-fermi 동결(1215→300 K) 노트북 위치·입력·결과(2026-10-12). In-rich는 진성(n≈p≈4e13), As-rich만 As_In으로 n 1e15~9e16. ⚠DOS N_c 13배 과소가 1215 K E_F·결함순위를 좌우
metadata:
  type: project
---

위치: kohn `07-Bulk-defect_calculation/13-HSE06_PBE-d_at_a0=HSE06_PBE-d/__scFermi_frozen-defects__/scFermi_frozen_1215K-300K.ipynb` (+csv/svg/png). 사용자 요청으로 sham v5 노트북에서 동결 절차만 발췌한 깔끔판. 생성 스크립트 원본은 남기지 않음(노트북이 정본).
- 입력: `../results/raw_energies.csv`(TOTEN, 01_Mid-point_relax) + `../results/corrections/bulk_reference/charged_corrections.csv`, VBM 3.8067, μ_In −2.94160264 / μ_As −5.685683935 / μ_InAs −9.38616985 (ENCUT 300; 400 통일은 사용자가 나중에), ΔH −0.759. DOS = kohn `09-Bulk-electronic_structure/01-HSE06_AEXX27_PBE-d/01-dos` (primitive, 12³ tetra, VBM 3.8057, gap 0.4436, NELECT 18, V 56.70).
- 결함 6종(As_i 제외, 사용자 결정). 축퇴도 전부 1. v5 의 In_i q2/q3 임의 −0.1/−0.15 eV 보정은 버림.
- 결과(300 K): In-rich~중간 n≈p≈3–8e13(진성, 1215 K 진성캐리어 8.7e17이 결함 압도) / Δμ_As>−0.27 부터 n 1e15↑, As-rich n 8.8e16 = As_In 8.3e16. 그림은 단일 로그축(n·p 같은 자릿수라 끊긴 축 불가).
- ⚠ DOS 유효 N_c(300K)=6.4e15 vs 실험 8.7e16(13배 과소, 12³ 메시가 m*0.023 CB 바닥 못 담음 — [[inas_kane_kp_application]]). 1215 K E_F(0.538, CBM 위)를 ~0.13 eV 과대 → In-rich 주결함이 In_As(0)로 나옴. E_F≲0.43 이면 In_i_Td_As(+3)가 최저. 0 K 갭을 1215 K·300 K에 그대로 쓴 것도 같은 방향 오차. 다음 단계 제안 = CB 해석적 DOS(포물선/Kane) 교체 비교.
