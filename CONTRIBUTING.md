# Contributing to Margaux

## Branches and environments

| Branch | Deploys to | Who merges |
|---|---|---|
| `feat/*`, `fix/*`, `chore/*` | Vercel preview URL (private) | — |
| `dev` | **dev.margaux** (private, noindex) | Any reviewer after approval and green CI |
| `main` | **margaux** (live) | Code owners only, via a `dev` → `main` release PR |

Flow:

1. Take an issue from the GitHub Project board (or create one with a template).
2. Branch off `dev`: `git switch dev && git pull && git switch -c feat/<issue-number>-short-name`.
3. Open a PR into `dev` early as a draft. The PR template is your checklist.
4. CI has to pass and one reviewer has to approve. Squash-merge.
5. Test on dev.margaux.
6. Release: open a PR `dev` → `main` titled `release: <date>`. A code owner approves and merges it, which deploys live.

Hotfix: branch from `main`, PR into `main`, then merge `main` back into `dev`.

## Commits

[Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`, `perf:`, `security:`.

## Database changes

Schema only changes through files in `supabase/migrations/`. No clicking around in the live dashboard. Every new table enables RLS in the same migration. Migrations reach the dev project first and the live project only after release.

## Reviews and comments

- Review in GitHub PRs. Use suggestion blocks for small fixes.
- Design feedback goes in Figma comments. Product and planning discussion goes in Notion. Quick questions go in Slack (`#margaux-dev`). Decisions that affect code end up as an ADR in `docs/adr/`.
- Claude can review PRs too: mention `@claude` in a PR comment once the Claude GitHub App is installed.

## Adding a module

Follow `docs/architecture/modules.md`. Use the **Module request** issue template first so we agree on the boundaries before anyone writes code.
