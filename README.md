```
 _ _  __                      
| (_)/ _| ___        ___  ___ 
| | | |_ / _ \_____ / _ \/ __|
| | |  _|  __/_____| (_) \__ \
|_|_|_|  \___|      \___/|___/
```

A Claude Code plugin for personal productivity.

GTD weekly reviews, energy-adaptive daily planning, and quarterly goal tracking. Works with your favorite tools (Notion, Google Calendar, Gmail) or in chat-only mode. Connect what you have, skip what you don't.

## Install

Inside a Claude Code session:

```
/plugin marketplace add glodyfimpa/life-os
/plugin install life-os@life-os
```

Or from the terminal:

```bash
claude plugin marketplace add glodyfimpa/life-os
claude plugin install life-os@life-os
```

Or interactively inside Claude Code:

```
/plugin marketplace add glodyfimpa/life-os
/plugin
```

Then go to the **Discover** tab, select `life-os`, and choose a scope (user, project, or local).

Verify with `/plugin list` (or `claude plugin list`). You should see `life-os@life-os — Status: ✔ enabled`. Restart Claude Code after installing so the new slash commands are registered.

After installing, run the setup wizard:

```
/setup
```

Setup takes about 5 minutes: choose your tools, connect and validate them, pick a language, define your schedule. It generates a config file at `.claude/life-os.local.md`. Add `*.local.md` to your `.gitignore` to keep personal data out of version control.

## Update

```
/plugin marketplace update life-os
```

To receive updates automatically:

1. Run `/plugin`
2. Go to the **Marketplaces** tab
3. Select `life-os`
4. Select **Enable auto-update**

### Team setup

Pre-enable the plugin in `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "life-os@life-os": true
  },
  "extraKnownMarketplaces": {
    "life-os": {
      "source": {
        "source": "github",
        "repo": "glodyfimpa/life-os"
      }
    }
  }
}
```

## Prerequisites

life-os works in three modes depending on which tools you connect:

| Mode | What you connect | How it works |
|------|-----------------|--------------|
| **Full integration** | Task DB + Calendar + Email | Reads tasks and events automatically, saves plans and reviews to your tool |
| **Partial** | Some tools connected | Connected tools work automatically; missing tools use conversational fallbacks |
| **Chat-only** | Nothing | You tell life-os your tasks and schedule; plans and reviews appear as chat messages |

Supported tools (any tool with an MCP server works):

| Category | Recommended | Alternatives |
|----------|-------------|-------------|
| Task & project database | Notion | Airtable, Linear, or any MCP-compatible tool |
| Calendar | Google Calendar | Outlook Calendar, or any MCP-compatible tool |
| Email | Gmail | Outlook, or any MCP-compatible tool |

## Commands

| Command | Does |
|---------|------|
| `/setup` | Full configuration wizard (first time or reconfigure everything) |
| `/change-language` | Change language and trigger phrases |
| `/update-schedule` | Update work hours, commitments, meetings, or sprint cycle |
| `/weekly-review` | Full 6-phase GTD weekly review: capture, inbox processing, project review, quarterly check, week ahead planning, summary |
| `/weekly-review inbox` | Phases 1-2 only: quick capture + inbox processing |
| `/weekly-review quarterly` | Phase 4 only: quarterly progress check |
| `/morning-plan` | Energy-adaptive daily planning: reads weekly priorities, generates time blocks |
| `/morning-plan 4` | Same as above, skips energy question (pre-sets level 4) |
| `/evening-close` | Day review: what got done, energy rating, verdict, note for tomorrow |

Natural language triggers also work and are configured during setup.

## How it works

The plugin bundles two complementary skills that operate at different time horizons.

**Planning & Review System** handles the weekly and quarterly view. It runs a 30-minute weekly review in 6 phases: scanning your task database inbox and optional email for unprocessed items, GTD-style inbox processing where each task gets triaged (do now, schedule, link to project, delete), project health check against quarterly goals, and a forward-looking "week ahead" exercise built around one decision, one metric, one reason. The output is saved to your connected tool or presented in chat.

**Time & Energy Manager** translates that weekly context into daily execution. The Morning Plan reads the latest weekly review, pulls today's tasks, checks your calendar (if connected) and ideal week template, then asks for an energy rating 1-5. Based on that rating, it generates adaptive time blocks: high energy means deep creative work first, low energy means only essentials with extra breaks. It closes with three concrete priorities and permission to disconnect at the end of the day.

Mid-day Check and Evening Close complete the daily loop. The check-in compares afternoon energy against morning, recalibrates if needed, and handles post-work time based on your commitments. Evening Close reviews completions against the morning plan and delivers a verdict oriented toward permission to disconnect. Over time, energy data accumulates and the system surfaces patterns: which days drain energy, whether exercise days correlate with higher output, how different weeks compare.

A Pivot phase handles disruptions. When something urgent arrives mid-day, the system evaluates it against weekly priorities and applies a strict rule: nothing enters the plan without something else leaving.

## Decision criteria

The system enforces a priority hierarchy: Quarter > Week > Day. Weekly review goals set the frame, daily plans execute within it.

Energy levels drive scheduling strategy, not guilt. Level 1 means "protect yourself," not "push harder." The Evening Close verdict grants permission to stop, on the premise that rest produces better results than rumination.

Breaks are non-negotiable and built into every daily plan. The soft re-entry after lunch, the reset break before personal time, and the 90-minute deep work cap exist as fixed constraints.

## Recommended Notion Setup

If you choose Notion as your task database, life-os works best with this structure (field names are configurable during setup):

**Tasks database:** Status (select: Not Started, In Progress, Done, Waiting For, Stand By), Next Action (checkbox), Due Date (date), Project (relation to Projects)

**Projects database:** Status (select: Inbox, In progress, Stand By, Done), Quarter (select: Q1-Q4, Someday), Legacy (checkbox), This Sprint (checkbox)

**Resources database:** Status (select: Inbox, To Review, Reviewed), Projects (relation)

## Structure

```
life-os/                                             the plugin
├── .claude-plugin/
│   └── plugin.json                                  plugin manifest
├── commands/
│   ├── setup.md                                     configuration wizard
│   ├── change-language.md                           language + trigger update
│   ├── update-schedule.md                           schedule/meetings update
│   ├── weekly-review.md                             /weekly-review [phase]
│   ├── morning-plan.md                              /morning-plan [energy-level]
│   └── evening-close.md                             /evening-close
├── skills/
│   ├── planning-review-system/
│   │   ├── SKILL.md                                 6-phase weekly review workflow
│   │   └── references/
│   │       └── weekly-template.md                   page template for review output
│   └── time-energy-manager/
│       ├── SKILL.md                                 4-phase daily management workflow
│       └── references/
│           └── energy-patterns.md                   pattern detection guide for energy data
├── scripts/
│   └── sync-skills.sh                               sync skills from claude-skills repo
├── CONNECTORS.md                                    tool-agnostic connector docs
└── README.md
```

User config (generated by `/setup`, not in the plugin):

```
.claude/
  life-os.local.md                                   personal config: tools, schedule, triggers
```

6 commands, 2 skills, 1 sync script, 2 reference files. No hooks, no agents.

## Development

**This section is for contributors to the plugin codebase, not for end users.** If you installed life-os with `/install-plugin`, skills are already included and updated automatically.

### Skills sync

Skills (`planning-review-system`, `time-energy-manager`) originate from [claude-skills](https://github.com/glodyfimpa/claude-skills) and are synced into this plugin. Claude Code plugins are atomic units copied to cache at install, so skills must be committed here for distribution.

Workflow:
1. Edit skills in `claude-skills` repo, commit and push
2. In this repo: `./scripts/sync-skills.sh ../claude-skills`
3. Review `git diff skills/`, commit the updated skills

The sync script copies `SKILL.md` and `references/*` for each skill.

## License

MIT
