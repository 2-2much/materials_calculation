---
name: mote2-vte-defect-setup
description: MoTe2 V_Te 결함 03-Vte_defect 셋업 — 3단계 흐름, MAGMOM 무력화 함정, V_Te는 비자성, K→Γ 접힘은 n이 3의 배수일 때만
metadata:
  node_type: memory
  type: project
---

`~/materials/moTe2/03-Vte_defect/` (2026-09-07 설계 확정, 실행은 사용자가 직접).
목적은 **V_Te 계산에 충분한 셀 크기 결정** → 그다음 국소 재구성 탐색 → 그다음 하전 상태.

## 3단계 흐름과 ★MAGMOM 무력화 함정

```
01-relax_nsp  ISPIN=1                 싼 값에 바닥 기하
02-relax_sp   ISPIN=2 + MAGMOM        ★에너지·최종기하·CHGCAR
03-band_sp    ICHARG=11 + Line-mode   ★분산폭 W
```

★**02 는 기하(CONTCAR)만 물려받고 전자는 `ISTART=0`/`ICHARG=2`로 새로 출발해야 한다.**
01 의 WAVECAR/CHGCAR 를 넘기면 비분극 해가 두 스핀에 복제되어 초기 모멘트가 정확히 0 이
되고 MAGMOM 이 죽는다 (InAs 때 [[spin_stage_symmetry_never_broken]] 과 같은 함정).
그래서 01 은 `LWAVE=.F. LCHARG=.F.`.

★**static 단계는 불필요하다.** 셀이 고정이라 기저집합이 안 바뀌므로 relax 마지막 스텝
에너지와 single-point 가 사실상 같다. relax 에 `LCHARG=.T.` 만 켜면 끝.

★**W 는 반드시 Line-mode 에서.** SCF 메쉬는 6×6 셀이면 2×2×1 이라 IBZ k 점이 2~3 개뿐
이라 max−min 이 무의미. 반대로 **점유수·E_fermi 는 02 의 균일 메쉬에서** 읽는다
(ICHARG=11 line-mode 의 점유수는 신뢰 불가).

## ★V_Te 는 비자성이다 (갭 준위가 있어도)

Te 제거 → Mo dangling bond 3 개 → C3v 에서 a₁ + e. **남는 전자는 2 개뿐**이라
a₁²e⁰ 닫힌 껍질 → S=0. 갭 안에 준위가 둘이나 있어도 부분점유가 아니면 자성이 아니다.

- Yelgel 논문 자신도 "energy levels caused by the absence of Te atoms are **higher than
  the Fermi level**" (= 비점유)라고 적었고, 자기모멘트는 한 번도 언급 안 함
- 그 논문 참고문헌 [35] **Li/Ma/Zhao, J. Alloys Compd. 735, 2363 (2018)** 이
  "**V_Te, V_Te2, V_MoTe3, V_MoTe6, 4|4a 경계는 자성 유도의 예외**"라고 명시
- 자성 후보는 **V_Mo(중성, dangling bond 6개)** 와 **V_Te q=+1(a₁¹ → 1 μB)**

MAGMOM 상한 근거: 삼중항이어도 2 μB 가 천장 → VASP "예상값의 1.5 배" 규칙이면 셀 총합
3 μB = Mo 하나당 1.0. 사용자는 더 강한 탐침으로 **2.0** 을 선택(총 6 μB). 무해.
`build_cells.py --magmom X` 가 빈자리 최근접 Mo 3 개(2.717 Å)를 찾아 `MAGMOM_VTe` 파일로
쓰고, `run_stage` 6번째 인자가 그걸 INCAR 에 `cat >>` 한다. INCAR 원본의 MAGMOM 은 주석.

## ★k 점: K→Γ 접힘은 n 이 3 의 배수일 때만

2H 는 VBM·CBM 이 K 에 있다. **Γ-only 금지** — 4×4, 5×5, 7×7 은 밴드끝을 통째로 놓친다.
`make_kpoints.sh`(면내 전용, k_z=1 고정) 에 **KSPACING=0.178** → primitive 12×12×1 과 동일 밀도.

| 셀 | 원자(pri/def) | L | mesh | ISYM=0 시 IBZ |
|---|---|---|---|---|
| 3×3 | 27/26 | 10.51 Å | 4×4×1 | 4→**10** |
| 4×4 | 48/47 | 14.01 Å | 3×3×1 | 3→5 |
| 5×5 | 75/74 | 17.51 Å | 3×3×1 | 3→5 |
| 6×6 | 108/107 | 21.01 Å | 2×2×1 | 3→4 |

**n=3,4,6 은 12×12×1 이 정확히 접힌 것**이라 절대 k 점이 완전 동일 → 추세가 가장 깨끗.
같은 크기의 pristine/defect 는 반드시 같은 KPOINTS (dE 에서 k 오차 상쇄).
μ_Te 는 크기 무관 상수라 **수렴 판정엔 불필요**.

밴드 경로는 `make_kpath.py` 가 a1·a2 사잇각으로 판별: 육방 Γ-M-K-Γ / 직방 Γ-X-S-Y-Γ.
vaspkit 와 좌표 일치 확인함. 구간당 5 점.

## 판정 4종 (`tools/analyze_size.py`)

| 지표 | 기준 |
|---|---|
| dE = E(V_Te)−E(pristine) | 한 단계 키워 변화 < 30~50 meV |
| dEsp = E(spin)−E(nonspin) | 0 에 붙고 mag≈0 → 비자성 확정 |
| 결함준위 분산폭 W | < 30 meV |
| 경계 변위 d_bnd (r≥0.45L) | < 0.01 Å |

## ★NPW 교정식 (WAVECAR 용량 예측)

`NPW = V·k³/(6π²)`, `k[Å⁻¹] = sqrt(E/3.80998)`. ENCUT=400 이면 **18.17/Å³**.
실측 검증: 2H primitive V=250.92 Å³ → 예측 4558 vs OUTCAR 4576 (0.4%).
`WAVECAR ≈ NKPTS × NBANDS × NPW × 8 bytes × NSPIN`.
n6 defect 는 relax 5.1 GB / band(15 k점) **19 GB**. 구간당 20 점이었으면 band 만 266 GB.

## ⚠ Yelgel 논문(STAM 25, 2388502, 2024) 인용 시

- **E_f 단위가 meV/atom** — V_Te 67.296 meV/atom × 74 = **4.98 eV** 로 환산해야 함
- SOC 포함 → pristine 갭 0.935 eV. SOC 없는 PBE 는 ~1.1 eV
- **MP 6×6×1** 사용 — 육방정에서 짝수 MP 는 대칭을 깬다. 수치 재현 시도 금지
- "CBM 이 Γ 로 이동"은 **수퍼셀 BZ 기준**. unfolding 없이 직접갭→간접갭 주장 수용 불가

관련: [[mote2_2d_lattice_scan]] [[mote2_1tp_bm_fit_deferred]] [[spin_magnetism_ipr_predictor]]
