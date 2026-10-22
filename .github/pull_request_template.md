## What & why
<!-- Link the issue: Closes #123 -->

## How to test
<!-- Steps on the preview URL / dev.margaux -->

## Screenshots / Figma link
<!-- UI changes only -->

## Checklist
- [ ] Targets `dev` (or `main` only for a release/hotfix)
- [ ] No secrets, keys or `.env` files in the diff; server-only keys aren't prefixed `NEXT_PUBLIC_`
- [ ] New tables have RLS enabled + policies in the same migration
- [ ] No personal/client data reachable without auth
- [ ] Public pages: metadata, structured data, still noindex on dev
- [ ] User-facing copy run through humanizer
- [ ] Tests added/updated; refactored anything I made messier
