---
name: kohn_conda_forge_and_venv
description: "kohn 네트워크/파이썬 환경 — conda-forge CondaHTTPError 000 은 차단 아닌 일시장애(IPv6 죽어있음 + fetch_threads 5 × connect timeout 9.15s). ⚠py4vasp env 는 pip 메타데이터가 깨져 있다 → venv 권장"
metadata:
  type: reference
---

2026-09-22 진단 (kohn = tgm-master 로그인 노드).

## conda-forge `CondaHTTPError: HTTP 000 CONNECTION FAILED` — 차단 아님

실패했다던 바로 그 URL 들이 나중에 멀쩡히 받아진다:
`icu-78.3` 14.5 MB **0.25 s (57 MB/s)** / `python-3.12.14` 23 MB 1.18 s / `libstdcxx-16.2.0` 6.6 MB 0.46 s.
conda 가 쓰는 `requests` 로 직접 받아도 0.4 s 에 200.

추정 원인 (증거 기반):
- 첫 `repodata.json` 요청이 **23.5 s** 걸렸다(지금 HEAD 는 0.09 s) → 그 시점 CDN 이 차가웠다
- conda 설정이 **`fetch_threads: 5`** + **`remote_connect_timeout_secs: 9.15`**
- `HTTP 000` = HTTP 응답 자체가 없음 = **연결 단계 실패** → 연결 타임아웃과 일치
→ **재시도가 1차 해법**(conda 에러 메시지가 말한 그대로)

## ⚠ 이 머신은 IPv6 경로가 죽어 있다
`curl -6` → **0.002 s 만에 000**. 그런데 DNS 는 AAAA 를 먼저 돌려준다.
curl 은 Happy Eyeballs 로 가리지만 병렬·고부하에서는 또 하나의 실패 경로.

## 도달성 (2026-09-22)
| | |
|---|---|
| `conda.anaconda.org` | 느릴 때 있음, IPv4 로는 정상 |
| `repo.anaconda.com` (defaults) | **정상·빠름** |
| `pypi.org` / `files.pythonhosted.org` | 정상 |
| `download.pytorch.org/whl/cpu` | 정상 |

conda 하드닝: `remote_connect_timeout_secs 30` / `remote_read_timeout_secs 180` /
`remote_max_retries 5` / `fetch_threads 2`.
conda-forge 건너뛰기: `conda create -n X -c defaults --override-channels python=3.12`
(`.condarc` 가 conda-forge 우선 + `channel_priority: strict` 라 `--override-channels` 필요)

## ⚠⚠ py4vasp env 에 새 패키지를 깔지 말 것
```
site-packages/numpy-1.26.4.dist-info   ← 유령      numpy-2.3.3.dist-info   ← 실제(conda)
site-packages/ase-3.25.0.dist-info     ← 유령      ase-3.26.0.dist-info    ← 실제(conda)
```
`pip list` 는 1.26.4 / 3.25.0 이라 하는데 **import 되는 건 2.3.3 / 3.26.0**.
pip 이 이 **거짓 메타데이터를 보고 의존성을 판단**하므로, numpy 를 "고치겠다"며 재설치하면
conda 관리 파일을 덮어써 **py4vasp 와 conda 일관성이 동시에 깨진다.**
복제(`--clone`)도 깨진 메타데이터를 같이 복제하므로 이점 없음.

## ★ 권장: conda 를 아예 안 쓰는 venv
```sh
# 새 로그인 쉘에서 (현 쉘은 CONDA_SHLVL=8 로 conda 가 8겹으로 쌓여 있었다)
/TGM/Apps/ANACONDA/2024.10/bin/python -m venv ~/venvs/sevennet
source ~/venvs/sevennet/bin/activate
pip install --upgrade pip
pip install torch --index-url https://download.pytorch.org/whl/cpu
pip install sevenn
```
- base 가 `/TGM/Apps/ANACONDA/2024.10` (Python **3.12.7**, 읽기 전용 공용) →
  본인 conda env 를 지워도 안 깨진다. `include/python3.12/Python.h` 있음(소스 빌드도 가능)
- **venv 는 site-packages 를 상속하지 않아 py4vasp 와 완전 격리**
- conda-forge 를 **한 번도 안 거친다** → 위 장애 재발 불가
- 디스크: `/home` 8 TB 여유, **quota 없음**

`submit_relax.sh` 는 `conda activate` 대신 `source ~/venvs/sevennet/bin/activate`,
그리고 kuee1020 LD_LIBRARY_PATH 줄은 삭제.

관련: [[sevennet_jh_tool]] [[no_compute_on_login_node]] [[server_fs_git_sync_scope]]
