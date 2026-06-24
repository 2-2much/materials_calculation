---
name: slabcc-z-shift
description: slabcc가 출력 CHGCAR에서 z좌표를 shift하므로 VESTA에서 볼 때 원래 좌표와 다름
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3bcb2332-9234-404e-a9db-748447fab7e5
---

slabcc 출력 파일(slabcc_D.CHGCAR 등)에서 원자 좌표가 원래 CHGCAR와 다르게 보일 수 있음.

**Why:** slabcc가 `slab_center` 파라미터 기준으로 slab을 셀 중앙(z=0.5)에 맞추기 위해 z방향 shift를 적용함. shift = 0.5 - slab_center_z. 예: slab_center_z=0.543이면 shift=-0.043.

**How to apply:** slabcc 결과를 VESTA에서 열어 원자 좌표를 확인할 때, 원래 POSCAR/CHGCAR 좌표와 비교하려면 이 shift를 고려해야 함. slabcc.in의 charge_position, interfaces 등은 shift 전 원래 좌표 기준으로 입력해야 함.
