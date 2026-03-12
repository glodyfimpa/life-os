---
description: Start the day with an energy-adaptive daily plan
argument-hint: [energy-level]
---

Run the Time & Energy Manager Morning Plan (Phase 1).

**First:** Look for the config file in this order:
1. `.claude/life-os.local.md` (project-level)
2. `~/.claude/life-os.local.md` (global, portable across projects)

Use the first one found. If neither exists, tell the user:
> "life-os is not configured yet. Run `/setup` first, or copy your `life-os.local.md` to `~/.claude/` for global access."
Stop.

Load the time-energy-manager skill from this plugin. Execute the full Morning Plan workflow.

Parse arguments:
- Optional argument: energy level 1-5 (skips the energy check-in question)

Steps:
1. Query connected tools (or ask user if chat-only) for weekly review priorities, today's tasks, quarterly projects, and ideal week template (from config)
2. Ask energy level (if not provided as argument)
3. Generate adaptive daily plan with time blocks
4. Get user confirmation
5. Save plan to notes tool (or present in chat if notes_tool is none)
