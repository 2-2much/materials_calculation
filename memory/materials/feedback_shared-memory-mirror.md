---
name: shared-memory-mirror
description: Codex durable memories should be mirrored to both memory/materials and memory/codex, with matching slugs and refreshed indexes
metadata:
  type: feedback
---

Codex durable memory for this repo should be saved as Markdown in both:

- `memory/materials/`
- `memory/codex/`

Use the same filename slug in both locations and refresh both `MEMORY.md` indexes with `.claude/gen-memory-index.py`.

Do not add `memory/codex/.source`; that file type is reserved for Claude project memory mappings consumed by `.claude/sync-memory.sh`.
