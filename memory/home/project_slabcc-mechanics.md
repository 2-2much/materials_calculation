---
name: project_slabcc-mechanics
description: "How slabcc internally computes E_isolated (linear-fit extrapolation over scaled MODEL, not DFT) and DIEL.dat file/plot gotcha"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 9a7029c3-f8f7-43cb-b8a3-1fe6efcf7b5c
---

slabcc 내부 동작 원리 (Komsa-Pasquarello PRL 110, 095505 (2013) + SLABCC CPC 240, 101 (2019) 논문 기반, ~/papers/charged defect correction in slab/).

**보정 공식:** ΔE = E_isolated − E_periodic + q·dV. E_periodic엔 spurious image-image + charge-jellium 상호작용이 섞여 있고, E_isolated가 진짜 원하는 고립 전하 에너지.

**E_isolated는 어떻게 구하나 (std.out의 Linear fit 부분):**
- 비균질 ε(z)에선 E_isolated 해석해가 없어서 **외삽**으로 구함.
- **DFT는 딱 한 번만** 돌림. 그 뒤 slabcc가 **모델(Gaussian 전하 ρ_model + 유전체 박스 ε(z))만** 소프트웨어 내부에서 등방적으로 α=1.0/1.5/2.0배 확대(박스+ε 프로파일 전부 함께)하며 Poisson 풀어 E_periodic(α)를 값싸게 계산. **새 VASP 계산 아님.**
- E_periodic을 1/α(=1/scaling)의 함수로 fit → **1/α→0 절편 = E_isolated**. leading spurious 항이 Madelung형 ∝1/α이기 때문.
- **fit 기울기 ≈ 원래 셀에서 제거되는 spurious 주기 상호작용 그 자체** (E_per(α=1) − E_iso ≈ slope). 예: vertical run에서 slope 1.20 eV, E_per=1.79, E_iso=0.58 → 보정 −1.20 eV.
- **가장 작은 셀(α=1)은 fit에서 제외**됨 (아직 고차 1/α³ 곡률 있음, KP ref[27]: 완전형 a+b/α+c/α³). std.out에서 fit은 α=1.5,2.0 두 점만 정확 통과, RMSE≈0.
- 왜 등방 확대 필수: vacuum만/lateral만 늘리면 하전 평면/선으로 **발산**. 모든 방향 동시 확대여야 배경 희석되어 고립 극한 도달.

**ε(z) 프로파일:** DFT에서 추출 안 함. 유저 입력 diel_in(슬랩 내부, 스칼라면 등방)·diel_out(vacuum)·interfaces(계면 두 z위치=슬랩 양 표면)·diel_taper(β, erf 부드러움)로 **box(사다리꼴) 모양 재구성** (erf 전이). interfaces는 optimize_interfaces=yes면 DFT LOCPOT에 맞춰 최적화됨(초기 0.384/0.616→0.384/0.599). **vertical transition은 diel_in에 ε_∞ 써야 함** (이온 동결, 전자만 반응; InAs ε_∞≈12.3).

**slabcc_DIEL.dat 플롯 함정:** 컬럼 3개(εxx,εyy,εzz, 등방이면 셋 동일), **z좌표 컬럼 없음**(행번호=z격자). `plot u 1:2`(컬럼 vs 컬럼) 하면 y=x 직선이 나와 "linear 증가"로 착각함(NaCl 예시도 동일). **반드시 행번호 vs 컬럼**으로 그려야 함: gnuplot `u 0:1`, python `plt.plot(np.loadtxt(f)[:,0])`. 그러면 1→diel_in→1 box envelope 정상 확인됨.

관련: [[project_slabcc-correction-validity]](결과 신뢰도 판정), [[project_inas-band-alignment-method]].
