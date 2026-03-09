---
description: Configure life-os for your Notion workspace, schedule, and preferences
allowed-tools: ["Read", "Write", "Edit", "Bash", "AskUserQuestion", "Glob"]
---

# life-os Setup Wizard

Interactive configuration wizard. Creates `.claude/life-os.local.md` with all settings needed for the plugin to work.

**If `.claude/life-os.local.md` already exists**, warn the user:
> "life-os is already configured. Running setup again will overwrite your current config. Continue?"

If they decline, stop. If they confirm, proceed.

Respond in English by default. If the user writes in another language, mirror that language for the setup conversation.

---

## Phase 1: Notion Connection

This is the most critical phase. Without valid Notion database IDs, nothing works.

### Step 1: Explain what's needed

Tell the user:
> "life-os needs access to your Notion databases. You'll need 3-4 database URLs from Notion. Here's what each one is for:
>
> 1. **Tasks database** (required) — where your to-do items live
> 2. **Projects database** (required) — where your projects/goals are tracked
> 3. **Resources database** (required) — your reference materials, bookmarks, notes
> 4. **Second Brain page** (required) — a parent page where life-os will save weekly reviews and daily plans
> 5. **Planning board** (optional) — if you use a weekly kanban/board view for task scheduling
> 6. **Goals/planning page** (optional) — a page with your quarterly or yearly goals
>
> To get a database URL: open it in Notion, click Share, and copy the link."

### Step 2: Collect database URLs

Ask for each one, one at a time. For each URL provided:

1. Use the Notion MCP `fetch` tool to validate it exists and is accessible
2. Extract the data source ID from the `<data-source>` tag in the response
3. Read the schema to identify available properties

If a fetch fails, tell the user and ask them to check the URL and Notion MCP permissions.

Store the validated IDs as:
- `tasks_db` — the data source collection:// URL
- `projects_db` — the data source collection:// URL
- `resources_db` — the data source collection:// URL
- `second_brain_url` — the page URL
- `planning_board_db` — the data source collection:// URL (or empty)
- `goals_page_url` — the page URL (or empty)

### Step 3: Field mapping

For the Tasks database, look for these fields in the schema and map them:

| Expected field | Purpose | Recommended name |
|---|---|---|
| Title field | Task name | (whatever the title property is called) |
| Status field | Task status with values like Not Started, In Progress, Done | "Status" |
| Next action flag | Boolean/checkbox for GTD next actions | "Next Action" |
| Due date | Date field | "Due Date" |
| Project relation | Relation to Projects database | "Project" |

For the Projects database:

| Expected field | Purpose | Recommended name |
|---|---|---|
| Title field | Project name | (whatever the title property is called) |
| Status field | Project status | "Status" |
| Quarter field | Which quarter (Q1-Q4, Someday) | "Quarter" |
| Legacy/archive flag | Boolean to mark archived projects | "Legacy" |
| Sprint flag | Boolean for current sprint | "This Sprint" |

For the Resources database:

| Expected field | Purpose | Recommended name |
|---|---|---|
| Status field | Processing status (Inbox, Reviewed, etc.) | "Status" |
| Project relation | Link to Projects | "Projects" |

**Auto-detection:** Try to match schema property names to the expected fields above. Present the mapping to the user:

> "I found these fields in your databases. Please confirm or correct:
>
> **Tasks:** Status → 'Status', Next Action → 'Next Action', Due Date → 'Due Date', Project → 'Project'
> **Projects:** Status → 'Status', Quarter → 'Quarter', Legacy → 'Legacy', Sprint → 'This Sprint'
> **Resources:** Status → 'Status', Projects → 'Projects'"

Let the user correct any field names. Also ask for the status values:

> "What are the status values in your Tasks database? (common: Not Started, In Progress, Done, Waiting For, Stand By)"

Do the same for Projects status values.

---

## Phase 2: Language

Ask the user:
> "What language should life-os use for messages and daily plans? (e.g., English, Italian, French, Portuguese, Spanish)"

Based on the answer, generate a set of default natural language triggers. Present them and let the user customize:

> "Here are the default triggers for [language]. You can change or add more:
>
> **Morning Plan:** [good morning], [morning plan], [plan my day]
> **Evening Close:** [I'm done], [evening close], [can I relax?]
> **Weekly Review:** [weekly review], [process inbox]
> **Pivot:** [emergency], [change of plans], [something came up]
> **Energy Check:** [how am I doing?], [energy check]
>
> Want to change any of these?"

For common languages, use appropriate translations. For less common ones, ask the user to provide the trigger phrases.

---

## Phase 3: Schedule

### Work schedule

> "Let's set up your work schedule."

Ask:
1. "Which days do you work?" (default: Mon-Fri)
2. "What are your work hours?" (default: 09:00-17:00)
3. "Do you have a morning routine before work? If so, what time does it start?" (default: none)
4. "When is your lunch break?" (default: 12:30-13:00)

### Personal project window

> "life-os reserves a 'golden window' each morning for personal projects, study, or side business — before your work meetings start. Do you want to set one up?"

If yes:
- "What time range?" (suggest: first hour of work day, e.g., 09:00-10:00)

If no:
- Set `personal_project_window` to empty

### Fixed weekly commitments

> "Do you have recurring weekly commitments outside of work? (gym, childcare, classes, etc.)
> For each one, I need: name, which days, time range, and whether it blocks your evening (meaning no personal projects after)."

Collect each commitment interactively. Example interaction:

> User: "Gym Monday and Thursday 17:30-19:00"
> Claude: "Got it. Does gym block your evening? (meaning no personal project time after)"
> User: "Yes"

Continue until user says they're done.

### Recurring meetings

> "Do you have recurring work meetings? For each one, I need: name, which days, and time.
> If meetings differ by week (e.g., sprint ceremonies every other week), tell me and we'll handle that in the sprint cycle phase."

Collect each meeting. Continue until user says they're done.

---

## Phase 4: Sprint Cycle (optional)

> "Do you work in sprint/iteration cycles? (e.g., 2-week sprints with alternating ceremony weeks)"

If no: set `sprint_cycle_enabled: false`, skip to Phase 5.

If yes:
1. "How long are your sprints?" (default: 2 weeks)
2. "Do you have two types of weeks (e.g., Week A with sprint ceremonies, Week B without)?"
3. If yes: "Which week are we in right now — A or B?" (this calibrates the even/odd parity)
4. "What sprint-specific meetings happen in each week type?"

Collect sprint ceremony details for Week A and Week B.

---

## Phase 5: Generate Config

### Build the config file

Using all collected data, generate `.claude/life-os.local.md` with this structure:

```markdown
---
# === Notion Databases ===
tasks_db: "[collected value]"
projects_db: "[collected value]"
resources_db: "[collected value]"
second_brain_url: "[collected value]"
planning_board_db: "[collected value or empty]"
goals_page_url: "[collected value or empty]"

# === Language ===
language: "[collected value]"

# === Schedule ===
work_days: "[collected value, e.g. Mon,Tue,Wed,Thu,Fri]"
work_start: "[collected value]"
work_end: "[collected value]"
morning_routine_start: "[collected value or empty]"
morning_routine_end: "[collected value or empty]"
lunch_start: "[collected value]"
lunch_end: "[collected value]"
personal_project_window: "[collected value or empty]"

# === Sprint Cycle ===
sprint_cycle_enabled: [true/false]
sprint_week_a_parity: "[even/odd or empty]"

# === Notion Field Mapping — Tasks ===
task_status_field: "[collected value]"
task_status_not_started: "[collected value]"
task_status_in_progress: "[collected value]"
task_status_done: "[collected value]"
task_status_waiting: "[collected value]"
task_status_stand_by: "[collected value]"
task_next_action_field: "[collected value]"
task_due_date_field: "[collected value]"
task_project_field: "[collected value]"

# === Notion Field Mapping — Projects ===
project_status_field: "[collected value]"
project_status_values: "[comma-separated list]"
project_quarter_field: "[collected value]"
project_legacy_field: "[collected value]"
project_sprint_field: "[collected value]"

# === Notion Field Mapping — Resources ===
resource_status_field: "[collected value]"
resource_project_field: "[collected value]"
---

# Trigger Mapping

## Morning Plan
[list of triggers, one per line with - prefix]

## Evening Close
[list of triggers]

## Weekly Review
[list of triggers]

## Mid-day Check
[list of triggers]

## Pivot
[list of triggers]

# Fixed Commitments

[For each commitment:]
## [Name]
- Days: [days]
- Time: [start]-[end]
- Blocks evening: [yes/no]

# Recurring Meetings

[For each meeting:]
## [Name]
- Days: [days]
- Time: [start]-[end]
[- Week type: A/B (if sprint-specific)]

# Ideal Week

[Generate a complete day-by-day schedule table for each work day, combining:
- Morning routine (if configured)
- Personal project window (if configured)
- Work hours with deep work blocks
- All recurring meetings placed in correct time slots
- Lunch break
- Non-negotiable breaks (every 90 min, post-meeting resets, soft re-entry after lunch)
- Fixed commitments placed in correct days
- Post-work personal project window on days NOT blocked by commitments
- Evening Close slot before end of day
- OFF time after commitments or end of work

Use this format for each day:]

## [Day name]
| Time | Activity | Type |
|------|----------|------|
| [start]-[end] | [activity] | [Fixed/Work/Personal/Break/Plugin/Family/OFF] |

[For weekend days, generate a lighter template:]

## Saturday
| Activity | Notes |
|----------|-------|
| Rest and personal time | Morning |
| Personal projects (optional) | 1-2 hours when possible |
| Rest and personal time | Afternoon/evening |

## Sunday
| Activity | Notes |
|----------|-------|
| Full rest, zero plans | All day |
| Weekly Review (optional) | Evening, to prepare the week |
```

### Write the file

Use the Write tool to create `.claude/life-os.local.md` in the current project directory.

### Break rules embedded in ideal week

When generating the ideal week, ALWAYS apply these break rules:
1. **Never more than 90 consecutive minutes of deep work** — add 10-15 min break
2. **After long meetings (>1h)** — add 5-10 min micro-reset
3. **After lunch** — soft re-entry block (30-45 min), no deep work
4. **Pre-evening transition** — reset break before any personal project time
5. **Breaks are NON-NEGOTIABLE** — they appear in the schedule as fixed items

### Final confirmation

Tell the user:
> "Setup complete! Your config is saved at `.claude/life-os.local.md`.
>
> Remember to add `.claude/*.local.md` to your `.gitignore` to keep your personal data out of version control.
>
> Try `/morning-plan` to test your setup!"
