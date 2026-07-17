---
name: defect_states_02_clpassv
description: 02-Cl-passv 6L-3x2x1 HSE06 defect state 정리(pure gap 1.19eV 기준) + bandos/zeroband 원자 인덱싱 규칙
metadata: 
  node_type: memory
  type: project
  originSessionId: 35c0f203-2148-495c-9517-4f0066cc3670
---

12-Surace-defect_calculation/02-Cl-passv_6L_3x2x1_HSE06 defect state 분석 (2026-07-03).
정리 결과: calc/__defect-states-summary__/ (README.md + 밴드/DOS png).

**기준**: pure slab HSE06 gap ≈ 1.19 eV (VBM=0 @Γ, CBM=+1.19 @Γ, gap 내 상태 없음).

**결론(각 셀 VBM 기준 상대값; cross-cell 절대비교는 bulk-PBAND alignment 필요)**:
- **As_In q0**: 깊은 gap 상태 없음. antisite As 성분은 VBM 아래 ~-0.4eV 공명 + CB. shallow/비자성.
- **Cl-As_In q0**: 자성 S=1/2. As36 국소 스핀분열 level — ↑점유 VBM위 ~+0.5eV, ↓비점유 ~+0.9~1.4eV. 안티사이트 라디칼. → ISPIN=2 필수.
- **Cl-As_In q+1**: 비자성. As36 비점유 level VBM위 +0.76~1.17eV(upper gap). (+1/0) donor.
- **V_Cl-Cl_As q0**: As자리에 Cl 치환(Cl_As, atom95=defect_atom_index)+passiv Cl공공. **gap 깨끗, 깊은 defect state 없음**. Cl_As 자체 준위(Cl 3p ~-6eV, Cl 3s -19.8eV)는 VB 깊이, 공여전자는 **CBM 위 전도띠 채움**(축퇴 n형). 비자성. ⚠초기 "gap 채우는 manifold/near-metallic" 서술은 오해였음.
  - ⚠**2026-07-17 정정: "shallow double donor(+2e)"는 틀림 → single donor(+1)**. Ground truth 3종 일치: (1) NELECT pure **744** → defect **739**, Δ=−5=ZVAL(As) 정확히, **Cl 개수 12→12 불변**(As 36→35). 즉 결함=표면 As 하나 빠지고 그 passivating Cl이 그 자리로 내려앉음. (2) NELECT 739=**홀수**, EIGENVAL(Gam) band369까지 occ=1.0, **band370 occ=0.500=전자 정확히 1개**(band371은 0). (3) ε(+2/+1)=−0.28eV(VBM 아래)→두번째 전자 안 나옴. Cl_As 단독이면 +2지만 **표면**(3배위) As자리 + 같은 결함이 passivating Cl 하나를 소모 ⇒ 순 **+1**.
  - band370은 국소준위 아님 **실증**: 02_G221-DOS 4k에서 0.329(Γ)→1.044→1.373→1.522eV로 **1.19eV 분산**(국소면 평평해야). IPR도 pure CBM과 동일.
  - Moss-Burstein 크기: **셀-내부 기준(정렬 불필요, 신뢰) E_F(tetra) 1.1064 − 결함셀 CBmin 0.3288 = 0.778eV**. 전자 1개/157.78Å² = 6.3e13 cm⁻²(≈5.8e20 cm⁻³)의 인공 고농도 탓 = **supercell artifact**(희박극한선 CBM에 앉음). k_F가 BZ의 77~82%라 band-edge m*(0.023) 아닌 **chord mass 0.275 mₑ**가 옳은 질량 → 2D 추정 0.55eV로 관측과 정합(m*=0.023 쓰면 6.6eV로 10× 과대).
  - ⚠**"진공정렬 LOCPOT"은 이 셀에서 ill-defined** — dipole 보정 OFF(INCAR에 `#IDIPOL=3` 주석)+비대칭 슬랩이라 **진공에 plateau가 없고 1.40eV에 걸쳐 ~0.155eV/Å 직선 기울기**(실측). 과거 "+0.86eV"(README) vs 재계산 "+0.70eV" 불일치가 이 정렬 모호성의 산물. **정렬 필요한 양은 semicore(In 4d) 등 셀-내부 기준으로 재도출할 것.** 관련 [[surface_defect_dipole_correction]]

**IPR 판별 지표 (2026-07-17 추가, PROCAR 원자료 검증)**: "이 charge state에 model-charge correction이 적용 가능한가"를 판정하는 기준. IPR = 원자별 투영weight의 역참여비, uniform = 1/96 = 0.0104.
| state | IPR | ×uniform | w[defect atom] |
|---|---|---|---|
| Cl-As_In q0 HOMO | 0.0946 | **9.2×** | 0.150 |
| Cl-As_In q+1 LUMO | 0.0696 | **6.7×** | 0.130 |
| pure LUMO (host CBM, 대조군) | 0.0128 | 1.2× | — |
| V_Cl-Cl_As q0 HOMO | 0.0128 | 1.2× | 0.0044 |
| As_In q0 LUMO | 0.0128 | 1.2× | 0.019 |
- **≥6× uniform = 국소 defect level → slabcc 적용 가능. ~1.2× = host 밴드 상태(PHS) → 어떤 model-charge 보정도 범주 오류.**
- 보조 지표 **E_relax**: 0.28~0.37 eV(국소) vs 0.01~0.05 eV(밴드류)로 10배 이산 갭. 전하가 host 밴드로 가면 반응할 국소 준위가 없어 이완이 사라짐.
- ⚠**As_In ≠ V_Cl-Cl_As** (뭉뚱그리지 말 것): V_Cl-Cl_As q0는 CBM 위 점유 **축퇴 n형**(→ CB에 캐리어 공여, n-type origin 후보; Moss-Burstein 크기는 위 셀-내부 기준 0.778eV). As_In q0는 **축퇴 n형 아님** — HOMO=VBM+0.13, gap 깨끗, donor 성분은 **비점유** CB(+1.58/+1.75eV, w≈0.10-0.13). 따라서 **As_In q+1 = donor ionization이 아니라 host VB 정공**(w[36]=0.0000). 둘 다 Gaussian 불가지만 물리가 다름.
- ⚠**"공명(resonant)" 용어 주의**: 위 기준으로 **As_In만 진짜 공명**(CB 밴드에 퍼진 w≈0.10-0.13). **V_Cl-Cl_As는 공명 아님** — Cl이 Cl⁻ 닫힌껍질로 완성돼 자체 준위가 전부 VB 깊이, gap 근처 기여 0.4%뿐 → **"닫힌껍질 이온성 도너"**(앉을 결함 궤도가 애초에 없어서 전자가 host CB로 감). 그리고 InAs는 a_B=349Å이라 속박 도너를 12.8Å 셀에 **표현 자체가 불가** → "도너준위가 CB 근처에 안 보임"은 정상이며, 이 셀에선 공명 vs 1.4meV 속박을 **구별 불가**. 상세: [[shallow_donor_inas_supercell_limit]]
- V_Cl-Cl_As "(+1/0) CTL"은 결함준위 이온화가 아니라 **CB 전자 제거(Burstein-Moss band-filling)** → gap 내 CTL로 보고하면 안 됨(삭제 대상). 관련: [[slabcc_delocalized_defect_policy]]

**도구 인덱싱 규칙(중요, 서로 다름)**:
- `zeroband.py`(03_Band): POSCAR **1-based**. proj 예 `--proj "36 tot"`, orbital `tot/s/p/d` 지원. `--fermi <E> --ylim lo hi --spin 1|2 --colors`.
- `bandos dos`(02_G221-DOS, ~/bin/hohen_bin/bandos): **0-based** (POSCAR N → `N-1` 전달!). 예 antisite As(POSCAR36)=proj `35`. 인자 `key=value`: `proj="35 tot" xlim="-1,3" ylim="-6,6" line="r,b" filename=out E0=<abs>`. 기본 E0=Fermi.
- DOS는 ISMEAR=-5+2×2×1 → gap 내부 tetrahedron 삼각형 아티팩트. defect level 판정은 밴드(zeroband) 우선.

관련: [[surface_defect_spin_screening_full]] [[vclclas_atom95_fatband]] [[surface_defect_1shot_band_workflow]]
