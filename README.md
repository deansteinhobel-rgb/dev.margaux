# Margaux

Bordeaux & Burgundy's platform for brand visibility across search and AI answers (SEO, AEO, GEO). It combines Lumaux and two other internal tools.

- **Live:** margaux (`main` branch)
- **Dev:** dev.margaux (`dev` branch, team-only)

> Status: project setup. No application code yet. Features are built in agreed batches.

## Start here

1. `CONTRIBUTING.md`: branches, PRs, releases
2. `SECURITY.md`: secrets, auth, data rules (required reading)
3. `docs/setup-checklist.md`: accounts and access each person needs
4. `docs/architecture/modules.md`: how tools plug into Margaux
5. `docs/skills.md`: Claude Code skills and MCP servers we use, and which one handles what

## Stack (proposed, see `docs/adr/0001-stack.md`)

Next.js (App Router, TypeScript) on Vercel · Supabase (Postgres, Auth, Storage, Edge Functions) · pnpm · GitHub Actions
