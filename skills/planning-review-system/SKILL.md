---
name: planning-review-system
description: |
  Weekly review and quarterly planning system based on GTD methodology. Automates inbox processing, project review, and quarterly tracking with Notion integration. Use this skill when: starting a weekly review, processing inbox, checking quarterly progress, or asking about goal status. Triggers are defined in the user's config file (.claude/life-os.local.md). Requires Notion MCP connected. Optional: Gmail MCP for email scanning.
---

# Planning & Review System

Weekly review workflow (30 min) with GTD-based inbox processing and quarterly tracking. Outputs structured review pages to Notion.

## Config Guard

**BEFORE ANYTHING ELSE:** Check if `.claude/life-os.local.md` exists in the current project directory. If not, tell the user:
> "life-os is not configured yet. Run `/setup` first to connect your Notion databases and set your preferences."
Stop execution.

If it exists, read the file and parse:
- **Frontmatter (YAML):** database IDs, field mappings, language
- **Body (Markdown):** triggers, commitments, meetings, ideal week

All instructions below reference config values. Never use hardcoded database IDs or field names.

## Language

Respond in the language specified by the `language` field in the config. Format dates according to that language's conventions.

## Notion Filters (CRITICAL)

Apply these filters to ALL queries:

| Database | Filter | Reason |
|----------|--------|--------|
| Projects | `[project_legacy_field] = false` | Legacy/archived projects are excluded |
| Tasks | Varies by phase | See workflow below |

## Database References

Read all database IDs from config frontmatter:

- **Tasks:** value of `tasks_db`
- **Projects:** value of `projects_db`
- **Resources:** value of `resources_db`
- **Second Brain:** value of `second_brain_url`

## Workflow (6 Phases, 30 min total)

### Phase 1: Quick Capture (3 min)

**Automatic scans:**

1. **Notion Resources:** Query resources database where `[resource_status_field] = Inbox` or created in last 7 days without Project linked
2. **Gmail (if connected):** Unread emails, starred, or containing action keywords

Present count to user:
> "Found X Notion resources and Y emails to process. Review now or skip to inbox?"

### Phase 2: GTD Inbox Processing (10 min)

**Query:** Tasks database where `[task_status_field] = [task_status_not_started]`

For each item, ask:
1. Still relevant? (No → delete)
2. Takes < 2 minutes? (Yes → do now or delete)
3. If > 2 min → assign Project + Due Date

**Actions:** Do Now | Schedule | Link to Project | Waiting For | Delete

### Phase 3: Project Review (8 min)

**Query:** Projects database where `[project_status_field] IN (In progress, Stand By)` AND `[project_legacy_field] = false`

For each project check:
1. Has at least one Task with `[task_next_action_field] = true`?
2. Touched in last 7 days?
3. Still relevant to quarterly goals?

**Actions:** Keep Active | Stand By | Archive | Define Next Action

### Phase 4: Quarterly Check (3 min)

**Query:** Projects database where `[project_quarter_field] = Q[current quarter]` AND `[project_legacy_field] = false`

Calculate and present:
- % complete (Done / Total)
- Projects blocked or stalled
- Days remaining in quarter

If `goals_page_url` is set in config, reference that page for goals context.

### Phase 5: Week Ahead (4 min)

Apply the Golden Rule — ask user:

| Element | Question |
|---------|----------|
| **One decision** | What single thing, if completed this week, makes the biggest difference? |
| **One metric** | What metric will you track this week? |
| **One why** | Why does this matter to you this week? |

### Phase 6: Summary (2 min)

Create Notion page under the Second Brain page (from config):

**Title:** `Weekly Review — [date in configured language]`

**Content:** See `${CLAUDE_PLUGIN_ROOT}/skills/planning-review-system/references/weekly-template.md`

## Trigger Mapping

Read triggers from the "Trigger Mapping" section in the config body. Match user messages against the "Weekly Review" trigger list. Also match these functional patterns:

| User intent | Execute |
|-------------|---------|
| Mentions "weekly review" or matching trigger | Full workflow (Phases 1-6) |
| Mentions "inbox" or "process" trigger | Phases 1-2 only |
| Mentions quarter (Q1/Q2/Q3/Q4) or "quarterly" | Phase 4 only |
| Mentions "capture" | Phase 1 only |
| Asks about goal progress | Phase 4 + summary |

## Key Notion Fields

Read all field names from config. The expected structure:

**Tasks:**
- `[task_status_field]`: with values `[task_status_not_started]` / `[task_status_waiting]` / `[task_status_stand_by]` / `[task_status_in_progress]` / `[task_status_done]`
- `[task_next_action_field]`: checkbox (GTD flag for priority tasks)
- `[task_due_date_field]`: date
- `[task_project_field]`: relation to Projects

**Projects:**
- `[project_status_field]`: with configured status values
- `[project_quarter_field]`: Q1 / Q2 / Q3 / Q4 / Someday
- `[project_legacy_field]`: checkbox (if true, ALWAYS ignore)
- `[project_sprint_field]`: checkbox

**Resources:**
- `[resource_status_field]`: Inbox / To Review / Reviewed
- `[resource_project_field]`: relation (empty = potential item to process)

## Dependencies

| Service | Required | Purpose |
|---------|----------|---------|
| Notion MCP | Yes | All database operations |
| Gmail MCP | No | Email scan in Phase 1 (skip if not connected) |
