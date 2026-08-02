---
name: feedback_convergence_scan_wording
description: "'사다리' 대신 '수렴 스캔'으로 쓸 것 — 기존 메모리의 k-사다리·Ecut 사다리는 같은 뜻"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e2e681b6-093b-4a4f-ae4f-da18a9dc5ec4
  modified: 2026-08-02T21:22:40.414Z
---

파라미터 하나를 한 칸씩 올려가며 같은 계산을 반복하는 계열(α = 4→5→…→80, Ecut = 4→…→25 Ha, k = 1×1×1→4×4×1)을 **"수렴 스캔"** 으로 부를 것. "사다리"는 쓰지 말 것 (2026-08-03 지시).

**Why**: 의미 파악이 더 쉽다는 사용자 판단.

**How to apply**: 새로 쓰는 글·주석·스크립트는 "수렴 스캔"(또는 영어로 convergence scan/series). ⚠단 **기존 메모리와 스크립트에는 "사다리"가 그대로 남아 있다** — `vclclas_kpt_ladder_two_routes`("사다리 = k1x1x1 / k2x2x1_MP / …"), `bandfill_correction_stage`("k-사다리"), `coffee_setup_and_arange_bug`("Ecut 사다리에서 한 점만 튀고"), 파일명 `*_ladder*.sh`. 옛 기록을 읽을 때 같은 뜻으로 해석할 것이고, 소급 개명은 하지 않았다.
