---
name: mu_reference_phases
description: "HSE06(AEXX=0.27,ENCUT300) 기준상 세트 확정값 — mu_H, mu_Cl(Cl2/HCl). HCl 생성E 실험과 2.6meV 일치. mu_Cl(InCl3)는 mu_In(In_d) 부재로 막힘"
metadata: 
  node_type: memory
  type: project
  originSessionId: 21ba4701-12fb-4582-8d69-24cecc9e027f
  modified: 2026-07-21T09:24:30.215Z
---

## 기준상(reference phase) 세트 — 2026-07-21 확정

경로: `33-inAs/__Ligands_and_Chemicals__/`, 요약 스크립트 `mu_summary.py`

**공통 footing** (섞으면 안 됨): 30 Å 박스, Γ-only, HSE06 AEXX=0.27/HFSCREEN=0.2,
ENCUT=300, PREC=N, **LREAL=A**, **PRECFOCK=fast**, LHFSKIP=.T., ISMEAR=0/SIGMA=0.05,
11-PBE-Gamma → 12-HSE06-Gamma로 PBE CONTCAR 스테이징. POTCAR: H 15Jun2001,
Cl 06Sep2000(슬랩과 동일 파일 확인), In_d 06Sep2000.

| phase | E (eV) | d (Å) |
|---|---|---|
| H₂ | −7.90947434 | 0.7419 |
| Cl₂ | −5.39591358 | 1.9647 |
| HCl | −7.64178431 | 1.2769 |
| InCl₃ (기체 단분자, D3h) | −14.96230512 | 2.2922 |

- **μ_H = −3.954737 eV**
- **μ_Cl(Cl₂) = −2.697957 eV** ← Cl-rich 극한, Δμ_Cl ≡ 0 (μ_Cl의 **상한**)
- **μ_Cl(HCl+H₂, H-rich) = −3.687047 eV**, Δμ_Cl = **−0.989 eV**

### 검증 통과
ΔE_f(HCl) 계산 −0.989090 eV vs 실험 유도 전자에너지 −0.986476 eV
(JANAF ΔfH(0K)=−92.127 kJ/mol에서 ΔZPE=+0.0316 eV 제거) → **오차 −2.6 meV**.
ENCUT=300/PREC=N인데도 매우 좋음 → 이 세트는 신뢰 가능.

### ⚠ 함정
- **PRECFOCK 섞지 말 것**: 같은 Cl₂를 PRECFOCK=Normal/10Å/LREAL=.FALSE.로 돌리면
  −5.42929 (33 meV 차이). 위 세트는 전부 fast. [[cl2_hse06_calc]]의 −5.3953과는 0.6 meV 일치.
- **μ_Cl(InCl₃)는 막혀 있음**: μ_In이 필요한데 트리에 **In_d POTCAR In 금속이 없음**.
  있는 건 `04-Chemical-reservoir/01-In-metal/01-Functional/PBE_HSE06` = In(4d 없음)/AEXX=0.25/
  ENCUT=400/E=−2.8530 뿐이고, CLAUDE.md의 μ_In=−2.562344는 출처 계산이 트리에 없음
  (mu_used.json에 상수로만 존재). ↔ μ_Cl 쪽 같은 구멍은 [[cl_as_negative_eform_reference_slab]]
- **10-InCl3는 고체가 아니라 기체 단분자**. 실제 기체상은 In₂Cl₆ 이량체가 우세하므로
  "기체 기준"을 쓰려면 이량체 확인 필요. 상별 μ_Cl 서열 = 기체단분자 > 고체 > 용액.
- **바이너리**: g2 파티션은 `...dftd4...gam.x`, **cascade 노드엔 그 빌드가 없음** →
  `vasp.6.5.1.wan90.beef.plugin.lhfskip.gam.x` 사용. 08-HCl/10-InCl3의 run.sh를 cascade에
  그대로 복사하면 exit 127로 즉사.

## ⏭ In metal 계산 예정 (**2026-07-22 사용자가 결과 제공**)

사용자가 **bloch 서버에서 Birch-Murnaghan fit + HSE06 AEXX=0.27로 구한 In metal 바닥상태 구조**를
2026-07-22에 직접 제공하기로 함(2026-07-21 약속). 이게 μ_In → μ_Cl(InCl₃) 구속을 여는 열쇠다.
⚠받는 즉시 확인할 것: POTCAR가 **In_d**인지, AEXX=0.27·ENCUT=300인지, PRECFOCK이 어느 쪽인지.

**기존 계산 전수 감사 결과 — 셋 다 사용 불가** (`04-Chemical-reservoir/01-In-metal/`):

| 경로 | POTCAR | ENCUT | AEXX | E(σ→0) |
|---|---|---|---|---|
| `01-Functional/PBE_HSE06` | `PAW_PBE In` (**d 없음**) | 400 | 0.25 | −2.85302 |
| `01-Functional/LDA_hybrid` | `PAW In` (**d 없음**) | 400 | 0.30 | −3.18503 |
| `.../LDA_hybrid/backup_volume_relax` | `PAW In` (**d 없음**) | 300 | 0.30 | −3.25525 |

**새 계산이 맞춰야 할 조건**: `In_d` POTCAR(슬랩과 동일) + AEXX=0.27 + ENCUT=300
+ 위 "공통 footing"(30Å 아님 — 금속이므로 k-mesh 필요, 나머지 태그는 세트 준수).

**⚠ 미결 결정 — PRECFOCK을 어디에 맞출 것인가.** 이 μ 세트는 전부 **fast**인데
04-InCl3 결함 슬랩은 **Normal**이다. μ는 `E_f = (E_def − E_bulk) − Σ Δn·μ`에서 슬랩
에너지와 직접 빼지므로 어느 쪽 기준으로 통일할지 정해야 한다. 혼용 시 ~33 meV.
(참고: 33 meV는 [[energy_column_sigma0_vs_toten]]의 28 meV와 같은 규모 = 결론을 뒤집진
않지만 CTL 미세 위치에는 보임)

**왜 급한가**: 이 구속이 없어서 04의 DFE 서열이 현재 **무효**다. Δn_Cl=+1 결함이 음수
형성에너지를 내고 있고, 구속을 넣으면 일괄 +1.86 eV 이동해 서열이 바뀐다 —
`In_As_1`(Cl 무관, In-rich 0.715 eV)이 실질 최저 축으로 올라온다.
상세: [[cl_as_negative_eform_reference_slab]], [[ipr_gate_tool]]
