---
name: next_steps_2026_07_22
description: "2026-07-21 세션 종료 시점 미결 — 04 Cl 결함 3종 DOS/BAND(k-mesh·경로 결정 완료), In metal μ_Cl, In_As_1 하전 체인 수확"
metadata: 
  node_type: memory
  type: project
  originSessionId: d576a7a9-cf3d-4e2f-9807-95093dc06f3d
  modified: 2026-07-21T09:31:08.554Z
---

2026-07-21 세션 종료. 오늘 확정한 것과 내일 집을 것을 분리한다.
오늘 세션 전체 기록은 PDF로 있음: `04-InCl3-passv_6L_4x2x1_HSE06/results/2026-07-21_spin-and-IPR-gate_report.pdf` (10쪽, `.md` 소스 동봉).

## 오늘 완료 (재작업 금지)

- **04 IPR 게이트 판정 완료** — bound=`In_As_1`(2.03×, 경계)·`In_As_2`(5.75×)뿐, 나머지 8개 PHS. → [[ipr_gate_tool]]
- **`ipr_gate.py` 버그 2건 수정** — 스머링꼬리 frontier / 모서리를 점유수로 선택. 02 재판정 뒤집힘 0건.
- **스핀 쟁점 종결** — 자성은 전자수 패리티가 아니라 국소화가 결정. → [[spin_magnetism_ipr_predictor]]
- **Cl 3종 스핀 확정 비자성** — `Cl_i-As`(+0.5meV, mag 0.0010) `Cl_As_1`(+0.2) `Cl_As_2`(+0.5).
  **→ DOS/BAND는 ISPIN=1로 돌리면 된다.**

## ⏭ 1. Cl 3종(`Cl_As_1`·`Cl_i-As`·`Cl_As_2`) DOS/BAND — **k 설정 결정 완료, 바로 제출 가능**

**μ_Cl을 기다릴 필요 없다**(2번과 직교). μ는 형성에너지에만 들어가고 DOS/BAND는 조성 고정 셀의
전자구조라 μ가 1.86 eV 움직여도 한 점도 안 변한다. **오히려 DOS가 band-filling(4번)을 낳으므로
DFE의 선행 조건**이다.

**셀**: a=17.249, b=12.197, c=29.814 Å, ab=90.00°(직교). a*=0.3643, b*=0.5152 Å⁻¹ (b*/a*=1.414).

**k-mesh = 2×2×1 유지 (결정)**. 근거:

| 셀 | Δk_a | Δk_b |
|---|---|---|
| 02 (3×2), 검증된 메쉬 | 0.243 | **0.258** |
| **04 (4×2)** | **0.182** | **0.258** |

b는 두 셀 격자상수가 같아 Δk_b 동일, a는 04가 25% 더 촘촘 → **어느 방향으로도 02보다 나쁘지 않다.**
02의 2×2×1은 전자수/band-filling 목적 충분으로 검증됨([[dos_2x2x1_tetrahedron_occ_overshoot]]).
등방을 원하면 2×3×1(비율 1.41→1.06)이지만 **이미 충분한 방향을 조이는 것**이라 HSE 비용 대비 불필요.

**경로 = Y-Γ-X-S 유지 (결정)**. 직교 유지라 고대칭점 정의 불변(Γ=(0,0), X=(½,0), Y=(0,½), S=(½,½)).
InAs는 Γ 직접갭이라 host CBM이 슈퍼셀 Γ로 접힘 → Γ 지나는 이 경로로 충분.

**⚠단, 구간당 점 수를 재배분할 것.** `config/KPOINTS/KPOINTS_03.Band` 현재 구조 =
앞 4점(weight 1, 2×2×1 SCF 메쉬) + 뒤 18점(weight 0) = **3구간 × 6점**, 헤더 `... 18 3 6 6 6`.
a*가 b*보다 작아 **Γ-X 구간이 1.41배 짧은데 점 수가 같아 밀도 불균일**:

| 구간 | 방향 | 길이(Å⁻¹) | 현재 점수 | 현재 간격 | **권장 점수** |
|---|---|---|---|---|---|
| Y→Γ | b* | 0.2576 | 6 | 0.0515 | 6 |
| **Γ→X** | **a*** | **0.1821** | 6 | **0.0364** | **4** (또는 5) |
| X→S | b* | 0.2576 | 6 | 0.0515 | 6 |

즉 `6 6 6` → **`6 4 6`**. 사용자도 "Γ-X 샘플링 줄여도 될 것 같다"로 동의(2026-07-21).

**제출 전 확인 2건** (아직 미확인):
- ⚠**`ICORELEVEL=1<TAB>#` 탭 문자 버그** — 02에서 DOS/Band INCAR 12개가 `IERR=5`로 즉사했던 건.
  04 템플릿(`INCAR_02.G221-DOS`, `INCAR_03.Band`)에도 있는지 봐야 함. → [[surface_defect_icorelevel_bug]]
- ⚠**gam→std WAVECAR 비호환** — `01_Spin-gam-relax`(gam)의 WAVECAR을 DOS(std)가 못 읽음.
  **DOS 단계는 ISTART=0**(ICHARG=1은 유지 가능). → [[surface_defect_istart_wavecar_gam_std]]
- `stages.yaml`의 `02_G221-DOS`·`03_Band` 블록이 현재 **주석 처리**되어 있음 → 해제 필요.
  ⚠해제 시 ORDERING TRAP: `01_opt`(leaf)이 항상 **맨 끝**이어야 함.

## ⏭ 2. In metal → μ_Cl(InCl₃) — **사용자가 구조 제공 예정**

상세·조건·미결(PRECFOCK)은 [[mu_reference_phases]]에 기록. **현재 04 DFE 서열은 무효**
(Δn_Cl=+1 결함이 음수 형성에너지, 구속 넣으면 일괄 +1.86 eV 이동). → [[cl_as_negative_eform_reference_slab]]

## ⏭ 3. `In_As_1` 하전 체인 수확 (실행 중)

`afterok` 체인 제출됨: **55603(q0, R) → 55604(q+1) → 55605(q-1)**, cascade 8노드×36, NCORE=18/NSIM=36.
각 잡 = `00_Gam-relax → 01_Spin-gam-relax → 01_Spin-gam-optical_Rq0`.
ISTART/ICHARG = 00:0/2, 01:**1/1**(사용자 지정), 01_opt:**0/2**(사용자 지정).

**판정 시 주의**: q±1 전자수가 **둘 다 홀수**(1023/1025)이고 `In_As_1` IPR 2.03×는
**위험구간(1.2~2×) 경계**다. `mag`+`EENTRO` 병독 필수 — EENTRO≈−0.056에 mag≈0이면
`Cl_i-As`처럼 진짜 비자성일 수도 `In_i_Td_In`처럼 갇힌 것일 수도 있다.
**판별은 IPR, 그리고 q>0은 LUMO probe**. → [[spin_magnetism_ipr_predictor]]

⚠`afterok` 부작용: q0이 `01_opt`에서 실패하면 relax 두 단계가 멀쩡해도 q±1이 **영영 실행 안 됨**.
그 경우 dependency 풀고 재제출.

## ⏭ 4. band-filling 보정 (1번 완료 후)

파이프라인에 **없음**. `Cl_As_1`/`Cl_As_2`는 CB에 전자 **2개**를 넣으므로 1개짜리보다 크다.
주입돼 있던 0.78 eV는 출처 불명이고 2×2×1 DOS 실측은 0.33 eV(전자 1개).
→ [[bandfilling_measured_from_dos]] [[shallow_limit_dfe_construction]]

## ⏭ 5. 미결 판정 3건

- **`V_In`** — EDGE-AMBIGUOUS(VBM기준 1.19× vs CBM기준 2.07×, 게이트를 걸침). 정렬 또는 dispersion 축 필요.
- **`As_In`** — 메모리엔 "진짜 CB 공명"인데 Γ 프로브는 VB쪽 닫힌껍질로 놓음. **Γ 1점 한계**. multi-k 필요.
- **`In_i_Td_In`(02)** — mag=0.5027로 갇힘, ΔE −7.0 meV 신뢰불가. `NUPDOWN=1` 재계산.
  (2026-07-21 사용자 판단: interstitial은 더 검토 후)

## 커밋 안 된 것

오늘 수정한 `02-.../scripts/ipr_gate.py`, 양 프로젝트 `results/DFE_plots/IPR_gate.csv`,
04의 PDF 보고서는 **계산 폴더라 자동 동기화 대상이 아니다**. 04는 자체 git 있음. → [[server_fs_git_sync_scope]]
