---
name: feedback_scpc-vasp-workflow
description: VASP SCPC 및 slabcc 실행 시 반드시 지켜야 할 설정(바이너리·REF파일·WAVECAR·tolerance)
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0854a52a-fd0a-4222-920b-a19a6f22455b
---

VASP SCPC / slabcc charged-defect correction 실행 시 필수 설정 (TGM 클러스터).

**SCPC (VASP):**
- **바이너리:** 반드시 SCPC 포함본 `/TGM/Apps/VASP/VASP_BIN/6.6.0/vasp.6.6.0.dftd4.scpc...std.x`.
  일반 6.5.1(...plugin...)은 SCPC 미포함 → "not compiled with -DSCPC" 에러.
- **REFCHG/REFPOT 필수:** neutral(q=q'=0, 같은 지오) 계산의 CHGCAR/LOCPOT을 SCPC run 폴더에
  `REFCHG`/`REFPOT`으로 symlink. 없으면 "scpc error: missing reference file for charge density"로 죽음.
- **WAVECAR:** symlink 금지(LWAVE=.T.면 원본 덮어씀). pre-converge(SCPC OFF, LWAVE=.T.) 폴더에서
  **실제 복사**해오고 `ISTART=1, ICHARG=0, LWAVE=.T.`로 restart(자체 WAVECAR 기록).
- INCAR SCPC 블록: DIEL(vertical=ε∞), QTOT, ZLOW/ZHIG=frontier 원자 ±1~1.5 Å(fractional),
  BROAD 0.5~0.8(covalent), RXCUT/RYCUT/RZCUT=0.1, MGZ~c에 비례.

**Why:** 이 세 가지(바이너리·REF·WAVECAR)를 놓쳐 vertical_scan 첫 SCPC가 연속 실패했음.

**slabcc:**
- delocalized 전하는 grid 키워도 discretization error 안 줄면 **[critical] abort → E_corr 미출력**.
- `optimize_tolerance`(기본 0.01)는 포텐셜 RMSE 수렴 기준일 뿐. **0.05로 완화하면** BOBYQA가
  더 국소적 minimum(σ 작아짐)에 안착해 valid E_corr가 나오는 경우가 있음(Cl-As_In R_q0에서 σ 4.27→2.58, 성공).
- 셀이 클수록(정렬 c=55 Å) slabcc 느림(수십 분). g2 파티션 1노드.

**How to apply:** SCPC/slabcc 재계산 시 위 체크리스트 먼저 확인. [[project_vertical-transition-correction]]
