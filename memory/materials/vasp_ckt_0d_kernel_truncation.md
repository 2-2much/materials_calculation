---
name: vasp_ckt_0d_kernel_truncation
description: "VASP Coulomb kernel truncation(CKT, 6.5.0+) 사용법 — 태그·기본값(LCOARSEN 기본 F)·위키. ⚠0D 에서 이온–이온 항 TEWEN 이 작은 셀(경계까지 <~9 Å)에서 수 eV~keV 틀림 → L 수렴 필수 점검. 벌크 기준상엔 쓰지 말 것"
metadata:
  node_type: memory
  type: reference
  originSessionId: 11c6ee48-6b18-4123-8e5e-a326020ccf79
  modified: 2026-10-06T05:36:32.656Z
---

위키: https://vasp.at/wiki/KERNEL_TRUNCATION/LTRUNCATE (하위 태그 페이지 KERNEL_TRUNCATION/IDIMENSIONALITY, /IPAD, /LCOARSEN, /FACTOR).
논문: Vijay…Kresse, PRB 112, 045409 (2025) — 노트 `~/papers/memory/paper_notes/CKT_Coulomb_kernel_truncation_Vijay2025.md`.

## 태그 (블록형 권장)
```
KERNEL_TRUNCATION {
    LTRUNCATE       = T      # 기본 F. T 일 때만 나머지 태그 적용
    IDIMENSIONALITY = 0      # 0 분자/QD, 2 표면, 3 기본(절단 없음)
    LCOARSEN        = T      # ★기본 F. 0D 에서 F 면 FFT 27배 → 큰 셀 불가. 위키가 분자에 T 권장
}
# IPAD 기본 0D=3 / 2D=2,  FACTOR(R_c/셀길이) 기본 0D=√3 / 2D=1,  ISURFACE = 2D 법선
```
- 모티프는 셀 중앙, **비주기 방향 경계에 원자 금지**. 문제 진단: IPAD=1·FACTOR=0.5(무패딩).
- 0D: 젤리움 없음, 정렬 불필요, **고유값이 진공 기준 절대값**(셀 크기 무관).
- 벌크 기준상(μ 계산)에는 쓰지 말 것: 원자가 경계에 있고, μ 는 결함 셀 경계조건과 무관(Fig.8 Zenodo 데이터도 ½E[Cl₂] 3D/2D 동일값).

## ⚠★ 0D 에서 이온–이온 항(TEWEN)이 작은 셀에서 틀린다 (2026-09-26 GaAs QD 실측, 6.5.1 wan90 gam, LCOARSEN=T)
- 원자 배치 동일한데 TEWEN 이 L20 +13117, L25 +810, L30 +7.9 eV 틀리고 **L35 = L40 8자리 동일**.
  가장자리 원자–경계 6.9 Å 실패 / 9.4 Å 수렴. Hartree·XC·고유값은 L25 부터 수렴 → 틀리는 건 TEWEN 하나.
- 이온 구성이 다른 계(host vs 치환 결함)끼리는 오차가 달라 형성에너지가 망가짐. 같은 이온(q0/q+1)끼리는 정확히 상쇄 → IP 는 멀쩡.
- 진단용 교체 TOTEN − TEWEN(L) + TEWEN(L_max) 하면 형성에너지가 전 L 에서 6 meV 폭. 원인 미확인(가설: 패딩/가우시안 분리폭이 경계 넘음).
- TEWEN(수렴) = 순수 직접합 ΣZᵢZⱼ/rᵢⱼ + 상수(host +7.19 / Si_Ga +7.00 eV) — VASP 내부 규약으로 보임.
- **How to apply: 0D CKT 결과는 항상 OUTCAR TEWEN 의 L 수렴(|ΔTEWEN| < 1 meV)을 먼저 확인.** analyze_ckt.py 가 자동 판정(kohn 02-CKT).

## 2D CKT (참고)
NaCl(001) Cl 공공 Fig.8 재현(`33-inAs/__Functional_Validation__/11-Surface-defect_TOY-model/CKT_PRB`, Zenodo OUTCAR):
진공 의존 1–2 meV 로 사라지나 **면내 L 의존은 남음**(1/L+1/L³ 외삽 필요). 저자 설정 LCOARSEN=F·IPAD=2.
관련: [[trsm_fig6_gaas_qd_model]] [[qd_charging_energy_framework]]
