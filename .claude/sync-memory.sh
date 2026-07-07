#!/bin/bash
# materials/papers 관련 프로젝트 + home 의 Claude 메모리를 Git으로 동기화
# Usage: sync-memory.sh pull|push

REPO_MEM=~/materials/memory
CLAUDE_BASE=~/.claude/projects
# 서버 식별: 4대 모두 내부 hostname이 tgm-master.hpc, ClusterName도 tgmv2로 동일해
# 구분 불가. 실제 서버 이름은 공개 FQDN(*.kaist.ac.kr)에만 담겨 있음(예: sham.kaist.ac.kr).
# 우선순위: KAIST FQDN → hostname -s → ClusterName → unknown
SERVER=$(hostname -A 2>/dev/null | tr ' ' '\n' | grep -iE '\.kaist\.ac\.kr$' | head -1 | cut -d. -f1)
[ -z "$SERVER" ] && SERVER=$(hostname -s 2>/dev/null)
[ -z "$SERVER" ] && SERVER=$(scontrol show config 2>/dev/null | awk '/^ClusterName/{print $3}')
[ -z "$SERVER" ] && SERVER="unknown"
MODE=$1

is_syncable_project() {
  local dir="$1"
  [[ "$dir" == "-home-jaegwan97" ]] || \
  [[ "$dir" == -home-jaegwan97-materials* ]] || \
  [[ "$dir" == -mnt-hohenberg-*-papers* ]]
}

case $MODE in
  pull)
    cd ~/materials && git pull --rebase origin main 2>&1 || echo 'git pull 실패'
    for source_file in "$REPO_MEM"/*/.source; do
      [ -f "$source_file" ] || continue
      proj_dir=$(cat "$source_file")
      short_name=$(basename "$(dirname "$source_file")")
      target="$CLAUDE_BASE/$proj_dir/memory"
      mkdir -p "$target"
      cp -a "$REPO_MEM/$short_name"/*.md "$target/" 2>/dev/null || true
    done
    ;;
  push)
    for proj_mem in "$CLAUDE_BASE"/*/memory; do
      [ -d "$proj_mem" ] || continue
      proj_dir=$(basename "$(dirname "$proj_mem")")
      is_syncable_project "$proj_dir" || continue

      short_name=""
      for source_file in "$REPO_MEM"/*/.source; do
        [ -f "$source_file" ] || continue
        if [ "$(cat "$source_file")" = "$proj_dir" ]; then
          short_name=$(basename "$(dirname "$source_file")")
          break
        fi
      done

      if [ -z "$short_name" ]; then
        short_name=$(echo "$proj_dir" | sed 's/^-home-jaegwan97-*//;s/---/-/g')
        [ -z "$short_name" ] && short_name="home"
        mkdir -p "$REPO_MEM/$short_name"
        echo "$proj_dir" > "$REPO_MEM/$short_name/.source"
      fi

      cp -a "$proj_mem"/*.md "$REPO_MEM/$short_name/" 2>/dev/null
    done

    cd ~/materials
    if [ -n "$(git status --porcelain)" ]; then
      git add -A && git commit -m "Auto-sync: Claude Code session ($SERVER)"
    fi
    # 로컬에 미푸시 커밋이 있으면(이번 커밋 또는 이전에 push 거부로 남은 것) 항상 푸시 시도.
    # 멀티서버 공유로 원격이 앞설 수 있으므로 rebase 후 푸시, 실패 시 1회 재시도.
    if [ -n "$(git log origin/main..HEAD --oneline 2>/dev/null)" ]; then
      git pull --rebase origin main 2>&1 || echo 'git pull(rebase) 실패'
      git push origin main 2>&1 || { git pull --rebase origin main 2>&1 && git push origin main 2>&1; }
    fi
    ;;
esac
