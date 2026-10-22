# Margaux — Claude working rules

Margaux is Bordeaux & Burgundy's internal platform. It merges Lumaux and two other internal tools into one app. Most of the product is about how companies show up in search and AI answers (SEO, AEO, GEO).

Keep this file short. Detailed context lives in `docs/` and in the Supabase context bank (see `docs/context-bank.md`). Look things up there when you need them instead of loading everything.

## Non-negotiables (in priority order)

1. **Security first.** Never commit, log, echo or paste secrets. Never read `.env*` files. Server-only keys never get a `NEXT_PUBLIC_` prefix and never reach client code. Every Supabase table gets RLS enabled in the same migration that creates it. Nothing personal or client-related is reachable by an unauthenticated URL. Rules: `SECURITY.md`.
2. **dev before live.** Work branches → PR into `dev` (deploys to dev.margaux) → tested → PR `dev` → `main` (deploys to margaux). Never push straight to `dev` or `main`.
3. **Modules plug in, they don't tangle.** New tools, services, agents and APIs go in as modules following `docs/architecture/modules.md`. Don't import across module internals.
4. **SEO matters on public pages.** Server-rendered, with metadata, structured data and sitemap entries. dev.margaux is always `noindex`. See `docs/seo.md`.
5. **Refactor when it gets messy.** If a change makes code harder to follow, clean it up in the same PR or open a follow-up issue. Don't leave it.

## How we work

- Complex or unclear feature → run `/grill-me` before writing code.
- Plans and implementation follow the superpowers workflow (brainstorm → plan → TDD → review). See `docs/skills.md` for which skill owns which job.
- All user-facing copy goes through the humanizer skill. Caveman-style terse output is for chat only, never for copy, docs or commit messages.
- UI work follows the Figma file and the design skills listed in `docs/skills.md`.
- Use Context7 for library docs and Firecrawl for live web pages. Don't rely on memory for APIs that change.
- Commits: Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`).

## Repo map

- `docs/` — architecture, environments, SEO, skills, ADRs, setup checklist
- `modules/` — pluggable feature modules (one folder per module)
- `supabase/migrations/` — the only way schema changes happen
- `.github/` — CI, templates, CODEOWNERS
