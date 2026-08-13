---
name: vesta_bond_table_inas
description: "VESTA가 InAs 결합을 안 그리는 이유 = style.ini SBOND의 In-As 상한 2.66642 < PBE-d 2.6803. ~/.VESTA/style/default.ini 수정으로 영구 해결"
metadata:
  type: reference
---

2026-08-13. PBE-d 셀을 VESTA 에 넣으면 **In-As 결합이 안 그려진다**(Cl-In 만 보임).
POSCAR 문제가 아니다.

## 원인

VESTA 는 자동 결합 탐색을 반지름 합이 아니라 **명시적 쌍 화이트리스트**로 한다:
`style.ini` 의 `SBOND` 표(914행). 시스템본 `/TGM/Apps/VESTA/style.ini`,
사용자본 **`~/.VESTA/style/default.ini`**(VESTA 가 실제로 읽는 쪽).

| 쌍 | VESTA 상한 | 우리 값 | 결과 |
|---|---|---|---|
| **In-As** | **2.66642** | **2.6803** | ❌ 0.014 Å 초과 |
| In-Cl | 3.52939 | 2.4500 | ✅ |
| In-H | 1.87642 | 1.7757 | ✅ |
| As-Cl | 2.61646 | 2.2000 | ✅ |
| **As-H** | **표에 없음** | 1.5622 | ❌ |

★ **LDA(a0=6.0619)면 결합이 2.6247 이라 문턱 안쪽**이다. PBE-d(a0=6.18984)로 격자가
늘어나면서 딱 넘어간 것 — 옛 LDA 셀에서는 보였는데 지금 안 보이는 이유가 이거다.

원소 색: In (0.844,0.504,0.735) 분홍 / As (0.458,0.817,0.342) 초록 /
Cl (0.196,0.988,0.012) 형광초록 / H 흰색. (`elements.ini`: Z, 기호, 공유반지름, VdW, 이온반지름, R,G,B)

## 해결 (적용 완료)

`~/.VESTA/style/default.ini` 수정. 백업 = `default.ini.bak_2026-08-13`.
1. 383행 `368 In As ... 2.66642` → **2.90000**
2. 930행에 `915    As     H    0.00000    1.80000  0  1  1  0  1` 추가
   (SBOND 종료행 `  0 0 0 0` 바로 앞에 삽입, 기존 인덱스 유지)

/TGM/Apps/VESTA/style.ini 는 tgmadmin 소유 읽기전용이라 건드리지 않았다.
다른 머신에서 VESTA 를 쓰면 그 머신의 같은 파일을 똑같이 고쳐야 한다.

⚠ 2.90 은 안전하다: InAs 2차 이웃은 In-In 4.377 / In-As 5.13 로 멀다.
In-In 은 SBOND 표에 아예 없어서 In_i1 의 짧은 In-In 2.68 도 결합으로 안 그려진다.

관련: [[inas110_bare_par3x2_pure_cell]]
