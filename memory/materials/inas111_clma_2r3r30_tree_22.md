---
name: inas111-clma-2r3r30-tree-22
description: 22-111ClMA_4BL_2r3R30_PBE-d (sham) — Cl:MA=3:1 완전 co-passivation 기준셀. ⚠host 갭이 0.053 eV 뿐(21번은 0.826)이라 결함 판정이 어렵다
metadata: 
  node_type: memory
  type: project
  originSessionId: f5c1c286-303c-4cef-b4bf-6b89adb7c5ce
  modified: 2026-08-26T01:40:49.876Z
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

## ⚠ 미해결 — 결함 excess 판정법
얇은 갭(0.053 eV) 때문에 21번에서 쓰던 방법들이 전부 실패했다:
1. host VBM/CBM 창 계수 → 창이 0.05 eV 뿐이라 결함 밴드가 스쳐 지나가 −0.3 같은 값
2. 01 (ISMEAR=0, Γ) 부분점유 → SIGMA=0.1 이 갭보다 커서 못 씀
3. 자체 스펙트럼 갭 탐색 → 문턱을 0.04 로 낮추면 우연한 틈을 잡는다(Cl_As 가 +6)
4. 거기에 충만/공백 조건을 추가 → **너무 엄격해져 21번의 알려진 답까지 "금속성"** 으로 만든다
→ 방법 확정이 먼저다. [[feedback_validate_diagnostic_first]]

관련: [[inas111_cl_ma_p4x3_tree]] [[inas111_slab_generation]] [[dos_2x2x1_tetrahedron_occ_overshoot]]
