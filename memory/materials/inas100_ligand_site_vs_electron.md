---
name: inas100_ligand_site_vs_electron
description: "(100) dimer 표면 리간드 규칙 = (뺄 전자 1, 채울 배위자리 2). Cl 단독은 자리를 하나 비운다. 그리고 dimer당 Cl 개수 0/1/2 = 도너/절연/억셉터 (EIGENVAL로 확인)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6bd9a490-f3df-4628-92f5-b8648d42fb89
  modified: 2026-08-06T01:15:05.899Z
---

2026-08-06. ChemComm 2017(Ko·Yoo·Kim, 같은 연구실) 본문+SI Fig.S3 원본 확대 + 내
`05-100Cl_8L_p4x4_PBE-d` CONTCAR/EIGENVAL 직접 확인으로 확정.

## 규칙: 리간드는 **두 개의 수**를 가진다

InAs(100) In-dimer (2×1) 단위(표면 In 2개, DB 전자 3개)가 요구하는 것 =
**(뺄 전자 1개, 채울 배위자리 2개)**. dimer σ결합이 전자 2개를 먹고 자리는 안 먹기 때문.

| 리간드 | 뺏는 전자 | 채우는 자리 | 판정 |
|---|---|---|---|
| **Cl (monodentate, X-type)** | 1 | **1** | ⚠ 자리 1개 남음 |
| acetate (bidentate, X-type) | 1 | **2** | ✓ |
| Cl + MA (X + L-type) | 1+0 | 1+1 = **2** | ✓ |

**Fig.S3 원본 확인**: (a) lp(100) acetate는 카복실레이트가 표면 In **두 개를 다리처럼 잇는다**
(μ₂ bridging). (b) cp(100)은 dimer 한쪽에 Cl, 다른 쪽에 MA의 N → **표면 In이 하나도 안 남는다.**

⇒ **내 (100):Cl 표면은 cp 표면의 "V_MA 100%" 상태다.** 전자수지는 맞지만(갭 0.858 eV 열림)
dimer당 3배위 In이 하나씩 남고, 그 빈 궤도들이 [[inas100_dimer_row_chain]]의 1D 사슬 = **CBM**.

## ★ dimer당 Cl 개수 = 도핑 손잡이 (0/1/2 = 도너/절연/억셉터)

EIGENVAL(Γ, PBE-d, `00_Gam-relax`) 점유수가 전자수지 예측과 **정확히** 일치:

| 계 | Cl/dimer | 수지 | 실제 |
|---|---|---|---|
| pure | 1 | 2+1=3 ✓ | 갭 0.858, 부분점유 **없음** |
| **Cl_i-In** | **2** | 4>3 → −1e | VB상단 0.974/0.857/0.679 = **hole 정확히 1개** → **단일 억셉터** |
| **V_Cl** | **0** | 2<3 → +1e | 갭준위 **half-occupied**, VBM+0.48 eV → **단일 도너** |
| Cl_In | — | — | 빈 갭준위 VBM+0.54 (배위 못 한 In 2개) |
| As_In | — | — | 갭 깨끗, 준위 없음 |
| In_i_sub | +1e | 도너 | 갭준위 half-occupied, VBM+0.45 |

⚠ **Cl이 많아서 n형이 아니라 Cl이 모자라서 n형이다.** 벌크·(111)의 "할로겐=도너" 직관과
(100) dimer 표면에서는 **부호가 반대**. → [[cl_shallow_donor_no_gap_state]] 와 별개 기제.
(준위 위치는 Γ-only·PBE-d·슬랩 구속이라 정량 신뢰 금지. **점유수 패턴만** 견고하다.)

## 이완이 보여주는 것: 세 결함이 사실 같은 반응(빈 자리 메우기)

| 결함 | 이완 결과 (Å) |
|---|---|
| Cl_i-In | 여분 Cl이 맨 In에 붙음. **dimer 2.90 유지 + Cl 2개/dimer** |
| **Cl_In** | Cl이 V_In 자리에 **안 들어간다**. 옆 In에 **InCl₂(2.38+2.55)** 로 붙고 In 2개가 As 2개(2.98/3.01)만 남은 알몸이 됨 |
| As_In | As가 맨 In 자리로. **As–As 2.50 ×2**, Cl 없음, dimer 없음 |

## ⇒ co-passivation이 막는 것 / 못 막는 것

MA는 **L-type(0e)** 이므로 전자수지를 못 바꾼다. 바꾸는 건 **빈 배위자리**뿐.

- **억제됨**(착지점 필요): Cl_In, Cl_i, 표면 As_In, In_i_surf → E_f가 **E_bind(In–MA)만큼 상승**
- **그대로**: **V_Cl**(Cl 자리는 여전히 Cl 자리, dimer+MA도 전자 1개 잉여 → 도너), In_i_sub

⇒ cp 표면에서는 결함 동물원이 5종 → 사실상 **V_Cl + In_i_sub 2종**으로 줄고
n형 기원이 **X-type 리간드 결손 하나**로 좁혀진다. Cl-only보다 강한 서사.

## ⚠ 그래도 Cl-only를 버리지 말 것

1. cp(100)은 **MA 피복 50%**(dimer 간격 4.38 Å) — cp(111) 25%보다 입체장애가 훨씬 나쁘다.
   논문 자신의 결론(cp(111) 130 > cp(100) 102 → 정사면체)이 곧 **"(100)은 co-passivation이
   잘 안 되는 면"**. 실제 QD의 (100) 면은 Cl-only에 가까울 수 있다.
2. 리간드 교환·HCl 처리·필름화하면 L-type이 먼저 떨어진다(Hens 2021 ammonium salt 이탈,
   Oh 2024). **Cl-only = 아민이 벗겨진 소자 상태의 극한.**

⇒ 둘 중 택일이 아니라 **μ_MA(또는 θ_MA) 축을 하나 더** — 2021 Nat.Comm. Fig.4b(γ vs μ_Cl)의
2D 확장. "아민 활성도가 떨어지면 cp→lp, 빈 자리 생김, 도너 싸짐"이 논문의 그림.

## ⚠ 논문 수치 인용 시 함정

E_stab **44(acetate) vs 102(Cl+MA) meV/Å² 는 저수지가 다르다** — acetate는 `AA-H + ½H₂`,
halide는 `½Cl₂ + MA`(SI 식 그대로). ½Cl₂는 도달 불가 상한이라 halide 쪽이 부풀려져 있다.
"co-passivation이 2배 좋다"를 그대로 인용 금지. (bare: b110 28 < b111 55 < b100 78;
비다이머 150% coverage lp = 24로 steric에 짐; lp111(2×2) 53, cp111(2×2) 130.)

## 다음 계산 (권고 순서)

1. **(100):Cl + MA 기준면 1개** — 기존 p(4×4) CONTCAR의 **맨 In 8개에 MA 8개만 얹기**.
   Cl·dimer·pseudo-H 전부 재사용, PBE-d relax 1회. 확인 3개:
   갭 / **CBM의 1D 성격이 사라지는가**(`E_Y−E_Γ` 지금 +0.39 eV, `chain_analysis.py`) / E_bind(In–MA).
   ← 지금 (100) CTL·band-filling이 전부 **표면 사슬 밴드 기준**으로 재어지는 게 최대 리스크.
2. 그 위에서 Cl_In/As_In/Cl_i/In_i/V_Cl 재계산. 예측: 앞 넷만 +E_bind(MA) 상승, V_Cl 불변.
   Cl이 MA를 밀어내면 그것도 결과("아민 활성도가 도너 농도를 제어").
3. acetate(bidentate) 버전은 2024 JACS 직접 비교용으로 나중에.

관련: [[inas100_dimer_row_chain]] [[inas100_mu_cl_convention_cl2]]
[[inas100_as_in_termination_competition]] [[cqd_ntype_origin_goal]] [[in_i_shallow_donor_cl_deactivation]]
문헌: `~/papers/memory/paper_notes/InCl3_passivation_QnMSG.md` (2026-08-06 절)
