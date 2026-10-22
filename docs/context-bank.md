# Context bank (Supabase)

Long-lived project knowledge (rules, decisions, how things work, gotchas, file mappings) lives in a Supabase table, not in one ever-growing `CLAUDE.md`.

## Why

It doesn't make Claude's context window bigger. What it does is let Claude **fetch only the entries relevant to the task** (by area, tag or full-text search) instead of loading every doc on every turn. That's where the token and credit savings come from. `CLAUDE.md` stays short and points here.

## Where

Supabase project `zcznmkqzmnrjdwosgprb`, which is being renamed from "Lumaux Context Bank" to **Margaux Context Bank**. It has two tables: `context_entries` and `context_entry_history`. Each entry has an `area`, a `kind` (rule, decision, how_it_works, gotcha, mapping or todo), `files`, `tags`, `superseded_by` and a full-text `search` column.

- Margaux entries use `margaux-*` areas. They were seeded on 2026-10-22 with the setup decisions.
- Unprefixed areas are the existing Lumaux context. That becomes the Lumaux module's context once it's ported.

## Rules

- Entries are internal engineering knowledge only. **No secrets, no client PII, no client data.**
- RLS stays on. Only Supabase MCP (team members' own auth) and the server-side sync job can read and write.
- Planned for batch 1: a GitHub Action mirrors `CLAUDE.md`, `SECURITY.md` and `docs/**` into the bank on merge to `dev`. The repo stays the source of truth, and the bank stays searchable.
- Lookup example: `select title, body from context_entries where area like 'margaux-%' and search @@ websearch_to_tsquery('english', 'auth') and superseded_by is null;`
- Superseded decisions are linked, never deleted.
