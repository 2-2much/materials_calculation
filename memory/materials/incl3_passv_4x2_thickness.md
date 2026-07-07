---
name: incl3_passv_4x2_thickness
description: "03-InCl3-passv 4x2 슬랩 셀 구성(위 InCl3/아래 pseudo-H, 6층 11.3Å) + 두께 6L→5L 검토 진행상태·판단기준"
metadata: 
  node_type: memory
  type: project
  originSessionId: 7255c170-ba11-48f2-b865-733c28c90159
---

`12-Surace-defect_calculation/03-InCl3-passv_6L_4x2x1_PBE-d/inputs/pure/POSCAR` 셀 구성(2026-07-07 확인):
- **p(4×2), a×b = 17.51 × 12.38 Å, c = 30.26 Å, 총 128원자**
- **위(관심 표면, z≈20.5~22.8): InCl3 passivation** = In_L(4) + Cl(12), 비율 1:3
- **InAs 6 atomic layer** (z 7.66~18.57, 층간 ~2.18 Å, 두께 **11.3 Å**)
- **아래(인공 종단, z≈6.2~6.4): pseudo-H** = H1.25(As 댕글링용) + H.75(In 댕글링용), 8+8
- 하단 ~2층 Selective Dynamics로 고정(F F F)
- 이전 kohn 계산은 Cl-passivated **p(3×2) 6L**(두께 ~11 Å). 이번엔 lateral을 4×2로 키움.

**진행상태: 두께 6L→5L 축소 검토 중(미결정).** lateral 확장(+33% 원자)을 5L(≈9 Å)로 되돌려 옛 3×2-6L 대비 +11%로 비용 회수하려는 동기. (4/3)×(5/6)=1.11.

**판단기준(→ [[surface_defect_thickness_check_policy]]):** 두께는 lateral과 독립 수렴축이므로 5L을 가정으로 채택 금지. 위/아래 종단이 달라 슬랩 가로 dipole 있음 → 하전 결함 보정(bulk-PBAND 정렬)은 내부 bulk potential **plateau** 필요. 5L 채택 전 PBE-d로 pristine 5L vs 6L 비교: ①InCl3 표면에너지 ②LOCPOT planar-avg 내부 plateau 생존 여부(가장 결정적) ③표면층 In/As buckling. 5L이 ①③에서 6L을 ~10–20 meV 내 재현+②plateau 살아있으면 채택, 아니면 6L 유지. (110)은 non-polar·층당 stoichiometric이라 5L도 polarity/termination 문제 없음. 5L 생성 시 표면 2개는 그대로 두고 **내부 bulk 한 층만 제거**.

**bare(110) 기준선 실측(2026-07-07, `10-Primitive-slab/00-Convergence_test_unitcell/01-thickness/02-bare-110`):** 두 수렴축이 속도가 다름이 데이터로 확인됨. ①표면에너지 γ는 6L에 수렴(4L 27.29→6L 27.79→8L 27.85→40L 27.29 meV/Å²). ②LOCPOT macro-avg(4.36Å창) 내부 중앙40% pk-pk는 4L 0.57 / **6L 0.53** / 8L 0.11 / 10L 0.025 eV → **plateau는 ~8–10L까지 미형성**. bare 6L(11.9Å)=결함슬랩 InAs 6층(11.3Å) 동일두께인데 내부 0.53eV 휨. 즉 "γ수렴≠plateau생존" 실증. 단 bare=댕글링 최악케이스라 passivated는 더 적은 층서 plateau→위 8–10L은 비관적 상한. 한계: 5L(홀수)·InCl3종단·비대칭dipole 데이터는 여기 없음(bare/H-passv 대칭). 결론: 이 데이터로 5L 채택 불가, 오히려 주의신호. 5L 판단은 실제 InCl3-passv pristine 슬랩서 macro-avg plateau(목표 내부 pk-pk≲0.05–0.1eV) 직접 확인 필수. planar-avg 스크립트: scratchpad/macro.py.

**두께 스캔 정합·유효성 확정(2026-07-07):** 이 계산은 surface defect formation E **가벼운 screening**(ENCUT 300, Gamma-only relax → 2×2×1 1-shot). 스캔 기본단위=**2×1 InCl3 슬랩**(gap 있음). ⚠1×1은 InCl2·metallic → 스캔에 쓰지 말 것. bulk-plateau 테스트는 light-screening에서도 **유효+오히려 더 중요**: plateau는 두께의 성질이지 정밀도의 성질 아님(ENCUT·k 낮아도 존재여부 불변), 싸게=얇게=깨지기 쉬운 영역이라 체크 더 필요. 유효조건은 "production과 같은 조건에서 재기"(self-consistency, 절대수렴 아님): **LOCPOT은 2×2×1 1-shot의 LVHAR(Hartree=정전퍼텐셜, XC제외)에서 읽을 것**(Gamma relax 전하 under-converged→ripple), dipole OFF 유지. scope: plateau 불량→정렬오차가 q에 비례해 charge state 간 상쇄 안 됨→charged transition level 순서 틀어짐. 반면 **중성 결함 E_f는 정렬 불필요→plateau와 무관하게 신뢰**.

**Step0 실측·정정(2026-07-07, 기존 2×1 6L LOCPOT=6×6×1/dipoleOFF/LVHAR):** ⚠**macro window 핵심**: (110) planar-avg V(z) 주기는 **1층=2.18Å**(2층 4.36Å 아님 — 연속 (110)면은 In+As 동일조성, glide만 다르고 x,y평균이 이를 지움). 창을 1.9~2.6Å 스캔하면 내부 잔차가 **정확히 2.18Å에서 급격히 최소**(=진짜 주기 증거). raw 진동이 ±9eV로 거대해 창이 조금만 어긋나도(grid반올림 2.25 vs 2.18) 큰 잔차 진동 남음→정수-grid 커널 쓰지말고 **fractional-width 커널**(macro.py 수정완료). **정확한 2.18Å 최적창 결과: 하부 plateau z9-15(L2-L4)=110meV/mean −4.72eV, z8.5-16(L2-L5)=200meV. 유일한 진짜 섭동은 top 1-2층(L6, z≈17-18, InCl3접함) dip(−5.4eV)** — 정렬기준영역 아니라 무관. **결론: 6L 하부 plateau(z≈9-15, ≈−4.72eV LVHAR)를 정렬기준면으로 충분. 6L OK, 7L/8L 불필요(선택).** dipole보정 무의미 여전(내부는 tilt아니라 평평, slope~0). 앞서 4.36Å창으로 낸 "331meV 진짜 비선형 섭동/6L부족" 결론은 **오류**(상단 dip이 내부로 번진 창 아티팩트)—폐기. 미확인 잔여: −4.72eV가 진짜 bulk값인지(thin-slab offset)이나, pristine·defect가 같은 하부plateau 기준쓰면 공통offset 상쇄→screening 2차. 중성 E_f는 정렬불필요라 지금 신뢰. macro.py(scratchpad): planar+macro(fractional win)+window스캔+선형fit.

관련: [[surface_defect_1shot_band_workflow]], [[adispersion_scan_pbed]], [[surface_defect_dipole_correction]]
