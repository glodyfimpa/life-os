---
description: Update your work schedule, commitments, meetings, or sprint cycle
allowed-tools: ["Read", "Edit", "Write", "AskUserQuestion"]
---

# Update Schedule

Modifies schedule-related sections of your life-os config and regenerates the ideal week.

## Prerequisites

Look for the config file in this order:
1. `.claude/life-os.local.md` (project-level)
2. `~/.claude/life-os.local.md` (global, portable across projects)

Use the first one found. If neither exists:
> "life-os is not configured yet. Run `/setup` first, or copy your `life-os.local.md` to `~/.claude/` for global access."
Stop.

## Steps

### Step 1: Read current config

Read the config file found above. Extract and summarize the current schedule:

> "Here's your current setup:
>
> **Work:** [days], [start]-[end]
> **Lunch:** [start]-[end]
> **Personal project window:** [window or 'none']
> **Morning routine:** [times or 'none']
>
> **Commitments:**
> [list each with days and times]
>
> **Recurring meetings:**
> [list each with days and times]
>
> **Sprint cycle:** [enabled/disabled, week type if enabled]
>
> What would you like to change?"

### Step 2: Collect changes

Based on the user's response, update the relevant section(s). Common scenarios:

**Changing work hours:**
> "New work hours? (e.g., 08:30-16:30)"

**Adding a commitment:**
> "Name, days, time range, and does it block your evening?"

**Removing a commitment:**
> "Which commitment do you want to remove?"

**Adding/changing a meeting:**
> "Meeting name, days, and time?"

**Removing a meeting:**
> "Which meeting do you want to remove?"

**Changing sprint cycle:**
> "Do you want to enable/disable sprint cycles? Or recalibrate which week is A/B?"

**Changing personal project window:**
> "New time range for personal projects? Or disable it?"

Continue collecting changes until the user confirms they're done.

### Step 3: Update config

Use the Edit tool to update the relevant frontmatter fields and body sections:

1. Update frontmatter schedule fields if changed (work_days, work_start, work_end, etc.)
2. Update frontmatter sprint fields if changed
3. Update "Fixed Commitments" section in body if commitments changed
4. Update "Recurring Meetings" section in body if meetings changed

### Step 4: Regenerate ideal week

After all changes are applied, regenerate the entire "Ideal Week" section based on the updated config. Apply the same generation rules as `/setup`:

- Place morning routine, personal project window, meetings, deep work blocks, breaks, commitments
- Apply break rules: 90-min deep work cap, post-meeting resets, soft re-entry after lunch, pre-evening transition
- Breaks are non-negotiable fixed items
- Post-work personal time only on days not blocked by commitments

Replace the old "Ideal Week" section with the regenerated one.

### Step 5: Confirm

> "Schedule updated and ideal week regenerated. Here's a summary of changes:
> [list what changed]
>
> The updated schedule will be used starting from your next `/morning-plan`."
