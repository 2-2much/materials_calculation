---
name: scpc-debug
description: "VASP SCPC getgrid() 버그 해결, CKT+SCPC 비호환 확인, bare SCPC 정상 동작"
metadata: 
  node_type: memory
  type: project
  originSessionId: f56d495d-1a35-45ac-8dc1-5b4ea29d8aa3
---

## CKT + SCPC 비호환 (2026-06-23 확인)

SCPC는 3D Coulomb kernel 기반 계산을 전제로 보정량을 산출하고, CKT는 이미 2D truncated kernel을 사용. SCPC의 보정 전제가 CKT 계산과 맞지 않아 **함께 사용 불가**.

실제 증거: CKT+SCPC에서 Energy Correction = -7.7~-8.0 eV (비정상), bare+SCPC에서는 -0.87 eV (정상).

**How to apply:** charged slab defect 계산에서 둘 중 하나만 사용:
- CKT만 (KERNEL_TRUNCATION, post-hoc correction 불필요)
- 3D PBC + SCPC (Falletta correction)

## bare + SCPC 정상 완료 (2026-06-22)

경로: `.../02_vacuum_scan/bare/new_c_40A/As_In/q-1/03-SCPC/`
- Energy Correction: **-0.8675 eV**
- Potential Alignment: 0.063825 eV
- SCPC 56 cycles 수렴, SCF 54 DAV iterations, E = -207.4985 eV

## SCPC integer divide by zero 해결 (2026-06-22)

경로: `.../02_vacuum_scan/CKT/new_c_40A/As_In/q-1/03-SCPC/`

### 근본 원인
scpc.F의 `getgrid()` 함수가 `2^i * j + 1` 형태의 **홀수** 모델 그리드를 생성 (49, 65, 225). DL_MG multigrid solver의 cell-centered coarsening (N/2 정수 나누기)에서 한 차원이 0에 도달 → `set_mg_levels` (dl_mg_grids.F90:112)에서 `idiv %edi` (edi=0) → integer divide by zero.

### 디버깅 방법
1. stderr backtrace 주소 (0x2e0a786) → `addr2line` → DL_MG `set_mg_levels` 특정
2. `objdump -d` 디스어셈블리로 crash 지점 `idiv %edi` (edi=0) 확인
3. scpc.F 소스 (`/home/reduck96/VASP/6.2.0/`) → `getgrid()`의 `+1`이 원인
4. SCPC/MGX, SCPC/MGY, SCPC/MGZ — INCAR 정식 태그 (소스 line 88-90 및 6.6.0 바이너리 strings 확인)

### 해결: INCAR SCPC 블록에 짝수 MGX/MGY/MGZ 명시
```
SCPC {
     MGX = 48    (= 2^4 × 3)
     MGY = 64    (= 2^6)
     MGZ = 224   (= 2^5 × 7)
}
```
→ divide by zero 해결, DAV step 정상 진행 확인.

**How to apply:** SCPC 계산 시 항상 MGX/MGY/MGZ를 짝수로 지정. 값은 `int(0.60 * NGXF)` 근처의 `2^n × k` 형태.

### CKT+SCPC SCF 발산 (원인: 비호환)
CKT + SCPC + MGX/MGY/MGZ 적용 후 SCF 발산:
- DAV step 12에서 에너지 -254 → -495 eV 급락, rms 0.15 → 1.55
- scancel로 수동 취소 (job 54820)
- 원인: CKT(2D kernel)와 SCPC(3D kernel 전제)의 근본적 비호환

### 기타 수정사항
- `lhfskip` 바이너리: MPI 1 rank만 인식 → 주석 처리
- NCORE=32 (cascade2 노드 기준)
- 매 실행 전 z-diel.dat, SCPCOUT, MGSolver_* 삭제 필요 (누적)
