---
description: Plan the upcoming week — collect, weigh, gate on approval, then apply to calendar and vault
argument-hint: [week]
---

Run the Weekly Planner workflow.

**First:** Look for the config file in this order:
1. `.claude/life-os.local.md` (project-level)
2. `~/.claude/life-os.local.md` (global, portable across projects)

Use the first one found. If neither exists, tell the user:
> "life-os is not configured yet. Run `/setup` first, or copy your `life-os.local.md` to `~/.claude/` for global access."
Stop.

Load the weekly-planner skill from this plugin. Execute the full 4-phase workflow (Collect / Weigh & Prioritize / Report+GATE / Apply).

Parse arguments:
- Optional argument: the target week's Monday date (e.g. `2026-07-13`). No argument → the next Monday (or the current week if invoked Monday morning).

Before starting, read connected tools from config (`task_tool`, `calendar_tool`, `notes_tool`, `email_tool`). Available tools determine which operations use MCP and which use conversational fallbacks.

The skill STOPS at a human gate after Phase 3 (Report) and does not touch the calendar or vault until the user approves. Do not bypass that gate.
