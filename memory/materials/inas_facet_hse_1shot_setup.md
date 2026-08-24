---
name: inas_facet_hse_1shot_setup
description: "04-Facet_IP-EA 의 03-hse-dipole 셋업 — a0 스케일 규약·HSE 벌크 참조를 왜 새로 돌리는가·LHFSKIP 은 sham 에 없다"
metadata:
  type: project
---

2026-08-24. `04-Facet_IP-EA/03-runs/<cell>/03-hse-dipole/` (sham). 도구 `04-tools/hse_prep.py`.

## a0 와 스케일

**정본 = kohn `09-Bulk-electronic_structure/README.md`** — 여길 먼저 볼 것.
`a0(HSE06 AEXX=0.27 + PBE-d) = 6.0982965656 Å` (Murnaghan BM, `01-Murnaghan-fit/
02-HF-mixing/PBE-d_HSE06_AEXX27`, **PRECFOCK=Normal footing**).

PBE-d 이완 기하에 **등방 배율** `s = 6.0982965656/6.189842 = 0.9852104`(≡ 메모리의
0.9852099996)를 **세 격자벡터 전부**에 곱하고 **분율좌표는 그대로**. 슬랩이라 진공도 같이
1.5% 줄지만 무해하다(25 → 24.63 Å). z 를 안 줄이면 pseudo-H 결합만 뒤틀린다.
⚠ **DIPOL 은 분율좌표라 등방 스케일에 불변** → 02-dipole 값을 그대로 재사용한다.
(실제 슬랩은 7자리 반올림 6.098297 로 스케일했다. 정본과 4.4e-7 Å 차 — 무시 가능.)

## ★ HSE 벌크 참조는 09 트리를 못 쓴다 — 새로 돌려야 한다

`ΔV_bulk = E(Γ15v) − V̄_bulk` 가 필요한데 09 의 `00-scf` 에는 **`LVHAR` 이 없어 LOCPOT 이
없다**. 게다가 그 셀은 **ENCUT=300**(a0 피팅과 맞춘 값)이고 primitive 2원자다.
ΔV_bulk 는 슬랩의 `V̄_slab` 과 빼는 양이라 **발판을 슬랩 쪽(ENCUT=400, PREC=Normal)** 에
맞춰야 한다. → `06-bulk_ref/HSE06_AEXX27` (conventional 8원자, Γ4×4×4, NCORE=1/KPAR=4/NBANDS=48).

**k 를 4×4×4 로 내린 근거(실측)**: PBE 대조에서 conventional 8×8×8 → 4×4×4 의
ΔV_bulk 차이가 **+1.3 meV** 뿐이다 (3.82583 → 3.82715, PREC=N).
HSE 는 비용이 k점 수의 제곱이라 8×8×8 은 못 쓴다.
교차검증: 여기서 나오는 직접갭이 **0.4485 eV** 근처여야 한다(09 기준값).

## ⚠ `LHFSKIP` 은 sham 의 어떤 바이너리에도 없다

`strings` 전수 검사 결과 sham `/TGM/Apps/VASP/VASP_BIN/` 의 **5.4.4~6.5.0 전 바이너리에서 0건**.
그 태그는 tgm-master 의 `vasp.6.5.1...lhfskip.std.x` **빌드 전용**이고 sham 엔 그 빌드가 없다.
INCAR 에 남겨도 **조용히 무시**되어 무해하지만, 그게 하던 "PBE 먼저 수렴 → HF 켜기" 는
안 일어난다. 필요하면 PBE pre-SCF 를 앞에 붙여 `ISTART=1` 로 이어받으면 같은 효과다.
→ [[hse_slab_scf_settings]] [[g1_node_vasp_binary_limit]]

## ⚠ HSE OSZICAR 첫 4스텝의 −1.3e4 eV 는 발산이 아니다

`ISTART=0` HSE 는 **초기 DFT 대각화 몇 스텝 뒤 HSE 로 전환**하면서 E 가 −1.37e4 → −93.8 로
점프한다(C1 에서 5번째 스텝). 그 전 스텝만 보고 발산으로 오판하기 쉽다.
판별: 전환 후 dE 가 단조 감소하는지 볼 것.

## INCAR 요지 (나머지는 PBE 02-dipole 과 **동일하게 유지**)

```
PREC=Normal · ENCUT=400 · LASPH=T · ISPIN=1 · ISYM=0 · ALGO=Normal
ISMEAR=0 SIGMA=0.05   ← ⚠ PBE 단계와 같아야 한다. 발판이 갈리면 PBE↔HSE 비교가 깨진다
LREAL=.FALSE. · EDIFF=1E-5 · NELM=200 · NSW=0 · ISTART=0 ICHARG=2
LVHAR=T IDIPOL=3 LDIPOL=T DIPOL=<02-dipole 값 그대로>
LHFCALC=T HFSCREEN=0.2 AEXX=0.27 PRECFOCK=F
```
`EDIFF=1E-5`: HSE SCF 는 1e-5 아래에서 스텝당 1%씩만 줄어 낭비고([[hse_slab_scf_settings]]),
IP 에 필요한 정밀도는 이미 넘는다.
`PRECFOCK=F`: 09 트리가 이미 검증 — 갭 차이 **0.02 meV**, 29k×24밴드 평균 +0.10 meV, 3.5배 빠름.
⚠ 단 **a0 를 Fast 로 다시 뽑으면 안 된다**(B0' 가 36% 튄다) — 고정 기하 전자구조에만 쓴다.

⚠ `WARNING: type information on POSCAR and POTCAR are incompatible` 는 종 alias
(In→In_d, H.75) 탓이고 PBE 런에도 똑같이 뜬다. **양성**.

관련: [[inas_facet_ipea_workflow]] [[inas_prec_normal_validation]] [[precfock_fast_policy]]
[[in_i_hse_port_02_04]] [[ncore_ace_zpotrf_small_cell]]
