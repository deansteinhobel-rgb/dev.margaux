# SEO / AEO / GEO baseline

Margaux measures how companies appear in search and AI answers, so our own public pages should follow the same rules.

## Applies to public pages only

The authenticated app (dashboards, client data) is `noindex` and blocked in `robots.txt`. Only marketing and public pages get indexed.

## Baseline for every public page

- Server-rendered HTML. Content must not depend on client-side JS.
- Next.js Metadata API: unique `title` and `description`, canonical URL, Open Graph and Twitter tags.
- JSON-LD structured data (`Organization`, `WebSite`, `SoftwareApplication`, `FAQPage`, `Article` where relevant).
- `sitemap.xml` and `robots.txt` generated from routes. Production only.
- Core Web Vitals budgets: LCP < 2.5s, INP < 200ms, CLS < 0.1. Checked in CI with Lighthouse later.
- One `h1`, logical heading order, descriptive alt text. Copy goes through humanizer.
- AEO/GEO: clear question-and-answer sections, quotable facts with sources, an `llms.txt` file, and author/organization entity markup.

## dev.margaux must never be indexed

- `X-Robots-Tag: noindex, nofollow` header for any `dev.*` host (set in `vercel.json`).
- Vercel Deployment Protection on dev and previews.
- `robots.txt` returns `Disallow: /` unless `MARGAUX_ENV=production`.
