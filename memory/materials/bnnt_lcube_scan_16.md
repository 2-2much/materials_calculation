---
name: bnnt-lcube-scan-16
description: kohn 16-Lcube_scan_BNNT — 정육면체 셀로 3DJM 1/L 수렴 시험. 17/18 완료(09-29, n18/qp1 실행중)·analyze.py 있음. ★14 맞춤식이 16/n9 를 0.6meV 로 예측(앵커 대용)
metadata:
  type: project
---

kohn `~/materials/__JCC-reproduce__/16-Lcube_scan_BNNT` (2026-09-29 생성·사용자가 cascade2 로 제출, NCORE=NSIM=32. setup.sh 는 병렬화 키 제외 diff 로 발판 검사).

**목적:** 15(L⊥=25 고정)는 L_ax>L⊥에서 +B·L_ax 발산([[jcc_lax_axial_jcc_slower]]) → 극한 없음.
세 변을 같이 키우면 3DJM은 0D형 1/L, JCC는 host 선전하 탓에 ln L/L 꼴이 예상. TRSM은 L_vac 고정으로도 수렴하지만 3DJM은 아님(사용자 논리).

**규약:** 15/n*/VN_p1_relax/CONTCAR·15/n*/q0/POSCAR 를 읽기만, 카테시안 보존·x·y 중앙 재배치, NSW=0.
n*/{VN_p1,q0,qp1} 18잡. INCAR.sp·KPOINTS 는 15와 cmp 로 bit-identical 확인. 결합차 <1e-14 Å, 배위2 B 3개 전부 통과.

**How to apply:** n3(L=7.525)은 벽간격 2.6~3.2 Å **번들** → 맞춤 제외. 14/15와 같은 셀이 없어 0.00meV 앵커 없음.
분석은 국소 기울기 dΔH_f/d(1/L) 표 먼저(1/L 외삽 교차영역 함정). 분석 스크립트는 아직 없음.

## 잠정 결과 (2026-09-29, n18/qp1 미완 — `analyze.py` 재실행으로 갱신)
- ★교차검증: 14 의 L⊥ 맞춤식 (a + k ln L⊥ + b/L⊥²) 을 L⊥=22.575 에서 평가 → 16/n9 와 3DJM −0.6, δE₀ −0.0, JCC −0.6 meV. 발판·셀 생성 검증 완료.
- 16−15 (같은 기하, 진공만 다름): 3DJM −57~+157 meV 인데 JCC 는 n9~n15 에서 ±1~9 meV → JCC 가 진공방향 항을 지움 (n6 13, n3 번들 194).
- 3DJM 국소기울기 −11.3~−12.9 로 거의 상수, H∞+A/L 맞춤 H∞ 5.098·A −12.09 (점전하 무차폐의 0.59배), RMS 3 meV.
- ⚠미확정: δE₀ ln 계수 k=0.96 (4점·3변수), JCC H∞ 4.974 는 3DJM 과 124 meV 어긋남 — n18 들어온 뒤 판정. 해석 붙이지 말 것 ([[feedback_validate_diagnostic_first]]).
