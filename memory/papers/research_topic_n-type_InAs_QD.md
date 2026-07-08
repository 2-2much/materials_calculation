---
name: research-topic-n-type-inas-qd
description: 사용자의 주 연구 주제 — InAs 콜로이드 양자점(CQD)의 intrinsic n-type 특성
metadata: 
  node_type: memory
  type: project
  originSessionId: 0e16a188-9ed8-4129-bd09-e65e656e3805
---

사용자(정재관, KAIST)의 주 연구 주제는 **n-type InAs 양자점(CQD/NC) 도핑**.

특히 관심 초점: **X-type 리간드(halide, thiolate, carboxylate)로 합성하고 p-type dopant를
넣지 않았을 때 InAs CQD가 항상 n-type으로 나오는 현상(intrinsic n-type)의 기원.**

핵심 이해: intrinsic n-type은 **표면 donor-like 결함 / In-rich(양이온 과잉) 표면**이
Fermi level을 CBM 근처로 pin시켜 표면 전자 축적층을 만드는 데서 기원. NC는 표면적이 커서 증폭됨.
리간드·As전구체 종류와 무관하게 robust n-type이며, p-type으로 뒤집으려면 리간드 조정이 아니라
격자 내 치환형 억셉터(Zn_In, Cd_In) + donor state passivation이 필요.

관련 논문 폴더(PDF): `n-type InAs QDs/`
상세 분석 노트(single source): `~/papers/memory/paper_notes/n-type_InAs_QDs.md`
논문 분석 인덱스: `~/papers/memory/paper_notes/README.md`
주요 논문: Yoon et al. Sci.Adv.2023(환원제로 극성 제어), Asor&Banin AFM 2021(Cd p-doping),
Song&Jeong Nat.Commun.2018(리간드로 준위 0.4eV tuning, 극성은 항상 n-type).

관련 계산 배경: [[feedback-save-notes]]. DFT 공백 — intrinsic n-type의 donor 결함
(In-rich/As vacancy)의 formation energy/transition level 계산은 아직 문헌에서 미수행 (기회 지점).

---

**↔ DFT 계산 (materials 프로젝트, cross-link)**: 위 "DFT 공백"을 실제로 메우는 계산은 materials 저장소에서 진행 중.
- 최상위 목표 메모리(동기화 사본, 어느 서버든): `~/materials/memory/materials/cqd_ntype_origin_goal.md`
- materials 세션의 live auto-memory: `~/.claude/projects/-home-jaegwan97-materials/memory/` (cqd_ntype_origin_goal, incl3_cl_as_in_unbound, defect_states_02_clpassv 등)
- 요지: InAs (100)/(110)/(111) 표면을 X-type(Cl / InCl3) passivation한 구조 reference로 point defect 계산.
  판정기준 = charge transition level(CTL, CBM 근처 shallow donor?) + μ-diagram(In-rich/Cl-rich).
  핵심 donor 후보: As_In(double donor), In_i(shallow donor), Cl_i/Cl_As(halogen donor).
