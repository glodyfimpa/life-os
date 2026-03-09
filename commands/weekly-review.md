---
description: Run a full weekly review with GTD inbox processing and quarterly check
argument-hint: [phase]
---

Run the Planning & Review System weekly review workflow.

**First:** Check if `.claude/life-os.local.md` exists. If not, tell the user:
> "life-os is not configured yet. Run `/setup` first."
Stop.

Load the planning-review-system skill from this plugin. Execute the full 6-phase workflow (30 min).

Parse arguments:
- Optional argument: specific phase to run
  - "inbox" → Phases 1-2 only
  - "quarterly" or "Q1"/"Q2"/"Q3"/"Q4" → Phase 4 only
  - "capture" → Phase 1 only
  - No argument → Full workflow (Phases 1-6)

Before starting, verify Notion MCP is connected. If Gmail MCP is available, include email scanning in Phase 1.
