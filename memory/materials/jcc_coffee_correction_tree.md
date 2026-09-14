---
name: jcc_coffee_correction_tree
description: "11-CoFFEE_correction — h-BN 6x6 하전결함에 FNV형 모델보정. 셋업에서 실측으로 확정한 것들"
metadata:
  node_type: memory
  type: project
---

**트리**: `~/materials/__JCC_Reproduction__/11-CoFFEE_correction` (bloch). 02·04·05 의 같은
L_z 계열에 CoFFEE 보정을 얹어 04/05 그림의 **네 번째 곡선**(무보정/JCC/SEJM 다음)을 만든다.
2026-09-14 입력 **24개**(VN/CN x Lz 12·18·24·30 + alpha 1~10) 생성·검증 완료, 계산은 사용자가 제출.
재현이 목적이라 ecut/sigma/width 스캔은 넣지 않는다.

**구조**: `<defect>/Eper/Lz*`(α=1, L_z 마다) + `<defect>/Eiso/alpha.*`(결함마다 1벌).
★ **E_iso 는 L_z 무관** — α 스케일링이 셀만 키우고 슬랩(Width/ε/σ)은 절대값 고정이라
극한이 '고립 슬랩' 하나다. 그래서 α 계열을 L_z 마다 돌릴 필요가 없다.

★**유전 프로파일은 `Gaussian` 이다 — `Slab` 이 아니다.** User Guide §4-3: "두께를 정의하기
애매한 그래핀·**단층 BN**용". 실측 근거: Slab 으로 두고 w=2.5/3.33/5.0 A (적분량 보존하도록
eps 재조정) -> E(a=6)-E(a=1) 이 +0.005/+0.020/+0.062 eV 로 **크게 달라진다**. 모델 전하
sigma=1 A 가 슬랩 두께와 비슷해 '두께는 게이지' 논리가 깨진다. ⚠처음에 Slab 으로 짰다가
이 테스트로 잡았다.
- 프로파일 `eps(z)=1+A*exp(-(z-c)^2/2s^2)` (classes.py:745). **A 는 1 위로 얹히는 높이**.
- A 는 Kumagai 셀평균에 맞춘다: 면내 해석해 `A=(<e>-1)L/(s*sqrt(2pi))`, 면외는 `<1/e>` 수치해.
  h-BN: **A_par 9.4768 / A_perp 3.1428, sigma_eps 0.783 A**(Kumagai 도 h-BN 에 가우시안을 쓴다).
- ⚠**배포 MoS2 예제는 Centre(유전)를 alpha 에 무관하게 5.702 bohr 로 고정**하고 Centre_a3 를
  1/alpha 로 줄인다. 우리는 둘 다 셀 중앙 — 주기성 때문에 동등하고, **중요한 건 둘이 같은 곳에
  있다는 것**뿐(setup.sh 가 검사).

**실측으로 확정한 것 (h-BN 6x6, VN q=+1)**
- **Ecut = 8 Ha 가 수렴**. Ecut 8/20/40 이 α=1 에서 1.3616/1.3613/1.3612 — **0.3~1.0 meV**.
- **정렬 부호 s = −1**. `corr(V_q − V_p , V_model) = −0.9989` (VASP LOCPOT 규약이 CoFFEE
  모델과 반대). ΔV = −0.0087 eV 이고 **창 ±1~4 Å 에서 4자리까지 동일**, 잔차 기울기
  +4.4 meV/Å → 유전 슬랩 배치(Width/Centre)가 맞다는 뜻.
- ★**정렬 기준을 중성결함 대신 무결함 호스트로 쓴다**. (V_q−V_0)+(V_0−V_p) = V_q−V_p 이므로
  호스트 한 번으로 CoFFEE 의 두 정렬항 합이 나온다(= 원래 FNV 형태). L_z 계열에 중성 결함이
  없어서 택한 길인데 02 에 q0 가 전 L_z 에 있어 짝이 완전하다.
- **α 계열 모양**: α=1 부터 1.3616 · 1.3378 · 1.3459 · 1.3590 · 1.3713 · 1.3820 · 1.3986
  (α=1,2,3,4,5,6,8). ⚠**α≥2 는 단조 증가인데 α=1 만 벗어난다** — α=1 은 점근 전개가 가장
  나쁜 셀이라 정상이고, E_per(α=1) 은 외삽에 안 쓰이고 그 셀의 정확한 값으로 직접 쓰인다.
  **E_iso 피팅에 작은 α 를 넣지 말 것.**
- ⚠**doubling 증분이 커진다**(2→4 +21, 3→6 +36, 4→8 +40 meV) = 아직 로그 영역.
  E_iso 가 과소평가된다(MoS₂ 에서 α상한 80→10 이면 −103 meV). 단 **전 L_z 공통 상수**라
  '발산이 지워지는가' 판정엔 무영향, 절대값 비교에만 밴드로 붙일 것.
- **비용/메모리** (bloch 6랭크): α=5 10 s · 6 20 s · 8 54 s. rank0 RSS ≈ `0.2 + 6.3e-3·α³ GB`
  → α=12 11 GB, α=14 17 GB. 노드 31 GB 라 **α=14 가 한계**. 그래서 run_coffee.sh 는 순차 실행.
  SLURM 은 `SelectTypeParameters=CR_CORE`·`DefMemPerNode=UNLIMITED` 라 12태스크=노드 독점.

유전율 값과 그 환산 근거는 [[hbn_dielectric_for_coffee]]. 코드 상태는
[[coffee_setup_and_arange_bug]]. 관련: [[coffee_vs_slabcc_eiso_target]], [[jcc_dHf_lz_validation]]
