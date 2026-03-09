---
description: Configure life-os with your preferred tools, schedule, and preferences
allowed-tools: ["Read", "Write", "Edit", "Bash", "AskUserQuestion", "Glob"]
---

# life-os Setup Wizard

Interactive configuration wizard. Creates `.claude/life-os.local.md` with all settings needed for the plugin to work.

**If `.claude/life-os.local.md` already exists**, warn the user:
> "life-os is already configured. Running setup again will overwrite your current config. Continue?"

If they decline, stop. If they confirm, proceed.

Respond in English by default. If the user writes in another language, mirror that language for the setup conversation.

---

## Phase 1: Tool Selection & Connection

life-os works with any combination of tools — or no tools at all.

### Step 1: Ask which tools the user wants to connect

> "life-os can work with external tools via MCP, or in chat-only mode where everything happens in our conversation.
>
> Let's pick your tools:
>
> **A) Task & project database** — where your tasks, projects, and resources live
> Options: Notion (recommended), Airtable, Linear, other, or none
>
> **B) Calendar** — to read today's events and merge with your ideal week
> Options: Google Calendar, Outlook Calendar, other, or none
>
> **C) Email** — to scan unread emails during weekly reviews
> Options: Gmail, Outlook, or none
>
> Which tools do you want to connect? You can always change this later by running `/setup` again."

Store the choices as:
- `task_tool`: "notion" | "airtable" | "linear" | "other" | "none"
- `calendar_tool`: "gcal" | "outlook" | "other" | "none"
- `email_tool`: "gmail" | "outlook" | "other" | "none"

### Step 2: Notes output

If `task_tool` is "notion" or another tool that supports page creation:
> "Should life-os save daily plans and weekly reviews to your [tool]? (recommended)"
If yes: `notes_tool` = same as `task_tool`
If no: `notes_tool` = "none"

If `task_tool` is "none":
`notes_tool` = "none"

> If `notes_tool` = "none": "Chat-only output mode. I'll present all plans and reviews directly in our conversation as formatted messages."

### Step 3: Connect and validate each selected tool

**If `task_tool != "none"`:**

Tell the user:
> "Make sure the MCP server for [tool name] is connected to Claude Code.
>
> I need access to these databases:
> 1. **Tasks database** (required) — where your to-do items live
> 2. **Projects database** (required) — where your projects/goals are tracked
> 3. **Resources database** (required) — your reference materials, bookmarks, notes
> 4. **Output page** (required) — a parent page where life-os will save weekly reviews and daily plans
> 5. **Planning board** (optional) — if you use a weekly kanban/board view for task scheduling
> 6. **Goals/planning page** (optional) — a page with your quarterly or yearly goals
>
> Share the URL or ID for each one."

Ask for each one, one at a time. For each URL/ID provided:

1. Use the appropriate MCP tool to validate it exists and is accessible:
   - Notion: use `fetch` tool, extract data source ID from `<data-source>` tag
   - Airtable/Linear/other: use the tool's equivalent list/read operation
2. Read the schema to identify available properties
3. If validation fails, tell the user and ask them to check the URL and MCP connection

Store the validated IDs as:
- `tasks_db` — the tool-specific database identifier
- `projects_db` — the tool-specific database identifier
- `resources_db` — the tool-specific database identifier
- `output_page_url` — the page/container URL where output is saved
- `planning_board_db` — the tool-specific identifier (or empty)
- `goals_page_url` — the page URL (or empty)

**If `calendar_tool != "none"`:**

> "Let me verify the calendar connection."

Try a basic operation (e.g., list today's events) to confirm the MCP is working.

> "Which calendar should I read? (default: primary)"

Store as `calendar_id` (default: "primary").

**If `email_tool != "none"`:**

> "Let me verify the email connection."

Try a basic operation (e.g., get profile) to confirm the MCP is working.

**If ALL tools are "none":**

> "You're set up in chat-only mode! Here's how it works:
> - For morning plans, I'll ask you about your tasks and energy, then present a plan
> - For weekly reviews, I'll walk you through each GTD phase conversationally
> - For evening closes, we'll review the day together
>
> Everything stays in our conversation. No external tools needed."

### Step 4: Field mapping (only if `task_tool != "none"`)

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
# === Connected Tools ===
task_tool: "[none | notion | airtable | linear | other]"
calendar_tool: "[none | gcal | outlook | other]"
notes_tool: "[none | notion | airtable | other]"
email_tool: "[none | gmail | outlook | other]"

# === Tool Connections (only present if task_tool != "none") ===
tasks_db: "[tool-specific identifier]"
projects_db: "[tool-specific identifier]"
resources_db: "[tool-specific identifier]"
output_page_url: "[page/container URL for saving output]"
planning_board_db: "[tool-specific identifier or empty]"
goals_page_url: "[page URL or empty]"

# === Calendar (only present if calendar_tool != "none") ===
calendar_id: "[calendar identifier, default: primary]"

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

# === Field Mapping — Tasks (only present if task_tool != "none") ===
task_status_field: "[collected value]"
task_status_not_started: "[collected value]"
task_status_in_progress: "[collected value]"
task_status_done: "[collected value]"
task_status_waiting: "[collected value]"
task_status_stand_by: "[collected value]"
task_next_action_field: "[collected value]"
task_due_date_field: "[collected value]"
task_project_field: "[collected value]"

# === Field Mapping — Projects (only present if task_tool != "none") ===
project_status_field: "[collected value]"
project_status_values: "[comma-separated list]"
project_quarter_field: "[collected value]"
project_legacy_field: "[collected value]"
project_sprint_field: "[collected value]"

# === Field Mapping — Resources (only present if task_tool != "none") ===
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
> **Mode:** [Full integration / Partial / Chat-only] with [list connected tools or "no external tools"]
>
> Remember to add `.claude/*.local.md` to your `.gitignore` to keep your personal data out of version control.
>
> Try `/morning-plan` to test your setup!"
