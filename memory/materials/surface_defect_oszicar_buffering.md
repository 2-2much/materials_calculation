---
name: surface-defect-oszicar-buffering
description: "12-Surace-defect_calculation HSE 잡에서 OSZICAR가 실행 중 갱신 안 되는 버퍼링 이슈 + HSE 이중루프 수렴 판독법 (2026-07-01)"
metadata:
  node_type: memory
  type: project
  originSessionId: 0b838ed2-3a0f-4b92-a22c-131ab8936454
---

## OSZICAR가 실행 중 갱신 안 됨 (버퍼링)
02-Cl-passv HSE 잡(vasp.6.5.1.std, cascade2)에서 실측:
- OSZICAR: DAV 28에서 멈춤(mtime 20:12, 46분째 정지)
- std.log(=stdout, run_case.sh가 `mpirun ... > std.log`): DAV 49, mtime 20:57 라이브
- OUTCAR: iteration 50, mtime 20:57 라이브

**원인**: VASP의 OSZICAR Fortran I/O 유닛이 block-buffered라 이 클러스터/MPI 환경에서 버퍼가 꽉 차거나 job 종료 시까지 flush 안 됨. stdout/OUTCAR는 더 자주 flush됨.
→ **라이브 모니터링은 OSZICAR 말고 std.log 또는 OUTCAR로 할 것.** (관련: [[scpc_debug]]의 "OSZICAR 유실"과 별개 맥락이지만 유사 증상)

## HSE 수렴 판독: OSZICAR만 보면 오판함
stale OSZICAR(step 28, E=−435.0)만 보면 "매끄러운 단조수렴"으로 착각하지만, 실제 std.log는 HSE 이중 루프:
- inner Davidson 루프 수렴 → exchange 연산자 갱신 시점에 **에너지 대점프**(step 29: +13.4eV, step 44: +1.04eV)
- 점프 크기가 ~10배씩 줄면 outer 루프 정상 수렴 중(2~3 outer 사이클 더 필요)
- E 궤적: −435.0 → −422.4 → −421.4로 수렴

**따라서 HSE 잡 수렴 판단은 반드시 std.log 전체 DAV 궤적으로**. exchange 갱신 점프 때문에 step 수가 예상보다 많이 필요(96-atom 2×2×1 HSE에서 70~85 step). NELM=100이 여유 크지 않으니 향후 잡은 NELM=120~150 권장.

**Why:** 실행 중 잡 상태를 OSZICAR로 판단하면 (a)진행 스텝을 과소평가, (b)이중루프 점프를 못 봐 수렴성 오판
**How to apply:** 12-Surace-defect_calculation HSE 잡 모니터링은 `grep '^DAV:' std.log | tail` 또는 OUTCAR로. 수렴 애매하면 NELM 상향. 관련 [[surface-defect-1shot-band-workflow]] [[surface-defect-dipole-correction]]
