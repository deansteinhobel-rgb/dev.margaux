# Setup checklist (before batch 1)

Owner = who has to click it. Anything needing an account or a payment can't be done by Claude.

## GitHub (B&B org)

- [ ] Create a GitHub organization for B&B, or use the existing one, on the **Team** plan. Branch protection and rulesets on private repos need a paid plan.
- [ ] Transfer this repo into it: Settings → Danger zone → Transfer. Rename it to `margaux`. One repo; `dev` and `main` are branches, not separate repos.
- [ ] Create teams: `margaux-core` (admins/code owners) and `margaux-devs` (write). Update `.github/CODEOWNERS`.
- [ ] Create branches `main` and `dev` from the setup commit, and set `dev` as the default branch.
- [ ] Rulesets on `main` and `dev`: require a PR, 1 approval (`main`: code owner), status checks `security`, linear history, no force-push, no deletion.
- [ ] Settings → Code security: turn on secret scanning, push protection, Dependabot alerts, and CodeQL default setup.
- [ ] Turn on 2FA for the whole org.
- [ ] Install the **Claude GitHub App** on the org/repo so `@claude` works in PRs and issues.
- [ ] GitHub Projects board (Backlog / Next / In progress / In review / On dev / Live), with the Slack integration posting to `#margaux-dev`.
- [ ] Gitleaks licence key (free) → Actions secret `GITLEAKS_LICENSE` (required for org-owned repos).

## Vercel (B&B team)

- [ ] Vercel **Pro** team under B&B. Required for team members, Deployment Protection on custom domains, and per-branch env vars.
- [ ] Import the repo. Production branch = `main`.
- [ ] Domains: `margaux.<domain>` → Production; `dev.margaux.<domain>` → Preview, Git branch `dev`.
- [ ] Settings → Deployment Protection: **Vercel Authentication** on for all preview deployments, including dev.
- [ ] Environment variables per `docs/environments.md`. Prod secrets in Production only.
- [ ] Turn on the GitHub and Slack integrations.

## Supabase (Bordeaux & Burgundy org)

- [ ] Decide the projects: `margaux-dev` + `margaux-prod`, region `eu-west-2` (London) for UK/GDPR.
- [ ] Auth → Google provider limited to the B&B Workspace domain. Turn off email sign-ups on prod.
- [ ] Turn on MFA. Custom SMTP for auth emails.
- [ ] Prod: Pro plan, PITR backups, network restrictions, SSL enforcement.
- [ ] Decide on reusing the context bank (`docs/context-bank.md`).

## The two other tools

- [ ] For each: repo link, owner, stack, where it's hosted, what data and secrets it uses, who uses it, what has to survive the merge.

## People

- [ ] List of team members: GitHub handles, emails, and the role each should have.
- [ ] Each developer: Claude Code installed, GitHub 2FA, invited to Vercel and Supabase, local `.env.local` from `vercel env pull`.

## Design

- [ ] Figma file link and access for the people who need it (Dev Mode seat for whoever implements).
