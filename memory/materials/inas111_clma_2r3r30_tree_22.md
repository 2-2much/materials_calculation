---
name: inas111-clma-2r3r30-tree-22
description: 22-111ClMA_4BL_2r3R30_PBE-d (sham) — Cl:MA=3:1 완전 co-passivation 기준셀. ⚠host 갭이 0.053 eV 뿐(21번은 0.826)이라 결함 판정이 어렵다
metadata: 
  node_type: memory
  type: project
  originSessionId: f5c1c286-303c-4cef-b4bf-6b89adb7c5ce
  modified: 2026-08-26T09:00:00.000Z
---

2026-08-25~26 생성. **sham** `12-Surace-defect_calculation/22-111ClMA_4BL_2r3R30_PBE-d/`
(GitHub Defect_Package 클론. ⚠sham 은 GitHub 인증이 없었어서 kohn 에서 클론해 `.git` 째 전송했다.
이후 `gh auth login` + `gh auth setup-git` 으로 sham 에서도 HTTPS pull 정상.)

## 왜 만들었나
[[inas111_cl_ma_p4x3_tree]] (21번) 의 기준셀은 MA 가 하나 빠진 **노출 In 보유** 셀이었다.
여기서는 표면 In 12 개가 **전부** 배위된 **Cl : MA = 3 : 1** 을 기준으로 삼는다.

## 셀
`CONTCAR_C7_111MACl.vasp` (p2x2, Cl 3 + MA 1) 를 **a' = a+b, b' = −a+2b** (det = 3) 로 확장
→ |a'| = |b'| = √3 × 8.7538 = **15.1620 Å**, 60°, a 로부터 30° 회전 = 1×1 단위로 **(2√3 × 2√3)R30**.
면적 199.086 Å² (= 3 × p2x2, 21번 p4x3 과 **동일**). c = 32.2699 (21번 MA_i 와 동일), 진공 15 Å.
**pseudo-H 면 z = 7.500 Å 를 MA_i 와 일치**시켜 정렬 기준영역을 공유하게 했다.
조성 In_d 48 / As 48 / H.75 12 / Cl 9 / N 3 / C 3 / H 15 = 138, **NELECT 978**.
고정 36 (맨 아래 1 BL + pseudo-H). 표면 In: In37/38/39 = MA, In40~48 = Cl.
빌더: 21번 트리 `__build_2r3R30__/build_2r3R30.py`, 결함 빌더는 22번 트리 `make_defects_2r3.py`.

## 결함 16 종 (전부 중성, Cl 자리 vs MA 자리 대비로 짝지음)
In47 = Cl 보유(Cl8=#116), In37 = MA 보유(N1=#118), As47(#95) = MA 자리와 접한 최상단 As,
As41(#89) = 이웃이 전부 Cl 인 최상단 As.
As_In_1/2 · V_In_1/2 · Cl_As · Cl_MA · V_Cl · V_MA · V_Cl-V_In · V_MA-V_In ·
V_As_1/2 · V_MA-As_In · V_Cl-As_In · In_As_1/2
⚠ **V_In_1 은 남은 Cl 을 제자리에 뒀다**(공공은 As 3 개에 둘러싸인 양이온 자리라 음이온성 Cl 을
넣으면 불리). **V_In_2 는 MA 의 N 을 공공 중심에** 넣었다(21번 V_In-MA_i 에서 N–As 2.01 Å 결합 확인).

★ **21번과 조성이 같은 4 종**(교차검증점): V_MA ≡ 21 pure · V_MA-As_In ≡ 21 As_In ·
V_MA-V_In ≡ 21 V_In · V_In_2 ≡ 21 V_In-MA_i.

## 실행 (sham)
g1 **28 노드 × 8 코어 = 224 랭크**, NCORE=8 / NSIM=8, KPAR 1·1·4.
stage = 00_Gam-relax → 01_Spin-gam-relax → **02_G221-DOS 까지** (Band 는 사용자 지시로 제외;
KPOINTS_03 은 placeholder 이고 stages.yaml 03 은 주석).
case 당 ~2 시간. 잡 이름은 `PBE-` 접두사.
⚠ **바이너리는 6.3.2** — [[g1_node_vasp_binary_limit]]. 6.5.0 `.mpi.x` 로 17 잡이 2 초 만에 전멸했다.

## ★ 확정된 결과 (2026-08-26, 11/17 완주 시점)
- **pure 는 닫힌껍질, excess 0** — 세 가지 판정법이 모두 일치. `02_G221-DOS` 에서
  1~489 밴드 전자합 = 978.0000, 490~ = 0.0000, 갭 +0.0525 eV.
- **host 갭 = 0.0525 eV.** PROCAR 로 국소성을 봤을 때 갭 근처 최대 단일원자 무게가
  1.7~5.0 % 뿐(균일값 0.72 %)이라 **국소 준위가 없다** → [[host_gap_localized_state_trap]] 의
  함정은 여기 해당 없고 이 갭이 진짜다.
- ⚠⚠ **21번은 host 갭 0.826 eV.** 완전 패시베이션이 오히려 갭을 좁혔다.
  pure 의 band 488·489 가 단일원자 무게 5.0 / 4.5 % 로 표면 쪽에 치우쳐 있어
  **표면 유래 가전자 준위가 위로 올라와 갭을 좁힌** 것으로 보인다.
- 결함 16 종의 excess 는 **아직 판정하지 못했다** → 아래 참조.

## ★ 17종 q0 완주 결과 (2026-08-26)

수렴: `Cl_As` · `In_As_1` · `V_As_1` 셋은 **00 에서 NSW=400 소진**했으나 **01 에서 전부 수렴**
(max|F| 0.012~0.015 < EDIFFG 0.015). 나머지 14종은 00 에서 수렴. 전부 사용 가능.

**E_F 사다리** (`02_G221-DOS`, **슬랩 내부 정렬** z 7.0–10.5 Å, pure VBM = 0, pure 갭 0→0.0525):

| E_F−VBM(pure) | case |
|---|---|
| −0.109 | V_MA-V_In · Cl_MA |
| −0.093 / −0.085 / −0.056 | V_Cl-V_In / V_In_2 / V_In_1 |
| −0.017 / −0.005 / 0.000 / +0.009 | V_MA-As_In / V_MA / **pure** / In_As_1 |
| +0.296 / +0.464 / +0.477 | In_As_2 / As_In_2 / As_In_1 |
| +0.676 / +0.695 | V_As_2 / V_As_1 |
| +0.749 / +0.797 / **+0.894** | V_Cl-As_In / V_Cl / **Cl_As** |

★ **Cl_As 가 17종 중 가장 강한 도너** — E_F 가 pure CBM 보다 **+0.84 eV** 위. VB 홀 없음.
Cl(7e) ↔ As(5e) = **double donor(+2)** 예상과 방향 일치. 점유상태가 +1.06 eV 까지 뻗어
있고 무게는 표면 In(In38/In44/In35)에 3.8~8.4 % 로 **퍼져 있다**(균일 0.72 %) → **얕은 도너**.
대비: `V_Cl`·`V_As` 의 CB 전자는 단일 In 에 15~25 % 로 **국소**(비어 있던 In DB 자리).

★ 21번과의 교차검증 4점 전부 통과: `V_MA`≡21 pure(둘 다 캐리어 0) ·
`V_MA-As_In`≡21 As_In(둘 다 0) · `V_MA-V_In`≡21 V_In(각 트리에서 홀 최다).
★ **As_In 은 리간드가 있어야 도너다**: MA 를 떼면(`V_MA-As_In`) 캐리어 0,
MA 가 있으면(`As_In_1/2`) +0.47 도너. 21번의 "노출 In 이 도너 전자를 흡수" 와 같은 기전.

## ⚠ 캐리어 계수기의 유효 범위 (검증 완료)
"pure CBM 위 점유전자 / VBM 아래 홀" 계수기를 **21번(답을 아는 트리)** 에 돌려 검증했다:

| 21번 case | 알려진 excess | 계수기 |
|---|---|---|
| pure · As_In · MA_i | 0 | **0.00 ✓** |
| V_As_1 · V_As_2 | +3 | 1.00 ✗ |
| MA-As_In | +2 | 1.46 ✗ |
| Cl-As_In | +1 | 0.48 ✗ |
| Cl_i | −1 | 0.11 ✗ |
| V_In | −3 | 홀 1.40 ✗ |

→ **excess = 0 판정에만 쓸 수 있다**(0 은 정확히 0.00 으로 나온다). 0 이 아닌 값은
**하한**일 뿐 전하가 아니다. 22번의 1.30 / 1.48 / 1.00 같은 숫자를 excess 로 읽지 말 것.
(원인: 갭이 0.03~0.05 eV 뿐이라 결함 준위가 pure CBM 아래·VB 안에 걸친다.
21번은 host_gap 함정까지 겹친다 — 최저 비점유가 국소 In DB.)
**excess = 0 으로 확정된 22번 셀: pure · V_MA · V_MA-As_In · In_As_1.**

## ⚠ 남은 이상점 — In_As
`In_As` 는 In(3e)↔As(5e) = **−2(이중 억셉터)** 여야 하는데 `In_As_2` 의 E_F 는 **+0.296(도너 쪽)**.
CONTCAR 확인: `In_As_2` 의 치환 In 은 As 자리(In 이웃 3개, z 20.06)에 정상 안착 →
In–In 결합 준위가 CB 근처라 부분점유되면서 E_F 를 올린 것으로 보인다.
**E_F 위치 ≠ excess** ([[inas111_cl_ma_p4x3_tree]] 에 이미 있는 경고)이므로 모순은 아니나
**전하 판정은 하전 계산 없이 하지 말 것**. `In_As_1` 은 치환 In 이 1.66 Å 떠올라 **Cl 을 붙잡아**
(In–Cl 2.58 Å) 자기보상 → 캐리어 0.

## 도구 (트리 로컬)
`dos22.py`(17종 DOS 한 장 → `results/fig_dos_all17.png`) · `donor.py`(캐리어+국소성) ·
`states.py`(VBM 위 점유상태 나열) · `site.py`/`geom.py`(치환 자리 확인) · `check_convergence.py`
⚠ sham matplotlib 은 한글 폰트가 **.ttc 가변폰트뿐이라 로드 실패** → 그림 문자열은 영문으로.

관련: [[inas111_cl_ma_p4x3_tree]] [[inas111_slab_generation]] [[dos_2x2x1_tetrahedron_occ_overshoot]]
