# Environments

| | Local | Preview (per PR) | dev.margaux | margaux (live) |
|---|---|---|---|---|
| Git | any branch | PR branch | `dev` | `main` |
| Vercel env | Development | Preview | Preview (branch `dev`, custom domain) | Production |
| Supabase (eu-west-2, London) | margaux-dev | margaux-dev | margaux-dev | margaux-prod |
| Access | you | Vercel Deployment Protection | Vercel Deployment Protection (team only) | Public pages + Supabase Auth |
| Indexing | n/a | noindex | **noindex** (header + robots) | indexable public pages only |
| `MARGAUX_ENV` | development | dev | dev | production |

## Vercel environment variables

Set these in Vercel → Project → Settings → Environment Variables. Scope every secret to the narrowest environment that needs it.

- **Production:** prod Supabase URL and keys, live API keys.
- **Preview** (includes `dev`): dev Supabase URL and keys, dev/test API keys.
- **Development:** pull with `vercel env pull .env.local`.

The production secret key never goes into Preview.

## Promotion

`dev` → `main` through a release PR. Supabase migrations go to dev when merged into `dev`, and to prod as part of the release (a GitHub Action with a manual approval gate, set up in batch 1).
