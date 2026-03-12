---
description: Change life-os language and trigger phrases
allowed-tools: ["Read", "Edit", "AskUserQuestion"]
---

# Change Language

Updates the language setting and trigger phrases in your life-os config.

## Prerequisites

Look for the config file in this order:
1. `.claude/life-os.local.md` (project-level)
2. `~/.claude/life-os.local.md` (global, portable across projects)

Use the first one found. If neither exists:
> "life-os is not configured yet. Run `/setup` first, or copy your `life-os.local.md` to `~/.claude/` for global access."
Stop.

## Steps

### Step 1: Read current config

Read the config file found above. Extract the current `language` value from frontmatter and the current triggers from the "Trigger Mapping" section in the body.

Tell the user:
> "Current language: [language]. Current triggers:
> - Morning Plan: [list]
> - Evening Close: [list]
> - Weekly Review: [list]
> - Mid-day Check: [list]
> - Pivot: [list]"

### Step 2: Ask for new language

> "What language do you want to switch to?"

### Step 3: Generate new triggers

Based on the new language, generate appropriate trigger phrases for each category. Present them:

> "Here are the suggested triggers for [new language]:
>
> **Morning Plan:** [triggers]
> **Evening Close:** [triggers]
> **Weekly Review:** [triggers]
> **Mid-day Check:** [triggers]
> **Pivot:** [triggers]
>
> Want to change any of these?"

Let the user customize.

### Step 4: Update config

Use the Edit tool to:
1. Update `language: "[new value]"` in the frontmatter
2. Replace the entire "Trigger Mapping" section with the new triggers

### Step 5: Confirm

> "Language updated to [new language]. All commands will now respond in [new language]. Triggers updated."
