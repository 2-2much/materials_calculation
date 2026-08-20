---
name: inas_facet_ipea_workflow
description: "04-Facet_IP-EA 계산 워크플로 전체 — sham 트리 구조·4단계 스텝·도구 12종·분석 두 트랙·실제로 데인 함정 8개·통과한 검증 4건. 새 셀을 추가할 때 이것부터 읽을 것"
metadata:
  type: project
---

**작업 트리 = `sham:~/materials/33-inAs/__Functional_Validation__/10-Primitive-slab/04-Facet_IP-EA/`**
(kohn 은 조종석. bloch 에는 생성기 원본만. 2026-08-18 착수 → [[inas_surface_ip_ea_plan]])

## 트리 구조

```
04-Facet_IP-EA/
  00-generators/    bloch 이관 슬랩 생성기 (01-110slab, 02-100slab, 03-111slab)
  01-cells/<GROUP>/<cell>.vasp
  02-potcar/POTCAR.<종>      In_d As Cl H H.75 H1.25 H1.5
  03-runs/<GROUP>/<cell>/<STEP>/       STEP = 00-Hopt|01-relax|02-dipole|03-nodip
                        __attemptN__/  이전 시도 보존 (삭제 금지)
  04-tools/  05-results/  06-bulk_ref/PBE-d/
```

## 4단계 스텝

| STEP | 내용 | 핵심 태그 |
|---|---|---|
| `00-Hopt` | In/As 고정, pseudo-H 만 이완 | EDIFF=1E-4, IBRION=1 |
| `01-relax` | 프로덕션 고정 규약으로 전체 이완 | EDIFF=1E-4, **IBRION=1**, EDIFFG=-0.015 |
| `02-dipole` | LDIPOL single point — **IP 는 여기서** | EDIFF=1E-6, NSW=0, **LVHAR=.T., IDIPOL=3, LDIPOL=.T., DIPOL=전하중심** |
| `03-nodip` | 02 를 LDIPOL 만 끄고 반복 (아티팩트 크기) | IDIPOL=3 유지, LDIPOL=.F. |

⚠ **IBRION=2(CG) + EDIFF=1E-4 는 "ZBRENT: fatal error in bracketing" 으로 죽는다**
(A1 10ML, 35 이온스텝, 에너지는 이미 8자리 수렴). 작은 셀은 지형이 평탄해 선형탐색이
잡음 아래 구간을 못 잡는다. **IBRION=1(RMM-DIIS)은 ZBRENT 를 안 쓰므로 그 실패가 없다.**

공통: `ENCUT=400 · PREC=Accurate · LASPH=.TRUE. · ISPIN=1 · ISYM=0 · LORBIT=11 · NEDOS=3000 ·
ISMEAR=0/SIGMA=0.05 · NCORE=8/NSIM=8 · a0=6.189842 · 진공 20 Å · 10 노드`
VASP = **`/TGM/Apps/VASP/VASP_BIN/6.3.2/vasp.6.3.2.std.x`** ([[g1_node_vasp_binary_limit]])

고정 규약: **(100) 아래 2 원자면 / (110) 아래 2 layer / (111) 아래 1 BL(=원자면 2개)** + 각 아래 pseudo-H.
★예외: **대칭셀(B2·S1)은 고정 0개** — 한쪽만 고정하면 0이어야 할 쌍극자가 인위적으로 생겨
검증셀의 존재 이유가 사라진다.

k-point 는 그리드가 아니라 **밀도**: (100)1×1 Γ6×6×1 · (100)2×1 Γ3×6×1 · (110)1×1 Γ6×4×1 ·
(111)2×2 Γ3×3×1. 전부 Γ-centered(육방에서 MP 는 대칭을 깬다).

## 도구 (`04-tools/`)

`prep_runs.py`(런 트리 생성·INCAR 원본) · `pipeline.sh`(셀별 **점진** 스테이징·제출) ·
`preflight.py` · `mkpotcar.py` · `graft_H.py`(pseudo-H **벡터** 이식) · `macroavg.py`(트랙 A) ·
`vaclevel.py`(트랙 B) · `statechar.py`(PROCAR 국소화) · `collect.py` ·
`new_attempt.sh`/`rerun_step.sh`/`redo_cells.sh` · `watch_step.sh`

**재계산은 `rerun_step.sh` 하나만** — 보존 → 재생성 → 직전 CONTCAR 시드 → preflight → 제출.
`prep_runs.py build` 는 내용 있는 스텝 디렉토리를 **거부**한다 → [[feedback_never_delete_use_attempts]]

**체인 실행 `run_chain.sh`** — 셀 하나의 01→02→03 을 **한 allocation** 에서 순차 실행.
잡당 10노드/가용 60노드라 동시 6잡뿐이고, 스텝마다 큐를 다시 서면 그 대기가 계산보다 크다.
`prep_runs.py chain --runs 03-runs --tools 04-tools --nodes N` 으로 (재)생성.
⚠ 체인으로 돌리는 셀은 후속 스텝에 `.submitted` 를 **선점**해 파이프라인과 이중제출을 막는다.
그런데 **체인이 죽으면 그 마커가 남아 후속 스텝이 미아**가 된다 — 체인 실패 시 마커를 걷을 것.

**파이프라인은 전역 배리어가 아니다.** 셀 간 의존성이 없으므로 01-relax 가 끝난 셀부터
02/03 으로 넘긴다. 큰 (111) 셀을 기다리지 않는다.

## 분석 두 트랙

- **트랙 A `macroavg.py`** (주력) — `IP = V_vac − (V̄_slab + ΔV_bulk)`,
  `ΔV_bulk ≡ E(Γ15v) − V̄_bulk`. 평면평균을 facet 벌크주기 boxcar 로 거시평균.
  **표면상태와 무관**하다. 확정 **`V̄_bulk = 0.0000`, `ΔV_bulk = 3.8258 eV`**.
  주기: (100) a₀/2=3.0949 · (110) a₀/√2=4.3769 · (111) a₀/√3=3.5737 Å
- **트랙 B `vaclevel.py`** — 슬랩 고유값 직독. 표면상태가 진공 기준 어디 앉는지(E_F pinning).

## ⚠ 실제로 데인 함정 8개

1. **PBE 벌크 InAs 밴드순서 역전** → [[inas_pbe_band_inversion_bulk]]. EA 는 PBE 로 못 낸다.
2. **bare 표면의 "VBM/CBM" 은 dangling bond 표면상태**다. 고유값 직독이 그걸 집는다.
   → 트랙 A 가 필요한 이유. 판별은 PROCAR (`statechar.py`, z 프로파일까지 볼 것 —
   z_cen 만 보면 **양쪽 표면에 동시에 붙은 상태**를 벌크로 오판한다).
3. **`occ > 1e-3` 을 점유로 보면 안 된다** — SIGMA=0.05 에서 occ 0.01 인 빈 상태를 VBM 으로
   집는다(A3 10L 이 그래서 gap 0.745 라는 엉뚱한 값). **분수 점유 개수로 금속 자동 판정**.
4. **pseudo-H 는 결합길이만 옮기면 안 되고 변위벡터째**. (110) 은 생성기가 표면법선(0°)에
   세우는데 이완이 **36° 돌려놓는다**((100) In–H 도 54.7→47.9°, (111) 은 0° 유지).
   확정: (100) As–H 1.5572 / In–H 1.7298 · (110) As–H 1.5608 / In–H 1.7726 ·
   (111) As–H 1.5608 / In–H 1.7674. **facet 의존, 리간드 무의존**(05·07·08·09 전부 동일).
5. **`LORBIT` 없으면 이온 이완에서 DOSCAR 를 안 쓴다**(헤더 167 bytes). PROCAR 도 없다.
   대조실험으로 확정(NSW=3, LORBIT 만 차이 → 167 bytes vs 4.9 MB).
6. **`local a=$1 b=$a` 는 bash 에서 안 된다** — local 은 빌트인이라 인자가 실행 전 한꺼번에
   확장된다. 이것 때문에 파이프라인이 셀 디렉토리에 9.3 GB 를 잘못 썼다.
7. **CONTCAR 는 종 이름을 자른다**(`H.75`→`H.`, `H1.25`→`H1`). 좌표는 CONTCAR, **6행은 원본에서 복원**.
8. **`find` 깊이** — 라이브 스텝은 `03-runs` 기준 깊이 3, 그 안의 파일은 4, `__attemptN__` 은 더 깊다.
   감시·스테이징 스크립트에 `-maxdepth 3` 이 없으면 낡은 `.done` 을 실패로 오탐한다.

## 통과한 검증

- **A3(비대칭+LDIPOL) ↔ S1(대칭, 보정 불필요)**: 8L 에서 **2 meV** 일치 → 쌍극자 기계 정상
- 대칭셀 두 면 진공 단차 **정확히 0.000**, `DIPOL_z` **정확히 0.5000**
- 02-dipole 재실행 재현성 **0.000 meV**
- (110) 6L 표면상태 갭 0.432 ↔ 기존 `11-110bare` 트리 0.450 eV

## 리간드 셀 (Round 2)

`00-Hopt` 은 **한 잡도 안 돌린다** — 아래 pseudo-H 는 facet 별 확정 벡터를 `graft_H.py` 로
이식하고 고정한다(§0.5-4). 근거: **결합길이는 facet 의존·리간드 무의존**
(05 Cl/07 Cl/08 Cl-MA/09 아세테이트가 전부 바닥 As–H 1.5589~1.5591 로 동일).
`prep_runs.py` 의 `LIGAND_GROUPS` 가 00-Hopt 스텝 생성 자체를 막는다
(안 막으면 `hopt_poscar()` 가 분자의 실제 H 만 풀어 **분자를 찢는다**).

⚠ `make_100slab.py` 의 리간드 코드는 `if reconstruct:` 블록 안에 있다 — `--ligand` 만 주면
**Cl 이 조용히 0개**. 이제 명시적 에러로 막아둔다.

⚠ `slab_interior()` 는 **heavy(In/As)만** 으로 창을 잡아야 한다. 리간드까지 넣으면
아세테이트·MA 가 평균에 섞여 전 셀이 게이트에서 탈락한다.
⚠ 중앙 평탄부 **σ 는 창 폭이 벌크주기 이상일 때만 신뢰**한다 — 좁으면 표본부족으로
우연히 작게 나온다(6L 3.7 meV vs 8L 26.6 meV 비단조가 그 증거).

## 결과 요약 → [[inas_facet_ipea_results]]
