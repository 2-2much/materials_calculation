#!/bin/bash
# materials 관련 프로젝트 + home 의 Claude 메모리를 Git으로 동기화
# Usage: sync-memory.sh pull|push

REPO_MEM=~/materials/memory
CLAUDE_BASE=~/.claude/projects
SERVER=$(hostname -s)
MODE=$1

is_materials_project() {
  local dir="$1"
  [[ "$dir" == "-home-jaegwan97" ]] || [[ "$dir" == -home-jaegwan97-materials* ]]
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
      cp -a "$REPO_MEM/$short_name"/*.md "$target/" 2>/dev/null
    done
    ;;
  push)
    for proj_mem in "$CLAUDE_BASE"/*/memory; do
      [ -d "$proj_mem" ] || continue
      proj_dir=$(basename "$(dirname "$proj_mem")")
      is_materials_project "$proj_dir" || continue

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
      git add -A && git commit -m "Auto-sync: Claude Code session ($SERVER)" && git push origin main 2>&1
    fi
    ;;
esac
