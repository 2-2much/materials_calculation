---
name: dos-2x2x1-tetrahedron-occ-overshoot
description: 2x2x1 DOS의 Γ점 occ>1은 Blöchl tetrahedron 보정 아티팩트 — 총 전자수는 정확하므로 전하상태 판정에 무해
metadata: 
  node_type: memory
  type: reference
  originSessionId: f4bfd3d3-c080-491a-b5ba-f0c4ca66ef42
  modified: 2026-07-20T05:30:26.322Z
---

2026-07-20 사용자 지적 + 검증. **02_G221-DOS(2×2×1, 1shot) 계산 자체에 문제 없다.**

## 사실
V_Cl-Cl_As/q0 DOS(ISPIN=2, ISMEAR=−5, SIGMA=0.05, 4 k점) 밴드 370:

```
Γ(w=.25) occ_up=1.206 occ_dn=1.206 │ k2 0.178/0.177 │ k3 0.547/0.547 │ k4 0.070/0.070
Σ w·occ = 0.25 × (2.412 + 0.355 + 1.094 + 0.140) = 1.0000 전자  ← 정확
```

## occ>1의 정체
EIGENVAL이 ISPIN=2일 때 컬럼은 `band, E_up, E_dn, occ_up, occ_dn`이라 **채널당 점유수**가 찍힌다.
따라서 up+dw 합산(0~2 스케일)으로는 1.206을 설명할 수 없다. 채널당 1 초과는
**Blöchl tetrahedron 보정(ISMEAR=−5)** 이 k점별 가중치를 재분배하며 개별 점유수를 [0,1] 밖으로
민 것이고, **총합은 보정 설계상 정확히 보존**된다.

## 실무 함의
- **전자수·전하상태 판정에는 무해.** V_Cl-Cl_As = single donor(+1e)가 이 DOS로 확정
  (밴드 370에 정확히 1 전자). [[defect_states_02_clpassv]]
- 조심할 곳은 **E_F 위치를 meV 단위로 읽을 때**뿐. 기존에 기록된 "갭 내 삼각형 아티팩트"도 같은 뿌리.
- 전자수 계수 목적이면 **2×2×1로 충분**하다. 4×4×1 승격은 비용 4배인데 실익 없음
  (band-filling 정밀화 목적이면 별개).

## ⚠ 두 런을 혼동하지 말 것
[[defect_states_02_clpassv]]의 "band370 occ=0.500=전자 정확히 1개"는 **Γ-only 런**(`00_Gam-relax`,
k점 1개, ISPIN=2 채널당 0.5+0.5=1전자) 이야기로 **정확하다**.
여기서 말하는 occ=1.206은 **별개인 2×2×1 DOS 런**(`02_G221-DOS`, 4 k점, tetrahedron)의 Γ점 값이다.
두 런 모두 총 전자수 1개로 일치하며, 서로 모순이 아니다.
