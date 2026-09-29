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

## 결과 (2026-09-29, 18/18 완료)
- ★3DJM(정육면체)은 깨끗한 1/L: H∞ **5.098 eV**, A −12.09 (ε_eff 1.69), RMS 3 meV, jackknife 5.096~5.102. lnL/L 계수 K₃=+0.18≈0 — 결함의 −κ ln L_ax 와 3DJM 의 +κ ln L⊥ 가 L⊥=L_ax 에서 상쇄된다는 예측과 일치.
- δE₀ = (−e²k lnL + C)/L + b/L³, k=0.96, b=−470 ↔ 14 의 ⟨r²⟩ 항 b·L_ax=−459 (**2.4 %**, 독립 교차검증).
- JCC 극한 = 3DJM 극한은 **항등식**(δE₀→0) — 독립 증거 아님. 자유 맞춤 H∞+A/L+K lnL/L 은 b/L³ 누락으로 133 meV 편향(L=15 에서 −138 meV). ⚠JCC 는 1D 정육면체에서 lnL/L 로 느리게 수렴 → **1D 극한 추정엔 3DJM 이 낫다** (2D 와 반대).
- 논문 Table I (단일셀 L=22.6) 4.187 은 극한 5.10 보다 ~0.9 eV 낮다 — 단, 15 이완 기하 고정·Γ-only 조건.
- 14 맞춤식 → 16/n9 0.6 meV. 16−15 JCC 차 n9~n18 에서 ±1~20 meV.
- analyze.py 주석 정정: w=0.62 는 국재도 아님(host qp1 도 0.624, PAW 구 투영비).
