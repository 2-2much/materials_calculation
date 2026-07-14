---
name: kp_slabcc_nacl_reproduction
description: "Komsa-Pasquarello NaCl Cl-vacancy(q=+1) 형성에너지 재현 프로젝트 — 입력 준비 완료, kohn 이전 중"
metadata: 
  node_type: memory
  type: project
  originSessionId: 7d923485-159f-4194-86b4-f3459f46a236
---

**KP(PRL 110,095505,2013) NaCl(001) Cl-vacancy q=+1 형성에너지 재현** (slabcc 검증용 toy).
위치: `33-inAs/__Functional_Validation__/11-Surface-defect_TOY-model/KP_slabcc_reproduction/`.

목표/판정: 보정 전 E_f는 진공두께 의존(case01 c=22.64Å vs case02 c=56.60Å), **보정 후 두 값 수렴**(~0.1eV)하고 KP surface **1.89 eV** 근방이면 성공. 공식 `E_f=E[q+1]−E[pristine]+½E[Cl2]+q·VBM_pristine+E_corr` (q=+1, ε_F=0, μ_Cl=½E[Cl2]).

구조: **archive_slabcc**(저자 SLABCC 테스트셋)의 defect CHGCAR에서 72Na/71Cl 추출, pristine은 vacancy Cl 되채움(0.5,0.5,0.375 / 0.15 = charge_position 일치). `build_structures.py`.

설정(**CKT_PRB와 동일 footing** → Cl2 참조값 재사용): POTCAR Na_pv 19Sep2006+Cl 06Sep2000(`2.POTPAW.PBE.64.RECOMMEND`), ENCUT=262.5, PREC=Normal, GGA=PE, ISMEAR=0/SIGMA=0.05, **ISPIN=1**(neutral defect 홀전자지만 Δρ만 씀), 1-shot(NSW=0), **LVTOT+LVHAR 둘 다**(slabcc FAQ), LCHARG. NELECT: pristine 1008/q0 1001/**q+1=1000**. 병렬: 기약 k-점=3(P4mm, spglib확인)→**KPAR=3**, Γ 3×3×1. Cl2=½·(−3.730436)=−1.865218 eV(CKT값 재사용, 교차검증용 Cl2/ 준비). `generate_inputs.py`.

slabcc: 저자 `archive_slabcc/0{1,2}/_test_/` 재실행값 case01 +0.5575 / case02 −0.1736 eV = 참조 일치(파이프라인 검증됨). 우리 실행 후 `case0X/slabcc/`에서 우리 LOCPOT/CHGCAR로 재실행. 분석 `analyze_formation_energy.py`(CKT 로직 재사용). 상세는 폴더 README.md.

상태(2026-07-14): 입력 7종 완비. tgm-master g2에 잡 제출했으나 자리부족으로 **전부 취소**, 사용자가 폴더를 **kohn으로 직접 이동해 진행** 예정. kohn 손볼 것=run.sh의 partition·VASP BIN 경로(/TGM은 로컬), NCORE(코어수). KPAR=3 유지. ⚠slabcc 바이너리는 tgm-master 로컬(`~/bin/slabcc/bin/slabcc`)뿐 — kohn에 없으면 빌드/복사 또는 LOCPOT/CHGCAR 회수. 서버간 파일이동 원리는 [[server_fs_git_sync_scope]]. slabcc 일반은 [[slabcc_correction]], VBM 기준은 [[charged_defect_vbm_ref]].
