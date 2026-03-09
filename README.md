# life-os

Personal productivity system for Claude Code. GTD weekly reviews, energy-adaptive daily planning, and quarterly goal tracking — all connected to your Notion workspace.

## Install

```
/install-plugin glodyfimpa/life-os
```

## Getting Started

After installing, run the setup wizard:

```
/setup
```

The wizard walks you through:
1. Connecting your Notion databases (Tasks, Projects, Resources, Second Brain)
2. Choosing your language (English, Italian, or any language)
3. Defining your work schedule, commitments, and meetings
4. Configuring sprint cycles (optional)

Setup takes about 5 minutes and generates a personal config file at `.claude/life-os.local.md`. Add `*.local.md` to your `.gitignore` to keep personal data out of version control.

## Commands

| Command | What it does |
|---------|-------------|
| `/setup` | Full configuration wizard (first time or reconfigure everything) |
| `/change-language` | Change language and trigger phrases |
| `/update-schedule` | Update work hours, commitments, meetings, or sprint cycle |
| `/weekly-review` | Full 6-phase GTD weekly review: capture, inbox processing, project review, quarterly check, week ahead planning, summary to Notion |
| `/weekly-review inbox` | Phases 1-2 only: quick capture + inbox processing |
| `/weekly-review quarterly` | Phase 4 only: quarterly progress check |
| `/morning-plan` | Energy-adaptive daily planning: reads weekly priorities, generates time blocks, saves to Notion |
| `/morning-plan 4` | Same as above, skips energy question (pre-sets level 4) |
| `/evening-close` | Day review: what got done, energy rating, verdict, note for tomorrow |

Natural language triggers also work and are configured during setup.

## How it works

The plugin bundles two complementary skills that operate at different time horizons.

**Planning & Review System** handles the weekly and quarterly view. It runs a 30-minute weekly review in 6 phases: scanning Notion inbox and optional Gmail for unprocessed items, GTD-style inbox processing where each task gets triaged (do now, schedule, link to project, delete), project health check against quarterly goals, and a forward-looking "week ahead" exercise built around one decision, one metric, one reason. The output lands as a structured page in your Notion Second Brain.

**Time & Energy Manager** translates that weekly context into daily execution. The Morning Plan reads the latest weekly review, pulls today's tasks from Notion, checks your ideal week template for the current day, then asks for an energy rating 1-5. Based on that rating, it generates adaptive time blocks: high energy means deep creative work first, low energy means only essentials with extra breaks. It closes with three concrete priorities and permission to disconnect at the end of the day.

Mid-day Check and Evening Close complete the daily loop. The check-in compares afternoon energy against morning, recalibrates if needed, and handles post-work time based on your commitments. Evening Close reviews completions against the morning plan and delivers a verdict oriented toward permission to disconnect. Over time, energy data accumulates and the system surfaces patterns: which days drain energy, whether exercise days correlate with higher output, how different weeks compare.

A Pivot phase handles disruptions. When something urgent arrives mid-day, the system evaluates it against weekly priorities and applies a strict rule: nothing enters the plan without something else leaving.

## Decision criteria

The system enforces a priority hierarchy: Quarter > Week > Day. Weekly review goals set the frame, daily plans execute within it.

Energy levels drive scheduling strategy, not guilt. Level 1 means "protect yourself," not "push harder." The Evening Close verdict grants permission to stop, on the premise that rest produces better results than rumination.

Breaks are non-negotiable and built into every daily plan. The soft re-entry after lunch, the reset break before personal time, and the 90-minute deep work cap exist as fixed constraints.

## Prerequisites

- **Notion MCP** connected with access to your Tasks, Projects, Resources, and Second Brain databases
- **Gmail MCP** (optional) — adds email scanning to weekly reviews

## Recommended Notion Setup

life-os works best with this database structure (field names are configurable during setup):

**Tasks database:** Status (select: Not Started, In Progress, Done, Waiting For, Stand By), Next Action (checkbox), Due Date (date), Project (relation to Projects)

**Projects database:** Status (select: Inbox, In progress, Stand By, Done), Quarter (select: Q1-Q4, Someday), Legacy (checkbox), This Sprint (checkbox)

**Resources database:** Status (select: Inbox, To Review, Reviewed), Projects (relation)

## File tree

```
life-os/
  .claude-plugin/
    plugin.json
  commands/
    setup.md              # Configuration wizard
    change-language.md    # Language + trigger update
    update-schedule.md    # Schedule/meetings update
    weekly-review.md      # /weekly-review [phase]
    morning-plan.md       # /morning-plan [energy-level]
    evening-close.md      # /evening-close
  skills/
    planning-review-system/
      SKILL.md            # 6-phase weekly review workflow
      references/
        weekly-template.md   # Notion page template for review output
    time-energy-manager/
      SKILL.md            # 4-phase daily management workflow
      references/
        energy-patterns.md   # Pattern detection guide for energy data
  CONNECTORS.md
  README.md
```

User config (generated by `/setup`, not in the plugin):
```
.claude/
  life-os.local.md    # Personal config: Notion IDs, schedule, triggers, ideal week
```

## License

MIT
