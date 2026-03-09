---
description: Close the day with a review of what was accomplished
---

Run the Time & Energy Manager Evening Close (Phase 4).

**First:** Check if `.claude/life-os.local.md` exists. If not, tell the user:
> "life-os is not configured yet. Run `/setup` first."
Stop.

Load the time-energy-manager skill from this plugin. Execute the Evening Close workflow.

Steps:
1. Read today's plan from Notion (search Second Brain for today's date)
2. Ask what was completed
3. Get final energy rating
4. Deliver the verdict (always oriented toward permission to disconnect)
5. Capture note for tomorrow (optional)
6. Update Notion page with Evening Close section
