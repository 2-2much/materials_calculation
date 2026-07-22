---
name: next_steps_2026_07_22
description: "2026-07-22 세션 완료분과 다음 할 일 — In_As_1 deep level 확정, slabcc 가드 우회, IPR probe 교체, 진공 수렴 스캔 완료"
metadata: 
  node_type: memory
  type: project
  originSessionId: 640e3ab2-68c1-49e1-b49b-8fbed2a39915
  modified: 2026-07-22T08:24:08.392Z
---

2026-07-22 세션 종료 시점. 세션 보고서 HTML:
`04-InCl3-passv_6L_4x2x1_HSE06/__vacuum-scan_In_As_1_PBE-d__/2026-07-22_report.html`

## 오늘 완료 (재작업 금지)

1. **In_As_1 = 전하상태별로 성격이 갈림** → [[in_as_1_deep_level_q_dependent]]
   q+1만 deep(빈 ↓준위 4.84×VBM, In 3배위 40.6%, 교환분열 0.382eV, mag 0.994) /
   q0의 2.03×는 host 노이즈(pure 90퍼센타일 2.02×) / q−1은 1.02×CBM shallow.
2. **slabcc 전하절단 가드 = 위양성** 진단·우회 → [[slabcc_charge_truncation_guard]]
   `SLABCC_CHARGE_TOLERANCE` env 추가·재빌드(기본 1e-4 불변, 회귀 60파일 ALL-PASS).
   **In_As_1 q+1 E_corr = +0.057932 eV** 확보, `slab_corrections.csv` 반영.
   q−1은 정당한 거부 → shallow-limit 작도로.
3. **IPR gate probe 규칙 교체** → [[ipr_gate_occdiff_probe]]
   HOMO/LUMO → **|occ(q)−occ(q0)| 최대 밴드**, |q|>1은 **가장 약한 carrier**.
   판정 뒤집힘: 04 In_As_1 q+1 shallow→**bound**, 02 Cl-As_In q+2 bound→**미결**.
   relax축 기본경로 오류도 수정 → 하전 9행 중 8행 두 축 일치.
4. **진공 수렴 스캔 완료** (PBE-d, 13.5/20/30/40/50Å; VASP 15회 = q0·q+1·pure ×5, slabcc 18회)
   → [[vacuum_scan_vbm_reference_trap]]
   **결론: slabcc 보정은 13.5Å에서 이미 수렴(±8meV). 미수렴 64meV의 정체는 host 슬랩 IP(72meV).**
   위치 `04-.../__vacuum-scan_In_As_1_PBE-d__/` (README.md + HTML 보고서에 전체 기록)
5. **cascade 병렬 표준** 기록 → [[cascade_parallel_settings]]

## ⏭ 다음 (사용자와 순서 정할 것)

1. **HSE production에 처방 적용** — E_corr(0.0579eV)은 그대로 두고, DFE 조립 시 **VBM 기준만
   두꺼운 진공 pure 슬랩에서** 가져오기. CTL/DFE에 실제 영향 계산.
2. **dipole correction 검증** — PBE에서 `LDIPOL`/`IDIPOL=3`으로 진공 인공장(−0.093→−0.028 V/Å)이
   사라지면 IP 표류도 사라지는지. 되면 얇은 진공에서도 기준이 안정.
   ⚠[[surface_defect_dipole_correction]]: HSE에선 SCF 미수렴 이력.
3. **In_As_2 하전 계산** — q0에서 5.75×에 갭 내 빈 국소준위까지, In_As_1보다 깨끗한 deep 사례.
   **진공은 키울 필요 없음**(위 4번 결론).
4. **Cl-As_In q+2 재검토**(02) — bound→미결로 뒤집혔는데 **E_corr 이미 적용돼 있음**
   (01-spin-gam 0.294991 / 00-gam-relax 0.375853, 둘 다 rmse_warning).
5. **진공 스캔 Γ-only 반복** — 사용자 요청분, 미실행(k-mesh 의존성 확인용).

## 이전 세션에서 넘어온 미결 (계속 유효)

- **Cl 3종 DOS/BAND** — 55606/55607/55608 cascade2에서 실행 중(k 2×2×1, Y-Γ-X-S, 구간 6/4/6).
  완주 후 band-filling 실측·zeroband fatband.
- **In metal → μ_Cl(InCl₃)** — 사용자 구조 제공 예정. → [[mu_reference_phases]]
  ⚠현재 04 DFE 서열은 무효(Δn_Cl=+1이 음수 형성E) → [[cl_as_negative_eform_reference_slab]]
- **band-filling 파이프라인 부재** → [[bandfilling_measured_from_dos]] [[shallow_limit_dfe_construction]]
- **미결 판정 3건** — `V_In`(EDGE-AMBIGUOUS), `As_In`(Γ 1점 한계, multi-k 필요),
  `In_i_Td_In`(02, NUPDOWN=1 재계산)

## 커밋 안 된 것

`02-.../scripts/ipr_gate.py`, 양 프로젝트 `results/DFE_plots/IPR_gate.csv`,
04의 `__vacuum-scan_In_As_1_PBE-d__/` 전체는 **계산 폴더라 자동 동기화 대상이 아니다**.
04는 자체 git 있음. → [[server_fs_git_sync_scope]]
또한 `~/bin/slabcc` 소스 수정(env override) + `tests/run_regression.sh`도 홈 디렉토리라 미동기화.
