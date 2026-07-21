---
name: ipr_gate_tool
description: scripts/ipr_gate.py — 전 defect·전 charge 국소화(IPR) 게이트 자동화. slabcc 적용가능 여부 판정. q>0은 LUMO를 봐야 하는 함정
metadata: 
  node_type: memory
  type: reference
  originSessionId: c6f88bf4-31fa-4e2c-90db-76d7de8a9d21
  modified: 2026-07-21T06:45:08.516Z
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

**⚠2026-07-20 3축化 + carrier 대칭.** IPR은 여전히 **권위(authoritative) 축**이고 verdict는 IPR만으로 결정. 추가 2축은 확인·플래그용:
- **축2 E_relax**(하전상태): `--relax-csv`(기본 `results/corrections/slab_slabcc/slab_corrections.csv`)에서 읽음. >0.10 bound / <0.05 shallow. ⚠**q0는 E_relax=0이 정의상 값**이라 shallow 투표에서 제외(안 하면 Cl-As_In q0 가짜 CONFLICT). 실측상 IPR과 완벽 일치(bound 0.28~0.37 vs shallow 0.01~0.05).
- **축3 dispersion**(확인용): `--disp-stage 02_G221-DOS`로 multi-k PROCAR에서 frontier 밴드폭. <0.05 bound / >0.30 shallow. 없으면 n/a(방어적, 절대 안 깨짐).
- **carrier 프레이밍**: donor(q>0→LUMO vs CBM) / acceptor(q≤0→HOMO vs VBM). 2축이 IPR과 어긋나면 `CONFLICT` 플래그(예: 경계 케이스 재검토용).
전체 판정표(2026-07-20 재실행): Cl-As_In −1/0/+1/+2 전부 bound(IPR+relax 일치), V_Cl-Cl_As·As_In·In_As·In_i·V_Cl-V_* shallow, V_Cl-Cl_In q0 bound(8.35×). 짝 스크립트=[[shallow_limit_dfe_construction]]의 `plot_shallow_limit_DFE.py`.

## ⚠2026-07-21 버그 2건 수정 — 04 판정 2건이 뒤집혔다 (02는 무사)

04-InCl3에 처음 적용하다 발견. 둘 다 **bound로 오판하는** 방향이라 slabcc를 헛되이 적용할 뻔했다.

1. **스머링 꼬리를 frontier로 집음.** `frontier()`가 `OCC>1e-3`인 최상단 밴드를 골랐다. SIGMA=0.1이면 E_F 위 0.1eV 준위가 occ~0.3을 받는데 전하는 없다. `V_As`가 전자 0.12개짜리 국소 꼬리(IPR 0.128)를 집어 **13.47× "bound"** → 실제 캐리어는 전자 0.88개의 비국소 상태(**1.07× shallow**). → `OCC_MIN=0.2` 신설.
2. **비교 모서리를 점유수로 고름**(`vbm if occ>1.5 else cbm`). **반점유 가전자대 상태**(occ≈1.0)가 CBM과 비교된다. 이 셀 **VBM은 CBM보다 본래 1.7~1.8× 더 국소적**(As-p vs In-s)이라 비율이 그만큼 부풀려져 게이트 2.0을 넘긴다. `V_In` **2.07× "bound" → 1.19× shallow**. → **에너지(midgap 기준)로 선택**하도록 변경.

에너지 선택은 정렬(alignment)에 의존하는 약점이 있어, **양쪽 비율(`ratio_vs_vbm`/`ratio_vs_cbm`)을 모두 CSV에 기록**하고 모서리 선택이 판정을 바꾸면 `EDGE-AMBIGUOUS` 플래그를 띄운다(=미결로 취급). 실제로 04 `V_In`이 여기 걸린다(1.19× vs 2.07×).

**02는 재실행 결과 22행 중 판정 뒤집힘 0건**(비율만 변함: In_As q0 0.94→1.41, V_Cl-Cl_In q0 8.35→5.56). 02의 frontier들이 확실히 국소(4~8×)이거나 확실히 비국소(1.0~1.4×)라 게이트에서 멀었기 때문 — **기존 02 결론은 그대로 유효**. 구 판정표는 `IPR_gate_PRE-FIX_2026-07-21.csv`로 백업.

**04-InCl3 q0 판정(2026-07-21, 수정판)**: bound=**In_As_2**(5.75×, 확실 — 빈 국소준위도 gap 내 존재) / **In_As_1**(2.03×, **경계라 dispersion 축 필요**). 나머지 8개(As_In·Cl-As_In·Cl_As_1·Cl_As_2·Cl_i-As·In_i_2·V_As) 전부 shallow(PHS). **V_In은 EDGE-AMBIGUOUS로 미결.** ⚠04는 `charge_states:[0]`뿐이라 LUMO probe(도너 판정)는 미행사. ⚠`V_As`는 점유 비국소 상태 **바로 위 0.098eV에 강한 국소 빈 준위**(1/IPR=7.8)가 있는 CB 공명 구조 → q+1에서 재확인 필요.
