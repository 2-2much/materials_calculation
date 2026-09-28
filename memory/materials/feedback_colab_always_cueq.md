---
name: feedback_colab_always_cueq
description: Colab SevenNet 노트북은 원자 수와 무관하게 항상 cuEquivariance 가속기(sevenn[cueq12], enable_cueq) 사용
metadata:
  type: feedback
---

Colab용 SevenNet 노트북을 만들 때는 240원자처럼 작은 계산이라도 **항상 cuEquivariance 가속기를 켠다** (`%pip install "sevenn[cueq12]"`, `SevenNetCalculator(..., enable_cueq=True)` + `is_cue_available()` 확인 후 불가면 경고하고 fallback).

**Why:** 2026-09-28 사용자 지시 — 내가 "240원자라 가속기 없이 충분"이라며 뺐더니 "다음부턴 가속기를 사용하도록" 요청.
**How to apply:** 새 노트북 설치 셀·계산기 셀에 기본 포함. torch CUDA 12.x→cueq12, 13.x→cueq13. 관련 [[gdrive_colab_sevennet_bridge]] [[sevennet_jh_tool]]
