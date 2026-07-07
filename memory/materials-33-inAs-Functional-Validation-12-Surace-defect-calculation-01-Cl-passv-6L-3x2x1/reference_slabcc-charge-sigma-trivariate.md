---
name: slabcc-charge-sigma-trivariate
description: slabcc charge_sigma가 하나만 나오는 이유(등방성 단일 가우시안) + surface defect에서 charge_trivariate on/off 판단
metadata: 
  node_type: memory
  type: reference
  originSessionId: 74a992e7-0d1a-4d47-8448-e3c5691cc471
---

slabcc에서 최적화된 `charge_sigma`가 값 하나(스칼라)로만 나오는 이유와 켜고 끄는 판단.

**왜 하나만 나오나:** `charge_trivariate = no`(등방성 가우시안) + charge_position 1줄 → 등방성 가우시안 1개이므로 σ도 1개(x=y=z 동일). `slabcc.out` 상단의 `charge_sigma = 1 1 1`은 방향별 다른 값이 아니라 입력 디폴트(모두 1)를 3-벡터로 표시한 것일 뿐. 최적화 결과는 `charge_sigma_optimized`에 스칼라 하나로 보고됨.
- 방향별 σx≠σy≠σz 원하면 → `charge_trivariate = yes` (가우시안당 3개 출력)
- 다중 가우시안(charge_position 여러 줄) → 줄마다 σ 그룹

**Cl-As_In vertical scan(vac_40A_fixed 등)에서의 판단 — off 유지 권장:**
- 물리만 보면 surface/slab defect는 charge cloud가 비등방성(면내 vs z-진공)이라 trivariate=yes가 이론상 타당. 이 케이스도 등방성 fit이 σ=1.73(큼), potential RMSE≈0.089 V로 타협 흔적 있음.
- 그러나 (1) 본채택 correction은 slabcc가 아니라 **Falletta(z)** — slabcc는 교차검증용이라 모델 단순하게 두는 게 해석 깔끔. (2) vertical scan은 z로 charge 옮기며 E_corr 거동 보는 것 → 한 점만 trivariate 켜면 동일조건 비교 깨짐(켜려면 스캔 전체 통일 필요). (3) 형제 디렉토리(vac_30/40/50 + fixed) 전부 등방성으로 통일됨. (4) 파라미터 3개면 overfitting/interface 민감도↑.
- 진단하고 싶으면 이 한 점에서만 trivariate=yes 한 번 돌려 σz 갈라짐과 E_corr 변화 확인. 크게 갈리면 "등방성 slabcc 모델이 이 defect에 부적합"의 신호 → Falletta 선택 정당화.

[[slabcc-correction-cl-as-in]] [[slabcc-z-shift]]
