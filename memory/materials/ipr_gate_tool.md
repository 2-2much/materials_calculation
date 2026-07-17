---
name: ipr_gate_tool
description: scripts/ipr_gate.py — 전 defect·전 charge 국소화(IPR) 게이트 자동화. slabcc 적용가능 여부 판정. q>0은 LUMO를 봐야 하는 함정
metadata: 
  node_type: memory
  type: reference
  originSessionId: c6f88bf4-31fa-4e2c-90db-76d7de8a9d21
---

`12-Surace-defect_calculation/02-Cl-passv_6L_3x2x1_HSE06/scripts/ipr_gate.py` (2026-07-17 신규).
출력: `results/DFE_plots/IPR_gate.csv`. 실행: `python3 scripts/ipr_gate.py --csv results/DFE_plots/IPR_gate.csv` (인자 없이도 동작, `--calc`로 다른 프로젝트 지정 가능).

**무엇을 하나**: 결함의 frontier 상태가 속박(deep)인지 host 밴드모서리(shallow)인지 판정한다. IPR = Σᵢwᵢ² (PROCAR per-ion `tot` 열을 재규격화). 1/IPR = 상태가 퍼진 실효 원자 수. 판정 = pure 밴드모서리 IPR의 2배 초과면 bound. 이게 [[slabcc_delocalized_defect_policy]]의 게이트 1번을 자동화한 것.

**왜 00_Gam-relax인가**: 전 defect·전 charge가 공유하는 **유일한** 단계다(02_G221-DOS/03_Band는 일부만 존재). Γ 1점, ISPIN=1, 점유수 0~2 관례로 통일돼 있어 사과-대-사과 비교가 된다.

**⚠ 최대 함정 — q>0은 LUMO를 봐야 한다.**
초판이 HOMO만 보다가 `Cl-As_In q+1`을 1.46× shallow로 **오판**했다. q+1 셀의 HOMO는 이미 전자를 빼앗긴 뒤라 그냥 **host VBM**이고, 정작 문제의 결함 준위는 **비어버린 LUMO**다. 규칙: `q>0 → LUMO`(전자를 잃은 준위), `q≤0 → HOMO`(전자를 담은 준위). 고치니 5.47× bound로 뒤집혔다. 참조 밴드모서리도 probe의 성격에 맞춰 고른다(점유>1.5면 pure VBM, 아니면 pure CBM).

**파서 전제**: LORBIT=11(`PROCAR lm decomposed`, phase 블록 없음), ISPIN=1, Γ 1점. phase 블록이나 truncated PROCAR면 명시적으로 예외를 던진다. pseudo-H(`H.`) 때문에 pymatgen은 못 쓰므로 직접 파싱한다.

**Why:** 어느 결함에 model-charge 보정을 신뢰할지가 CTL의 진위를 결정하고, 그게 [[cqd_ntype_origin_goal]]의 판정 근거다. 손으로 내리던 판단을 재현 가능한 게이트로 굳혔다(실제로 기존 수동 판단 3건을 자동 재현).

**How to apply:** 새 charge state나 새 결함을 추가하면 먼저 이걸 돌려 shallow/deep을 확정한 뒤 slabcc 여부를 정한다. 04-InCl3 등 다른 프로젝트엔 `--calc`로 겨냥. 실공간 교차검증이 필요하면 LPARD V_loc([[vclclas_cohp_donor_evidence]])을 병행 — PAW 구 밖 전하 반론을 차단한다.
