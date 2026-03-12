---
description: Run a full weekly review with GTD inbox processing and quarterly check
argument-hint: [phase]
---

Run the Planning & Review System weekly review workflow.

**First:** Look for the config file in this order:
1. `.claude/life-os.local.md` (project-level)
2. `~/.claude/life-os.local.md` (global, portable across projects)

Use the first one found. If neither exists, tell the user:
> "life-os is not configured yet. Run `/setup` first, or copy your `life-os.local.md` to `~/.claude/` for global access."
Stop.

Load the planning-review-system skill from this plugin. Execute the full 6-phase workflow (30 min).

Parse arguments:
- Optional argument: specific phase to run
  - "inbox" → Phases 1-2 only
  - "quarterly" or "Q1"/"Q2"/"Q3"/"Q4" → Phase 4 only
  - "capture" → Phase 1 only
  - No argument → Full workflow (Phases 1-6)

Before starting, read connected tools from config. Available tools determine which operations use MCP and which use conversational fallbacks. If email tool is connected, include email scanning in Phase 1.
