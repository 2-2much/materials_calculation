---
name: scpc-debug
description: "VASP SCPC: CKT 비호환, getgrid 버그, bare SCPC 수렴 불완전(작은 셀+IN=1), 권장 설정 정리"
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

## bare + SCPC 수렴 불완전 (2026-06-23 분석)

경로: `.../02_vacuum_scan/bare/new_c_40A/As_In/q-1/03-SCPC/`
- Energy Correction: -0.8675 eV (SCPC cycle 54-56 수렴)
- Potential Alignment: 0.063825 eV
- SCPC 56 cycles, SCF 54 DAV iterations, E = -207.4985 eV

### 수렴 문제
- **rms(c) ≈ 0.01에서 정체** (정상: ~1E-4). EDIFF=1E-4 기준으로는 수렴했지만 charge density 미수렴
- SCPC cycle 10-11에서 Energy Correction이 -0.5 → +4.17 eV로 **폭등** 후 회복
- EDIFF=1E-4 도달로 54 step에서 종료되었지만 실질적 수렴 불충분

### 원인 분석
1. **셀 크기 부족**: in-plane 8.75 × 12.38 Å ← GitHub 권장 **15-20 Å 이상** 미달. 작은 셀에서 δρ가 셀의 큰 비율을 차지하고 boundary damping 영역이 defect과 겹침
2. **IN=1**: SCPC가 첫 DAV step부터 적용되어 초기 charge density 불안정 상태에서 큰 보정이 가해짐
3. **EDIFF=1E-4 너무 loose**: SCPC+SCF 동시 수렴에 불충분
4. **PREC=N, LREAL=A**: GitHub은 PREC=Accurate, LREAL=.FALSE. 권장

### SCPC 논문 근거 (Chagas da Silva et al., PRL 126, 076401)
- Non-SC SCPC (첫 iteration만)도 formation energy에 충분히 근접 (차이 ~0.05-0.15 eV)
- "this effect is typically limited and does not significantly affect the final results (e.g., formation energies)"
- Supplemental Material: boundary damping은 최종 결과에 큰 영향 없음 (Table S1)
- 즉, 현재 Energy Correction 값 (-0.87 eV)은 **대략적으로 신뢰 가능**하나 eigenvalue 정확도는 보장 못함

### 개선된 SCPC INCAR 권장 설정
```
PREC = Accurate    # (현재 N → 변경)
LREAL = .FALSE.    # (현재 A → 변경)
EDIFF = 1E-5       # (현재 1E-4 → 강화)
NELM = 200         # (현재 60 default → 증가)

SCPC {
     USE   = T
     IN    = 5      # (현재 1 → 증가, GitHub 권장 3-8)
     QTOT  = -1.0
     DIEL  = 15.15
     ZLOW  = 0.30
     ZHIG  = 0.70
     BROAD = 0.40
     RXCUT = 0.1
     RYCUT = 0.1
     RZCUT = 0.1
     PRTZ  = T
     MGX   = 48
     MGY   = 64
     MGZ   = 224
}
```

**How to apply:** SCPC slab 계산 시 in-plane ≥ 15 Å 확보, IN=5~8, EDIFF ≤ 1E-5, NELM ≥ 200, PREC=Accurate.

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

### 기타 수정사항
- `lhfskip` 바이너리: MPI 1 rank만 인식 → 주석 처리
- NCORE=32 (cascade2 노드 기준)
- 매 실행 전 z-diel.dat, SCPCOUT, MGSolver_* 삭제 필요 (누적)
