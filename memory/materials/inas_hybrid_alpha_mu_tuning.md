---
name: inas_hybrid_alpha_mu_tuning
description: "벌크 InAs HSE(α,μ) 동시 튜닝(갭+gKT) 착수 2026-10-01 — 격자 선택 결론(PBE-d 격자 금지), 실측 HSE06@PBE-d a0 갭 0.13 eV, SOC 없는 목표갭 ≈0.54 eV"
metadata:
  node_type: memory
  type: project
  originSessionId: ba0afc85-1759-42c9-ae97-daf27fade139
  modified: 2026-10-01T05:55:00.841Z
---

2026-10-01 착수. 근거 논문 = [[hybrid_choice_Ga2O3_Deak2017]](실험 격자에서 피팅, 최종 범함수 격자 검증) · [[koopmans_titanate_polaron_Bae2026]](매 파라미터 자기 격자 + 결함 재이완).

- 실측: `06-Hybrid_p-d_repulsion_test/PBE-d_HSE06/01_SCF_relax` = HSE(0.25,0.2) @ **PBE-d a0 6.1896** → 갭 **0.131 eV** (SOC 없음).
- 자기 격자 a0(PBE-d+HSE, μ=0.2): α 0.25→0.30 에 6.1043→6.0895 (0.24%만 변함). 실험 6.0583. PBE-d 6.1896(+2.2%).
- 결론(권고): **PBE-d 격자로 피팅 금지** — 변형퍼텐셜 ~−5~−6 eV 로 갭이 ~0.35 eV 깎여 α 가 ~0.1 과대 선택됨. 피팅 격자는 HSE 자기격자(또는 실험), 최종 (α,μ) 에서 BM 재적합 후 갭 재확인 1회 반복.
- SOC 없이 결함계산하면 목표 갭 = 0.417 + Δ_so/3(0.127) ≈ **0.54 eV** (사용자 결정 대기).
- 미결: gKT 시험할 국소 gap 상태 결함 선정(InAs 갭 좁아 얕은/공명 결함은 불가, [[shallow_donor_inas_supercell_limit]]).
