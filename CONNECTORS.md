# Connectors

## How tool references work

Plugin files use `~~category` as a placeholder for whatever tool the user
connects in that category. Plugins are tool-agnostic: they describe
workflows in terms of categories rather than specific products.

## Connectors for this plugin

| Category | Placeholder | Options |
|----------|-------------|---------|
| Task & project database | `~~task database` | Notion (recommended), Airtable, Linear |
| Email | `~~email` | Gmail, Outlook |

Both skills reference Notion collection IDs stored in the user's config file
(`.claude/life-os.local.md`), which is generated during `/setup`.
If using a different task database, replace the collection:// URLs with the
equivalent data source identifiers.

Gmail is optional: planning-review-system uses it in Phase 1 (Quick Capture)
to scan unread/starred emails. If not connected, that step is skipped.
