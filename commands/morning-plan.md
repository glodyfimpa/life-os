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

Load the time-energy-manager skill from this plugin. Execute **Phase 1 — Morning Plan** exactly as defined in the skill, following ALL steps (1 through 5) without skipping any.

Parse arguments:
- Optional argument: energy level 1-5 (skips the energy check-in question in Step 2)

**IMPORTANT:** Follow the skill's Phase 1 steps completely. This includes:
- Step 1: Read ALL context sources (weekly review, tasks, projects, ideal week, calendar events if `calendar_tool != none`, actionable emails if `email_tool != none`)
- Step 2: Energy check-in
- Step 3: Generate adaptive plan (integrating email actions if any were accepted)
- Step 4: User confirmation
- Step 4.5: Calendar export offer (if `calendar_tool != none`)
- Step 5: Save plan to notes tool (or present in chat if `notes_tool = none`)
