---
name: ssh-access-between-servers
description: "kohn에서 sham/bloch로 SSH 원격 실행 셋업 — 전용키 id_claude, config alias, 조회명령 자동승인"
metadata: 
  node_type: memory
  type: project
  originSessionId: ef8eb03e-6497-4f2e-8956-00a63aaeb749
  modified: 2026-08-10T11:22:44.568Z
---

2026-08-07 셋업. kohn 세션에서 다른 서버 명령을 직접 실행할 수 있다.

## 구성

- **`~/.ssh/id_claude`** (ed25519, passphrase 없음) = Claude 전용 키. 회수는 원격
  `authorized_keys`에서 `claude-code@kohn` 줄만 삭제하면 된다. `id_rsa`는 건드리지 않았다.
- **`~/.ssh/config`**: `bloch`/`sham`/`kohn` alias → `%h.kaist.ac.kr`, `User jaegwan97`
  (4대 모두 같은 계정명), ControlMaster 재사용 10분. `~/.ssh/cm/` 소켓 디렉터리 필요.
- **`materials/.claude/settings.json`**: `Bash(ssh bloch <cmd>:*)` / `Bash(ssh sham <cmd>:*)`
  형태로 조회 전용 26개 자동승인(squeue·sinfo·sacct·scontrol show·ls·cat·head·tail·grep·df·du·module avail).
  git 추적 대상이라 4대에 전파된다. `sbatch`·`rm`·`rsync`는 의도적으로 제외 — 매번 승인받는다.
  ⚠원격 명령을 따옴표로 묶으면(`ssh sham 'a; b'`) 접두사 매칭이 깨져 자동승인 안 된다(안전 쪽 실패).
- **`~/.claude/settings.json`의 `sshConfigs`**: `claude ssh bloch` / `claude ssh sham` 으로
  해당 서버에서 Claude Code 세션을 직접 띄울 수 있다. 작업이 한 서버 안에서 끝날 땐 이쪽이 낫다.

## ⚠키 등록은 반드시 원격 서버 안에서

`ssh-copy-id`가 두 번 실패했다. 원인 두 가지:
1. Claude Code의 `!` 명령에는 **TTY가 없어** ssh가 비밀번호를 못 받는다(프롬프트 없이 즉시 거부).
2. 일반 터미널에서도 비밀번호가 틀렸고, **실패 누적이 fail2ban을 유발**했다.

성공한 방법 = 이미 접속된 세션에서 서버 안에서 직접 append:
```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "ssh-ed25519 AAAA... claude-code@kohn" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## 상태 (2026-08-07)

- **sham**: 접속 OK.
- **bloch**: 2026-08-07엔 **kohn IP(143.248.13.145)가 차단**되어 포트 22 Connection refused
  (sshd는 정상 LISTEN).
  ✅**2026-08-10 확인: 접속 복구됨** — 관리자 조치 없이 fail2ban bantime 만료로 자동 해제된 것으로
  보인다. 키는 그대로(`grep -c claude-code@kohn` = 1). fail2ban은 여전히 active이고 jail 설정은
  sudo 없이 못 본다 → **비밀번호 실패가 몇 번 쌓이면 또 차단된다.** 재발 방지엔 관리자에게
  `ignoreip`에 교내 서버 IP 등록을 요청해야 한다(kohn 143.248.13.145 / sham 143.248.247.45 /
  bloch 143.248.247.246). 키 인증만 쓰면 실패가 안 쌓이므로 평소엔 안전.
- **NFS**: bloch에는 `/mnt/hohenberg/byname`이 정상 마운트되어 있다(kohn과 동일).
  sham만 미마운트 — [[server_fs_git_sync_scope]] 참고.

서버 판별·파일시스템은 [[server_fs_git_sync_scope]], hostname 함정은 [[inas100_worktree_on_kohn]].
