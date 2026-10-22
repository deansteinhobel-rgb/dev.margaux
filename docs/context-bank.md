# Context bank (Supabase)

Long-lived project knowledge (rules, decisions, how things work, gotchas, file mappings) lives in a Supabase table, not in one ever-growing `CLAUDE.md`.

## Why

It doesn't make Claude's context window bigger. What it does is let Claude **fetch only the entries relevant to the task** (by area, tag or full-text search) instead of loading every doc on every turn. That's where the token and credit savings come from. `CLAUDE.md` stays short and points here.

## Where

The existing **Lumaux Context Bank** project (`context_entries`, `context_entry_history`) already has the right shape: `area`, `kind` (rule / decision / how_it_works / gotcha / mapping / todo), `files`, `tags`, `superseded_by`, full-text `search`. The proposal is to reuse it for Margaux, with Margaux entries under `margaux-*` areas, and rename the project to "Margaux Context Bank" once Lumaux is merged in. (Decision pending.)

## Rules

- Entries are internal engineering knowledge only. **No secrets, no client PII, no client data.**
- RLS stays on. Only Supabase MCP (team members' own auth) and the server-side sync job can read and write.
- `CLAUDE.md`, `SECURITY.md` and `docs/**` are mirrored in on merge to `dev`, so the repo stays the source of truth and the bank stays searchable.
- Superseded decisions are linked, never deleted.
