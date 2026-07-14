# Codex Working Notes

## Shared Memory

- When saving durable Codex memory for this repo, write or update the same Markdown note in both `memory/materials/` and `memory/codex/`.
- Use the same filename slug in both folders unless there is a strong reason not to.
- For every conversation in this repo, append a concise dated summary to both `memory/materials/conversation_log.md` and `memory/codex/conversation_log.md`, then commit and push the memory update when feasible.
- Do not edit unrelated memory files created by Claude. Codex memory updates should stay limited to Codex-owned mirror/log files unless the user explicitly asks for a specific existing memory edit.
- After adding or removing memory notes, refresh both indexes with:
  - `python3 .claude/gen-memory-index.py memory/materials`
  - `python3 .claude/gen-memory-index.py memory/codex`
- Do not add `memory/codex/.source`; `.source` files are for Claude project mappings used by `.claude/sync-memory.sh`.
- Do not store secrets, credentials, raw private logs, or full conversation transcripts as memory. Save only concise durable context, decisions, preferences, and workflow facts.
