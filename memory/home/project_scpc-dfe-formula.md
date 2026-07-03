---
name: scpc-dfe-formula
description: "SCPC correction 적용 시 DFE 공식 — pure cell VBM 사용, SCPC PA는 charged↔neutral만 포함"
metadata: 
  node_type: memory
  type: project
  originSessionId: 502cfb29-f0a7-42a5-acc6-ff69729e9d16
---

SCPC (Self-Consistent Potential Correction) 적용 시 DFE 공식:

E_f[X^q] = E_DFT[X^q] - E[pure] + Σn_iμ_i + q(ε_VBM^pure + E_F) + ΔE_SCPC + q·ΔV_SCPC

- ε_VBM: **pure cell** VBM 사용 (neutral defect cell이 아님)
- ΔE_SCPC: SCPC energy correction (SCPCOUT의 `Energy Correction`)
- ΔV_SCPC: **band-reference** potential alignment — 하전 결함 far-field 포텐셜을 pristine bulk VBM 기준에 맞추는 항(Freysoldt식, charged↔neutral/pure defect 간). E_F를 올바른 band edge scale에 놓기 위한 것.
- neutral defect은 순전하 없으므로 ΔV(neutral↔pure)는 수 meV 이하로 일반적으로 무시 가능

**⚠️ 정정/명확화 (2026-07-03, scpc.F rev7 소스 추적):**
- **전기적 finite-size 정렬은 이미 ΔE_SCPC에 포함**됨. scpc.F line 1037: 출력 `Energy Correction = ecor1 − ealig`, 여기서 `ealig = ½·q·ΔV_ref`(vref_alignment, `rpot−vhar` 경계면 평균)가 **이미 차감**되어 나옴. V(G=0)=0 3D 쿨롱 커널 offset 보정이 여기 들어있음.
- **SCPCOUT에 따로 찍히는 `Potential Alignment (x,y,z)` (예 −0.048 eV)는 별개 진단량** — `scpc_potalignment`(line 1316)의 `mpot−vper`(system vs periodic model) 경계차, ealig와 공식이 다름. **이 값을 형성에너지에 추가로 더하면 전기적 정렬 이중계산(~48 meV 과보정).** 절대 ΔV_SCPC 자리에 넣지 말 것.
- 따라서 ΔV_SCPC(band-reference)는 SCPC 출력이 아니라 **defect vs pristine far-field offset**으로 별도 계산해야 함.
- 검증: TOTEN(보정전)+ΔE_SCPC가 진공 수렴(40→50Å 16meV)하고 slabcc E_corr(공식 `E_iso−E_per−q·dV`, 정렬 내장)과 6 meV 일치 → 두 코드 같은 정렬 규약. [[project_vertical-transition-correction]]

**Why:** SCPC에서 neutral defect cell은 전하 보정의 기준점이지, VBM 기준이 아님. E_F는 물질 고유 band edge로부터 측정하므로 pristine host VBM이 올바른 기준.

**How to apply:** DFE 계산 시 pure slab의 VBM을 [[inas-band-alignment-method]] bulk-PBAND 방식으로 결정. **ΔE_SCPC(=SCPCOUT Energy Correction)만 더하고, SCPCOUT의 Potential Alignment는 진단용으로만 볼 것.** band-reference ΔV_SCPC는 별도 산출.
