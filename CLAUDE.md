# Materials Project

KAIST VASP DFT 계산 프로젝트. 서버 4대(kohn, sham, bloch, tgm-master)에서 공유.

## 사용 언어
- 한국어로 대화

## 폴더 구조
- 물질별 폴더: `33-inAs/`, `15-InP/`, `51-InSb/`, `cdS/`, `pbS/`, `si/`, `SiC/` 등
- 현재 주 작업 디렉토리: `33-inAs/__Functional_Validation__/`
  - `07-Bulk-defect_calculation/` — HSE06+PBE-d bulk defect (216-cell)
  - `11-Surface-defect_TOY-model/` — NaCl toy → InAs CKT 검증
  - `12-Surace-defect_calculation/` — InAs (110) surface defect 본계산

## InAs 계산 파라미터
- Functional: HSE06 (AEXX=0.25) + PBE-d (In 4d 포함)
- Lattice constant: HSE06+PBE-d 최적화 값 (a0 from Murnaghan fit)
- Chemical potentials: μ_As(A7)=-4.669549 eV, μ_In(metal)=-2.562344 eV, μ_InAs(bulk)=-7.718334 eV
- Charged defect correction: Falletta finite-size correction (z-direction), LOCPOT → cube via vaspkit
- Dielectric: ε_0=15.15, ε_∞=11.0 (bulk)
- Potential alignment: bulk-PBAND 방식 선호 (LOCPOT 대신)

## 계산 워크플로우 (config-driven)
각 계산 프로젝트에 `config/` 폴더:
- `defects.yaml` — defect 종류, charge states, POSCAR 경로, delta_atoms
- `stages.yaml` — 계산 단계 (relax → 1shot → band)
- `correction.yaml` — finite-size correction 파라미터
- `runtime.yaml` — SLURM 설정

## 논문 참조
- 논문 정리 노트 및 `papertools` CLI: `~/papers/`
- charged defect correction 논문 PDF: `~/papers/charged defect correction in slab/`

## 메모리 및 설정 동기화
- Claude Code 훅(`.claude/settings.json`)으로 서버 간 자동 동기화
  - **대화 시작(SessionStart)**: `git pull` → `memory/`를 각 Claude 프로젝트 메모리로 복사
  - **응답 완료(Stop)**: Claude 메모리를 `memory/`로 복사 → 자동 커밋+푸시
- 동기화 스크립트: `.claude/sync-memory.sh`
- 대상: `~/materials` + `~/papers` 하위 프로젝트 + `~/`(home) 프로젝트 메모리
- `memory/` 내 각 하위 폴더의 `.source` 파일이 Claude 프로젝트 경로와의 매핑을 저장
