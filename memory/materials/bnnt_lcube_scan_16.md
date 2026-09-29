---
name: bnnt-lcube-scan-16
description: kohn 16-Lcube_scan_BNNT — 정육면체 셀(L_x=L_y=L_z=L_ax)로 3DJM 의 1/L 수렴 시험. 15 이완기하 1shot, 18잡 입력 완비·미제출(2026-09-29)
metadata:
  type: project
---

kohn `~/materials/__JCC-reproduce__/16-Lcube_scan_BNNT` (2026-09-29 생성, **미제출** — 사용자가 직접 `./submit.sh`).

**목적:** 15(L⊥=25 고정)는 L_ax>L⊥에서 +B·L_ax 발산([[jcc_lax_axial_jcc_slower]]) → 극한 없음.
세 변을 같이 키우면 3DJM은 0D형 1/L, JCC는 host 선전하 탓에 ln L/L 꼴이 예상. TRSM은 L_vac 고정으로도 수렴하지만 3DJM은 아님(사용자 논리).

**규약:** 15/n*/VN_p1_relax/CONTCAR·15/n*/q0/POSCAR 를 읽기만, 카테시안 보존·x·y 중앙 재배치, NSW=0.
n*/{VN_p1,q0,qp1} 18잡. INCAR.sp·KPOINTS 는 15와 cmp 로 bit-identical 확인. 결합차 <1e-14 Å, 배위2 B 3개 전부 통과.

**How to apply:** n3(L=7.525)은 벽간격 2.6~3.2 Å **번들** → 맞춤 제외. 14/15와 같은 셀이 없어 0.00meV 앵커 없음.
분석은 국소 기울기 dΔH_f/d(1/L) 표 먼저(1/L 외삽 교차영역 함정). 분석 스크립트는 아직 없음.
