# Security policy

Security comes before speed, features and convenience. If a change trades security for anything else, it doesn't merge.

## Reporting

Found a leaked key, an exposed URL or a data leak? Tell the Margaux owners in Slack straight away (private message, not a public channel). Don't open a public GitHub issue. If it's a key, rotate it first and then report it.

## Secrets

- Real values live in exactly three places: Vercel environment variables, Supabase secrets (Edge Functions), and GitHub Actions secrets. Each developer also has a local `.env.local`, which git ignores.
- Never commit, paste into Slack/Notion/PRs, log, or send a secret to an AI chat.
- `NEXT_PUBLIC_*` variables reach the browser. Only public values get that prefix: the Supabase URL and publishable key, and the site URL.
- `SUPABASE_SECRET_KEY` (service role) skips RLS. Only server code may use it (route handlers, server actions, Edge Functions), and only when no user-scoped client will do.
- dev and live use **separate keys and separate Supabase projects**. A dev key never works against live data.
- CI runs gitleaks on every push and PR. GitHub secret scanning and push protection should be on as well (see `docs/setup-checklist.md`).
- Leaked key: rotate it at the provider, update Vercel/Supabase/GitHub, then remove it from git history. Assume anything that reached GitHub has been copied.

## Auth

- Supabase Auth, with sign-in limited to B&B Google Workspace accounts (SSO/OAuth) unless we decide otherwise. No anonymous sign-ups on live.
- Sessions use `@supabase/ssr` cookies (httpOnly, Secure, SameSite=Lax). Tokens never go in localStorage.
- Authorization happens in the database (RLS) and again on the server. Hiding a button doesn't count as authorization.
- Roles come from a server-controlled table or claim. Users can never edit their own role.
- MFA required for admins.

## Data and URLs

- RLS on every table, created in the same migration. A table with RLS and no policies denies everything, which is the correct default.
- Storage buckets are private by default. Use short-lived signed URLs. No public buckets for client or personal data.
- Shareable report links (if any) need unguessable tokens, an expiry date, the ability to revoke, and no PII in the URL.
- No IDs, emails or client names in query strings that end up in logs or analytics.
- dev.margaux sits behind Vercel Deployment Protection. Only the team can reach it.

## Dependencies and supply chain

- Dependabot handles updates. Review lockfile changes in PRs.
- Before installing a new skill, MCP server or package, someone reads what it runs. Third-party skills can execute code on your machine.
- Pin GitHub Actions to a version tag at minimum.
