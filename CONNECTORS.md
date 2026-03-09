# Connectors

## How tool references work

Plugin files use `~~category` as a placeholder for whatever tool the user
connects in that category. Plugins are tool-agnostic: they describe
workflows in terms of categories rather than specific products.

## Connectors for this plugin

| Category | Placeholder | Options |
|----------|-------------|---------|
| Task & project database | `~~task database` | Notion (recommended), Airtable, Linear, or none |
| Calendar | `~~calendar` | Google Calendar (recommended), Outlook Calendar, or none |
| Email | `~~email` | Gmail, Outlook, or none |

All connectors are optional. life-os works in three modes:

- **Full integration:** All tools connected. Reads and writes data automatically.
- **Partial:** Some tools connected. Connected tools work normally; missing tools use conversational fallbacks.
- **Chat-only:** No tools connected. All input comes from the user, all output appears in chat.

Tool connections are configured during `/setup` and stored in the user's
config file (`.claude/life-os.local.md`).
