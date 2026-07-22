---
name: ipr_gate_occdiff_probe
description: ipr_gate.py probe 규칙을 HOMO/LUMO → q0 대비 점유차분(docc)으로 교체(2026-07-22). |q|>1은 가장 약한 carrier로 판정. In_As_1 q+1과 Cl-As_In q+2 판정 뒤집힘
metadata: 
  node_type: memory
  type: project
  originSessionId: 640e3ab2-68c1-49e1-b49b-8fbed2a39915
  modified: 2026-07-22T06:15:05.767Z
---

2026-07-22 `scripts/ipr_gate.py` 3번째 함정 수정. 앞선 2건은 [[ipr_gate_tool]].

## 무엇이 틀렸나
구 규칙 `q>0 → LUMO, q≤0 → HOMO`는 **"전자를 뺀 준위가 곧 LUMO"라는 가정**인데, 비워진 준위가 어떤 host 전도상태보다 **아래** 있으면 깨진다 — 가전자대 유래 deep level이 정확히 그 경우.
`In_As_1 q+1`(04): 실제로 전자를 잃은 건 **b512**(2.00→1.02e, 2.17×)인데 게이트는 **b513**(host CBM, 1.03×)을 집어 shallow로 오판하고 자기 E_relax축(0.112=bound)과 CONFLICT를 냈다. **버그였지 경계 물리가 아니었다.**

## 새 규칙
1. **probe = |occ(q) − occ(q0)| 최대 밴드.** 입자수 보존으로 Σ|docc|=|q|라 어디 있든 찾아낸다.
2. **|q|>1은 가장 약한 carrier로 판정.** |docc|≥0.5인 밴드를 전부 모아 **가장 덜 국소화된 것**을 probe(model-charge 보정은 전하 *전부*가 국소화돼야 성립). 상수 `CARRIER_MIN_DOCC=0.5`.
3. capture < 0.8|q| → `PROBE-SPREAD` 플래그(전하가 정의 가능한 준위에 안 앉음 = 그 자체가 비국소 신호).
4. ⚠**NBANDS가 전하상태마다 다름**(02는 720/400 혼재) → 공통 prefix로 비교(둘 다 밴드1부터 에너지순). shape 일치 요구하면 전부 fallback으로 떨어진다.
5. q0 없으면 구 규칙 fallback + `NO-q0-REF` 표시.

## 판정 변화
- **04 `In_As_1 q+1`: shallow → bound(deep)** (b513→b512, 1.03×→2.17×), CONFLICT 소멸. 스핀 분해 증거와 일치.
- **02 `Cl-As_In q+2`: bound → 미결**(shallow/bound CONFLICT + EDGE-AMBIGUOUS). carrier 2개인데 **b372=4.29×(bound) + b371=1.34×(host VB)** — 결함준위는 전자 1개만 갖고 두번째는 VB에서 빼는 구조라 **진짜 이중이온화 국소상태가 아니다**. ⚠**이 상태에 이미 E_corr 적용돼 있음**(01-spin-gam 0.294991 / 00-gam-relax 0.375853, 둘 다 rmse_warning) → **재검토 필요**.
- probe 밴드만 바뀌고 판정 불변: 02 `As_In q+1`, `In_As q+1`, `V_Cl-V_As q+1` 3건.

## 부수 수정 & 검증
- `DEFAULT_RELAX_CSV`가 실존 안 하는 경로(`slab_slabcc/`)라 **relax 축이 조용히 n/a로 빠지고 있었음**. 이제 `results/corrections/*/slab_corrections.csv` 자동탐색, 여러 개면 목록 출력 후 `--relax-csv` 요구(추측 금지).
- 이걸 켜니 **하전 행 9개 중 8개가 ipr/relax 두 축 일치**(As_In q±1, Cl-As_In q±1, In_As q+1, V_Cl-V_As q±1, In_As_1 q±1). 불일치는 `Cl-As_In q+2` 하나뿐 = 위 다중 carrier 케이스. 새 probe 규칙의 독립 검증.
- 04에도 **실복사**(심링크 아님, `04.../scripts/ipr_gate.py`), 두 사본 동일. 구 CSV는 `IPR_gate_PRE-OCCDIFF_2026-07-22.csv`로 백업, `results/DFE_plots/IPR_gate.csv` 재생성 완료.
