---
name: cqd_ntype_origin_goal
description: 연구 최상위 목표 — InAs CQD의 intrinsic n-type origin을 표면 point defect로 규명. surface defect 계산의 판정기준(CTL+μ-diagram)
metadata: 
  node_type: memory
  type: project
  originSessionId: be2e35fe-68fd-4740-909f-1cf615f9ce7d
---

**연구 목표**: InAs colloidal quantum dot(CQD)은 실험적으로(광학 UPS, 수송 FET) **intrinsic n-type**. X-type 리간드로 합성하며 모두 n-type. 이 n-type origin을 **표면 point defect** 계산으로 규명하는 것이 12-Surace-defect_calculation의 최상위 목적.

- 접근: InAs (100)/(110)/(111) 표면을 리간드 passivation한 구조를 reference로 point defect 계산.
- (110) 표면: 이전 = **Cl 리간드 passivation**(02-Cl-passv), 이번 = **InCl3 passivation**(03-InCl3-passv). InCl3는 반응성 좋아 분해→In 석출+Cl 잔류(문헌 근거)로 봄.

**판정 기준(중요)**: defect가 n-type origin이냐는 배치가 아니라 **charge transition level(CTL)** 로 결정 — (+/0),(2+/+) 전이준위가 CBM 근처 shallow donor인가. formation energy를 Fermi level 함수로 그리고, In-rich/Cl-rich 코너를 **μ-diagram(μ_In,μ_Cl)** 으로 표현해 지배 donor를 찾는다. X-type(halide) 표면=cation-rich+halogen-donor 조건이 donor defect 안정화 → 실험의 universal n-type과 연결.

핵심 donor 후보: As_In(anion-on-cation antisite=double donor), In_i(In 석출=shallow donor), Cl_i/Cl_As(halogen donor). 관련: [[incl3_cl_as_in_unbound]] [[defect_states_02_clpassv]]

---

**↔ 문헌 근거 (papers 프로젝트, cross-link)**: 이 DFT 규명의 실험/문헌 배경은 papers 저장소에 정리됨.
- 상세 문헌 노트(hohenberg, 어느 서버든 읽기 가능): `~/papers/memory/paper_notes/n-type_InAs_QDs.md` (논문 분석 인덱스: `~/papers/memory/paper_notes/README.md`)
- papers auto-memory(동기화 사본): `~/materials/memory/papers/research_topic_n-type_InAs_QD.md`
- 요지: Yoon Sci.Adv.2023(합성 환원제로 극성제어, n-type=표면 donor라 문헌인용만·DFT 미계산 ← 우리가 메울 공백), Asor&Banin AFM2021(In-rich 표면 donor→Cd로 상쇄 p-type), Song&Jeong Nat.Commun.2018(리간드로 준위 0.4eV tuning, 극성은 항상 n-type). 세 논문 모두 "표면 donor/In-rich → universal n-type" 수렴.
