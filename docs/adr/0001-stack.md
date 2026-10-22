# ADR 0001: Base stack

- **Status:** Proposed
- **Date:** 2026-10-22

## Context

Margaux merges three internally built tools (Lumaux plus two others). It has to be secure by default, easy to extend with new modules, SEO-friendly on its public pages, and comfortable for several people working with Claude Code at once. Lumaux already runs on Supabase.

## Decision

- **Next.js (App Router) + TypeScript (strict)**: server rendering and the Metadata API cover SEO; server actions and route handlers keep secrets on the server. Vercel's first-party framework.
- **Vercel**: Git-based deploys. `main` → margaux, `dev` → dev.margaux, a preview for every PR. Environment variables are scoped per environment.
- **Supabase**: Postgres with RLS, Auth, Storage, Edge Functions. **Two projects**, `margaux-dev` and `margaux-prod`, so dev keys can never reach live data.
- **pnpm workspaces**: lets each module be its own package (`modules/<name>`) with clear dependencies.
- **Tailwind + shadcn/ui**: fits the 21st.dev MCP and the design skills, and gets built from the Figma tokens.
- **Zod** at every boundary (env vars, API input, module manifests).
- **Vitest + Playwright** for tests.

## Consequences

- The other two tools get ported into modules, not deployed alongside as separate apps. Before we port each one, it needs an audit (stack, data, secrets).
- Running two Supabase projects costs more but separates dev from live completely. Supabase Branching could cover per-PR databases later.
