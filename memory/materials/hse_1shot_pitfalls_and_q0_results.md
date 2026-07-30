---
name: hse-1shot-pitfalls-and-q0-results
description: HSE 1shot 파이프라인의 조용한 실패 3종(밀도 리밋사이클·마지막값 읽기·NELM 소진)과 (100) q0 첫 결과
metadata: 
  node_type: memory
  type: project
  originSessionId: 1d14f4a1-4e13-4ddd-a483-26f07c486890
  modified: 2026-07-30T00:19:23.114Z
---

InAs (100) p(4×4) HSE06+PBE-d, 06 트리. 2026-07-29~30.

## ⚠조용한 실패 ① 밀도 리밋사이클 — 에너지는 수렴하는 척한다

`Cl_i-In` (NELECT 1239, 홀수), `ALGO=Damped`, HSE 단계까지 도달했으나:

```
DMP:  99   E=-722.469225   dE= +1.38e-04   rms= -0.35679
DMP: 100   E=-722.469780   dE= -5.55e-04   rms= -0.37107
DMP: 101   E=-722.469686   dE= +9.42e-05   rms= -0.35512   <- |dE| < EDIFF !
DMP: 102   E=-722.470277   dE= -5.92e-04   rms= -0.36916

|dE| 구간평균  0.0046 → 0.0111 → 0.0028 → 0.0014 → 0.0007 → 0.0003  (감소)
rms          -0.36 ↔ -0.37 왕복, 101 스텝 동안 전혀 안 줄어듦
```

**`dE` 는 줄어드는데 전하밀도 잔차 `rms` 가 얼어붙는다.** 부호가 ∓ 로 번갈아 뛰므로
`+` 쪽 스텝에서 `|dE| < EDIFF` 가 성립해 **VASP 가 rms=0.36 인 상태로 "수렴" 을
선언하고 에너지를 쓸 수 있다.** 단순 발산보다 위험하다 — 검출 지표는 `dE` 가 아니라
**`rms` 의 하강 여부**다.

`Cl_In` 이 죽었던 지점과 다르다: 그때는 rms 0.96 고정 + **PBE 단계**(E≈-753)에서 못
나옴 → MKL 크래시. `ALGO=Damped` 는 HSE 단계(E≈-722)까지 데려가지만 완주는 못 했다.

원인 추정: **홀수 NELECT + `ISPIN=1`**. `00` 단계는 설계상 비자성이라 E_F 에 반쯤 찬
상태를 강제한다(= half-metal). 단 홀수 자체가 판정자는 아니다 — `V_In`(1219, 홀수)은
1 스텝에 통과. 처방 후보: `SIGMA` 0.1→0.2 / `00` 을 홀수만 `ISPIN=2` / `AMIX` 0.4→0.2.

## ⚠조용한 실패 ② collect_energies 는 스테이지의 "마지막" 값을 읽는다

`pure` 만 `NSW=200` full relax 로 먼저 돌았고 나머지는 `NSW=0` 1shot 이었다.
`collect_energies.py`(`parse_last_toten`)가 마지막 값을 읽으므로 **pure 기준점만
이완된 값**이 들어가 `E_f = E(defect) - E(pure)` 가 전부 **+36.3 meV 계통 편향**됐다.
"pure 의 첫 이온스텝 에너지를 1shot 기준으로 쓰면 된다" 는 계획은 **자동으로 일어나지
않는다.** 해결 = pure 를 나머지와 **동일 조건**(`ALGO=Damped`/`NSW=0`)으로 재계산.

같은 함정이 `As_In` 에도 있었다(설정 변경 전 제출되어 `ALGO=Normal`/`NSW=200`/절연체
mixing 으로 full relax). **DFE 에 넣는 값은 전 결함이 같은 footing 이어야 한다.**

## ⚠조용한 실패 ③ NELM 소진 방어가 없다

`NSW=0` 에서 SCF 가 NELM 을 소진해도 VASP 는 정상 종료하고 에너지를 쓴다.
`run_case.sh` 의 `stage_finished()` 는 `"General timing"` 만 grep 하고,
`collect_energies.py` 는 수렴 플래그를 기록하지 않는다. 검사법:

```bash
grep -c "aborting loop because EDIFF is reached" OUTCAR   # == 이온스텝 수 여야 정상
```

## 미해결 — pure 의 ISPIN=1 대 ISPIN=2 가 +12.78 meV

동일 기하(0.00e+00 Å)에서 `00`(ISPIN=1) −719.05766 vs `01`(ISPIN=2) −719.04488.
**스핀 쪽이 높아 변분적으로 비물리.** mag=0.0000000, NBANDS 752·FFT grid·ISTART/ICHARG
동일, `01` SCF 잔여오차 ~0.1 meV(감쇠비 0.551)로 **SCF 미수렴 가설 기각**.
(110) 전례는 −0.6 / +0.0 meV. 원인 미상. 새 1shot 과 대조할 것.
보존 위치: `calc/pure/__fullrelax_ALGO-Normal_NSW200__/`

## (100) q0 첫 결과

```
        00(ISPIN=1)    01(ISPIN=2)    스핀안정화      비고
As_In    -721.62525     -721.62548     -0.2 meV      mag 0, 짝수(1224). full relax 13스텝 EDIFFG 도달
V_In     -714.51596     -714.58635    -70.4 meV      자성! 홀수(1219), 1shot
pure     -719.02135(첫) -719.05766(끝)               00 만 20스텝 이완, dE_relax 36.3 meV
```

**(100) pure 이완 36.3 meV 는 (110)의 3~9배**(02 4.2 / 04 10.9). `As_In` 의 같은 값과
빼면 E_f 에 남는 몫이 나온다 → [[hse_relax_vs_singlepoint]]

관련: [[hse_slab_scf_settings]], [[inas100_worktree_on_kohn]], [[energy_column_sigma0_vs_toten]]
