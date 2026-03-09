---
description: Start the day with an energy-adaptive daily plan
argument-hint: [energy-level]
---

Run the Time & Energy Manager Morning Plan (Phase 1).

**First:** Check if `.claude/life-os.local.md` exists. If not, tell the user:
> "life-os is not configured yet. Run `/setup` first."
Stop.

Load the time-energy-manager skill from this plugin. Execute the full Morning Plan workflow.

Parse arguments:
- Optional argument: energy level 1-5 (skips the energy check-in question)

Steps:
1. Query Notion for weekly review priorities, today's tasks, quarterly projects, and ideal week template (from config)
2. Ask energy level (if not provided as argument)
3. Generate adaptive daily plan with time blocks
4. Get user confirmation
5. Save plan page to Notion (Second Brain page from config)
