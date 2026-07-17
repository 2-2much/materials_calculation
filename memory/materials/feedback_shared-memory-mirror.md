---
name: feedback_shared-memory-mirror
description: Codex durable memories should be mirrored to both memory/materials and memory/codex, with matching slugs and refreshed indexes
metadata:
  type: feedback
---

Codex durable memory for this repo should be saved as Markdown in both:

- `memory/materials/`
- `memory/codex/`

Use the same filename slug in both locations and refresh both `MEMORY.md` indexes with `.claude/gen-memory-index.py`.

For every conversation in this repo, append a concise dated summary to both `memory/materials/conversation_log.md` and `memory/codex/conversation_log.md`, then commit and push the memory update when feasible.

Do not edit unrelated memory files created by Claude. Codex memory updates should stay limited to Codex-owned mirror/log files unless the user explicitly asks for a specific existing memory edit.

Store concise durable summaries rather than raw full transcripts, secrets, credentials, or long private logs.

Do not add `memory/codex/.source`; that file type is reserved for Claude project memory mappings consumed by `.claude/sync-memory.sh`.
