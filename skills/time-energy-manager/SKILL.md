---
name: time-energy-manager
description: |
  Daily time and energy management system with 4 phases: Morning Plan, Mid-day Check, Pivot, Evening Close. Complements the planning-review-system by translating weekly priorities into daily execution with energy-adaptive scheduling. Use this skill when: starting the day, checking energy levels, handling schedule changes, or closing the day. Triggers are defined in the user's config file (.claude/life-os.local.md). Requires Notion MCP connected.
---

# Time & Energy Manager

Daily time and energy management system in 4 phases. Operational complement to the planning-review-system: PRS looks back and up (weekly review, quarter), TEM looks forward and down (what you do today, with how much energy).

**Principle:** Don't do more. Do what matters, then live.

## Config Guard

**BEFORE ANYTHING ELSE:** Check if `.claude/life-os.local.md` exists in the current project directory. If not, tell the user:
> "life-os is not configured yet. Run `/setup` first to connect your Notion databases and set your preferences."
Stop execution.

If it exists, read the file and parse:
- **Frontmatter (YAML):** database IDs, field mappings, language, schedule settings
- **Body (Markdown):** triggers, fixed commitments, recurring meetings, ideal week

All instructions below reference config values. Never use hardcoded database IDs, field names, or schedule times.

## Language

Respond in the language specified by the `language` field in the config. Format dates according to that language's conventions.

## Database References

Read all database IDs from config frontmatter:

- **Tasks:** value of `tasks_db`
- **Projects:** value of `projects_db`
- **Planning board:** value of `planning_board_db` (may be empty)
- **Second Brain:** value of `second_brain_url`

## Critical Filters

| Database | Filter | Reason |
|----------|--------|--------|
| Projects | `[project_legacy_field] = false` | Ignore archived projects |
| Tasks | `[task_status_field] != [task_status_done]` AND `[task_due_date_field] = today` | Only active tasks for today |
| Planning | Day-based filter (if planning board is configured) | Tasks assigned to today |

## Phase 1 — Morning Plan (5 min)

**Triggers:** Read from "Morning Plan" section in config trigger mapping.

### Step 1: Read context (automatic)

Query Notion in parallel:

1. **Latest Weekly Review:** Search in Second Brain for the most recent page with title starting "Weekly Review —". Extract: weekly priorities, metric, why.
2. **Today's tasks:** From Tasks database, filter `[task_status_field] != [task_status_done]` AND (`[task_due_date_field] = today` OR `[task_due_date_field]` is overdue). If planning board is configured, also query it for today's day.
3. **Quarter projects:** From Projects database, filter `[project_quarter_field] = Q[current quarter]` AND `[project_status_field] = In progress` AND `[project_legacy_field] = false`.
4. **Ideal Week:** Read the "Ideal Week" section from config body for today's day name. If sprint cycle is enabled, determine if it's Sprint Week A or B using the configured parity.

### Step 2: Energy check-in (30 sec)

Ask the user:
> "How are you feeling this morning? (1-5)"

If the user wants to add context (optional):
> "Anything specific weighing on you or giving you energy today?"

### Step 3: Generate adaptive plan

Based on: weekly priorities + today's tasks + energy + ideal week template for today.

**Energy logic:**

| Energy | Strategy |
|--------|----------|
| 4-5 | Creative deep work first, admin after. Propose ambitious tasks for the first focus block. |
| 3 | Important but non-creative tasks. Alternate focus and breaks. First block for study/review. |
| 1-2 | Essential tasks and deadlines only. Protect energy. First focus block optional. Suggest extra breaks. |

**Block structure:** Use today's template from the "Ideal Week" section in config. Adapt based on energy level. Use these icons:

- Deep focus: relevant icon
- Light work: relevant icon
- Break: relevant icon
- Personal: relevant icon
- Family/personal time: relevant icon
- Meeting: relevant icon

**ALWAYS close with:**
> "Today if you do [X], [Y], and [Z] — tonight you can disconnect."

Where X, Y, Z are the 3 real priorities for the day (not all tasks, only the ones that matter).

### Step 4: User confirmation

Present the plan and ask:
> "Does this work or do you want to change something?"

If the user modifies, adapt. If confirmed, proceed.

### Step 5: Save to Notion

Create a page under Second Brain with:
- **Title:** `Plan [date in configured language]`
- **Content:** the complete plan with blocks, energy, weekly priorities

Page structure:

```markdown
## Plan [date]

**Morning energy:** [N]/5
**Context:** [optional note or "—"]
**Weekly priority:** [from weekly review]
**Week type:** [Sprint A / Sprint B / Standard]

### Today's Blocks
[block list from generated plan]

**Daily goal:** If you do [X], [Y], [Z] — tonight you can disconnect.

---
### Afternoon Check-in
[completed by Phase 2]

---
### Evening Close
[completed by Phase 4]
```

## Phase 2 — Mid-day Check (1 min)

**Triggers:** Read from "Mid-day Check" section in config trigger mapping.

### Step 1: Energy rating

> "Energy right now? (1-5)"

### Step 2: Compare with morning

Read today's Plan page from Notion (search in Second Brain for "Plan [today's date]").

- If drop > 2 points from morning: "Significant drop. I suggest lightening the afternoon."
- If stable or rising: "Energy is stable, keep going."

### Step 3: Quick status

> "Of this morning's priorities ([X], [Y], [Z]), what did you get done?"

- If on track: "You're doing well. This afternoon focus on [remaining priority]."
- If behind: recalibrate without judgment. "OK, [X] is still open. Want to put it in the afternoon focus block or move it to tomorrow?"

### Step 4: Post-work logic

Read "Fixed Commitments" from config body. Check if today has a commitment that blocks the evening. If today is NOT blocked:

| Current energy | Suggestion |
|----------------|------------|
| >= 3 | "After work you have the personal time window. Reset break first, then [personal task]." |
| 2 | "Low energy. If you want, 20 min of something light after work. No coding." |
| 1 | "You've given enough today. After work, go straight to relax. Zero guilt." |

If today IS blocked by a commitment:
> "You have [commitment name] after work today. Plan is to wrap up and head there."

### Step 5: Update Notion

Update today's Plan page, "Afternoon Check-in" section:

```markdown
### Afternoon Check-in
**Energy:** [N]/5 | Completed: [list] | Remaining: [list] → [action]
```

## Phase 3 — Pivot (2 min)

**Triggers:** Read from "Pivot" section in config trigger mapping.

### Step 1: Gather info

> "What happened? Describe the new thing."

### Step 2: Honest evaluation

Read today's Plan page and weekly priorities from the weekly review. Compare:

> "The weekly priority is [X]. Is this new thing more important? Let's see."

**Decision matrix:**

| The new thing... | Action |
|------------------|--------|
| Has a deadline today and impacts the client/stakeholder | "Yes, it's a priority. Let's remove [less urgent task] from the plan." |
| Important but not urgent | "Not urgent. I suggest scheduling it for [day with space] and keeping the plan." |
| Someone else's request, not critical | "Someone else can wait. Your priority today is [X]. Reply later." |
| Anxiety/reactivity, not real urgency | "Stop. This feels urgent but it's not. This morning's plan is still valid." |

**Principle: NEVER add without removing.** If something enters the plan, explicitly ask:
> "OK, we're adding [new thing]. What do we remove? Options: [A], [B], [C]."

### Step 3: Confirm

> "Do you want to proceed with the switch or keep the original plan?"

### Step 4: Update Notion

If the user changes the plan, update the daily page with the new blocks. Add note:
> "Pivot at [time]: [reason]. Removed [X], added [Y]."

## Phase 4 — Evening Close (2 min)

**Triggers:** Read from "Evening Close" section in config trigger mapping.

### Step 1: Read the plan

Retrieve today's Plan page from Notion. Read the 3 priorities and planned blocks.

### Step 2: What did you complete?

> "What did you complete today?"

Or, if the Notion tasks are updated, deduce it from status changes.

### Step 3: Final energy rating

> "End-of-day energy? (1-5)"

### Step 4: The verdict

Compare planned priorities vs completed:

| Situation | Message |
|-----------|---------|
| All 3 priorities done | "You did what mattered. Relax, you earned it." |
| 2 of 3 done, the third not critical | "Solid day. [Missing task] can wait until tomorrow. Disconnect." |
| 1 of 3 or less, but with good reason (pivot, low energy) | "Imperfect day but you protected what was possible. That's fine." |
| Day went badly | "It happens to everyone. Tomorrow we recalibrate with the Morning Plan. Tonight disconnect anyway — ruminating doesn't produce results, rest does." |

**IMPORTANT:** The verdict is ALWAYS oriented toward permission to disconnect. Never close with "you should have done more." Guilt doesn't produce results, rest does.

### Step 5: Note for tomorrow

> "Anything to remember for tomorrow morning?"

If yes, note it. If no, skip.

### Step 6: Update Notion

Update today's Plan page, "Evening Close" section:

```markdown
### Evening Close
**Evening energy:** [N]/5
**Completed:** [list]
**Not completed:** [list + brief reason]
**Verdict:** [message from the verdict]
**Note for tomorrow:** [text or "—"]
```

## Trigger Mapping

Read triggers from the "Trigger Mapping" section in config body. Match user messages against the appropriate trigger list for each phase. Also use time-based defaults:

| Time | Default |
|------|---------|
| Before 2 hours into the workday (and no Plan exists today in Notion) | Suggest Phase 1 |
| Middle of the workday | Suggest Phase 2 |
| Last hour of workday or after | Suggest Phase 4 |
| Urgency words at any time | Phase 3 always |

## Extra Commands

| User intent | Action |
|-------------|--------|
| "ideal week" / "show me the week" | Show the ideal week template from config body for the current day |
| "what week is it?" / "sprint A or B?" | Calculate ISO week from date, apply configured parity |
| "energy patterns" / "trend" | Analysis from `${CLAUDE_PLUGIN_ROOT}/skills/time-energy-manager/references/energy-patterns.md` using Plan pages from the last 2+ weeks |
| "customize schedule" / "update my week" | Direct the user to run `/update-schedule` |

## Dependencies

| Service | Required | Purpose |
|---------|----------|---------|
| Notion MCP | Yes | All database operations + page creation |
| planning-review-system | No (but recommended) | Morning Plan reads weekly review. Without PRS, that context is skipped. |

## Principles (ALWAYS apply)

1. **Zero overload** — every touchpoint < 5 min, only the Morning Plan is recommended, the rest is optional
2. **Quarter > Week > Day** — the priority hierarchy is always respected
3. **Never add without removing** — if something enters the plan, something else leaves
4. **Permission to disconnect** — the Evening Close exists to tell you "you've done enough"
5. **Radical honesty** — if something is not a priority, the skill says so clearly
6. **Respect the rhythm** — never suggest waking up at 6 AM or sacrificing family/rest
7. **Non-negotiable breaks** — built into the plan, not optional
