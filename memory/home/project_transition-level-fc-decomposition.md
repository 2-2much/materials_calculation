---
name: project_transition-level-fc-decomposition
description: Franck-Condon decomposition to get thermodynamic charge transition level when relaxation contaminates slabcc correction
metadata: 
  node_type: memory
  type: project
  originSessionId: 1297c17b-084f-48f0-af37-849b065aa6b4
---

Relaxed 결함의 열역학 전이레벨을 구할 때, q0와 q+1이 **서로 다른 구조로 relax**되면 (예: Cl-As_In, max 이온변위 0.22Å) 그 차이전하를 slabcc에 넣으면 안 된다 — DZPOT vs MZPOT가 안 맞고(POT nRMSE 0.06–0.08, corr 0.97) correction이 수렴 안 함. 대신 **Franck–Condon(configuration-coordinate) 분해**로 우회한다. 배경/판정기준은 [[project_slabcc-correction-validity]].

기호: E(q, R) = charge state q, geometry R의 DFT total energy.

**3단계 스킴 (exact identity, 근사 아님):**

1. **광학(vertical) 전이 — 동일 구조 R_q0에만 보정 적용, ε_∞ 사용**
   `E_ion^vert = [E(+1,R_q0) + E_corr] − E(0,R_q0)` → CBM 기준 ε_opt(0|+1).
   E_corr은 frozen vertical slabcc(동일 구조라 깨끗한 monopole, diel_in=ε_∞=12.3, 검증·수렴 완료)에서 가져옴.

2. **완화 에너지 — 보정 불필요**
   `E_rel(+1) = E(+1,R_q0) − E(+1,R_q+1) ≥ 0`.
   **q=+1 고정, geometry만 R_q0→R_q+1.** 실무: +1 SCF 두 번 — (a) 원자를 R_q0에 고정(NSW=0/IBRION=-1)한 +1 single-point, (b) 기존 +1 fully-relaxed(R_q+1). 둘의 차. 같은 charge라 image 에너지 상쇄 → correction 불필요.

3. **열역학(adiabatic) 전이레벨**
   `ε_therm(0|+1) = ε_opt(0|+1) − E_rel(+1)` (열역학 레벨이 광학보다 E_rel만큼 CBM에서 더 깊음).
   전개하면 `ε_therm = E(0,R_q0) − [E(+1,R_q+1)+E_corr] − E_VBM` = 표준 adiabatic 공식과 일치.

**핵심 이점:**
- 보정은 오직 vertical(동일구조) 부분에만 들어감 → relaxed-vs-relaxed slabcc 불필요(폐기).
- 유전율 정합: vertical 보정엔 **ε_∞=12.3** (전자 스크리닝만) 사용이 옳음. 이온 스크리닝은 유전율이 아니라 명시적 E_rel로 들어와 이중계산 없음. (ε_0=15.15의 이온성분 = 명시적 relaxation)

**주의:** 전자 저장소 기준(CBM) 일관, E_VBM/E_CBM은 [[project_inas-band-alignment-method]]의 bulk-PBAND alignment 사용, E_corr 부호 혼동 금지. E_rel 짝맞춤 — absorption(R_q0 vertical)엔 +1의 완화 E_rel(+1)와 짝, emission(R_q+1)과 섞지 말 것.
