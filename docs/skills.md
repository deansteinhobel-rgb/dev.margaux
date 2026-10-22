# Claude Code skills and MCP servers

**Rule: one skill per job. No skill banks, no fallbacks, no plugin hooks.**

Skills are copied into `.claude/skills/` at pinned commits by `scripts/sync-skills.sh`, then reviewed and committed. Everyone who clones the repo gets exactly the same set, and that includes cloud sessions, where plugins don't load. Nothing runs at session start, and nothing updates itself without someone reviewing it.

## Who owns which job

| Job | Skill / tool | Source |
|---|---|---|
| Complex or unclear feature: interrogate until there's shared understanding | `grill-me` | mattpocock/skills (that one skill only) |
| Turn the agreed design into a step-by-step plan | `writing-plans` | obra/superpowers |
| Execute the plan with subagents | `subagent-driven-development` | obra/superpowers |
| Tests first | `test-driven-development` | obra/superpowers |
| Bugs | `systematic-debugging` | obra/superpowers |
| Prove it works before saying "done" | `verification-before-completion` | obra/superpowers |
| Ask for a review / handle review feedback | `requesting-code-review` / `receiving-code-review` | obra/superpowers |
| Isolated workspaces for parallel work / wrap up a branch into a PR | `using-git-worktrees` / `finishing-a-development-branch` | obra/superpowers |
| Security audit of a change | built-in `/security-review` | Claude Code |
| Smallest change that fully solves it; no gold-plating | `ponytail` | DietrichGebert/ponytail (skill only, no hooks) |
| Short chat replies to save tokens | `caveman` (on demand: `/caveman`) | JuliusBrussee/caveman (skill only, no hooks) |
| All user-facing copy | `humanizer` | blader/humanizer |
| Design system: palette, type, style, chart choices | `ui-ux-pro-max` | nextlevelbuilder (core skill only) |
| Building and critiquing screens and pages | `taste` | Leonxlnx/taste-skill |
| Style reference | Figma board (guide, not a spec) | Figma MCP |
| Ready-made components | 21st MCP | 21st.dev |
| Codebase map and code flows | `graphify` | safishamsi/graphify (skill file; CLI per developer) |
| Learn from a video | `watch` | bradautomates/claude-video |
| Fast typed AI judgments in Margaux features (route, rank, classify, extract) using Jev | `typesafe-ai` | typesafe-ai/skills |
| Library and framework docs | Context7 MCP | upstash |
| Anything on the live web | Firecrawl MCP | firecrawl |
| What people said in the last 30 days (Reddit, X, YouTube, HN) | `last30days` | mvanhorn (personal plugin, see below) |

## Hand-offs, so jobs don't overlap

- **Planning:** `grill-me` → `writing-plans` → `subagent-driven-development`. There's no brainstorming skill and no inline-execution skill. If a superpowers skill mentions `brainstorming` or `executing-plans`, that's upstream text: use `grill-me` and `subagent-driven-development` instead.
- **Ponytail vs TDD:** ponytail decides *how much code* to write. TDD decides *how* to write it. Non-trivial logic always gets a test, and ponytail agrees. Ponytail never cuts security, validation or tests.
- **Caveman vs humanizer:** caveman only changes how Claude talks in chat. Code, comments, docs, commits, PR text and product copy are always normal, and copy goes through humanizer.
- **Design:** the Figma board sets the mood → `ui-ux-pro-max` turns it into a design system once (tokens, type scale, palette, chart rules) → `taste` builds and critiques each screen inside that system → 21st supplies a component when we need one, restyled to our tokens.
- **Web:** Context7 for docs, Firecrawl for everything else on the web. Built-in WebSearch and WebFetch are switched off in `.claude/settings.json`, so there's one web tool and no fallback.
- **Jev vs Claude in the product:** Jev handles short typed decisions where you'd otherwise prompt an LLM and parse the answer (which bucket, which model, how relevant, is this safe). Claude handles anything that writes or reasons at length. Jev isn't used to write our code.
- **Parallel** is a **product API** for Margaux's own features (visibility research at scale), not a dev tool. It lives in a module, not in `.mcp.json`.

## Removed on purpose

| What | Why |
|---|---|
| Addy Osmani agent-skills, the Matt Pocock bundle (except grill-me) | Skill banks that duplicate planning, TDD, review and debugging |
| superpowers `brainstorming`, `executing-plans`, `dispatching-parallel-agents`, `using-superpowers`, `writing-skills` | Duplicate grill-me or subagent-driven-development, or meta and bootstrap skills that force a workflow |
| Understand Anything | Same job as graphify, with heavier session hooks, and its SessionStart hook tells Claude to act "without asking the user" |
| Wayfinder | A planning skill (not code flows). It duplicates writing-plans. Graphify covers code flows. |
| Caveman and ponytail plugin extras (cavecrew, caveman-review, safe-refactor, ponytail-review, …) | Duplicate superpowers |
| UI/UX Pro Max extras (`design`, `brand`, `slides`, `banner-design`, `ui-styling`) | Duplicate taste and the Figma/deck tools; some call paid image APIs |

## Per-developer setup

- **graphify CLI:** `uv tool install graphifyy==0.9.94` (note the double y). Don't run `graphify claude install`: it edits CLAUDE.md and adds a hook. The skill is already in the repo.
- **watch:** needs `ffmpeg` and `yt-dlp`. Don't set `GEMINI_API_KEY` for internal or client videos, because the whole video goes to Google.
- **last30days** is personal research, not project tooling, so it stays out of the repo. Install it with `/plugin marketplace add mvanhorn/last30days-skill` then `/plugin install last30days`. Always run with `--no-browser-cookies`. Keys go in your shell, never in the repo.
- **typesafe-ai** reads TypeSafe's live docs through Firecrawl (WebFetch is off). `TYPESAFE_API_KEY` is server-only and lives in Vercel.
- **MCP keys:** `CONTEXT7_API_KEY`, `FIRECRAWL_API_KEY`, `TWENTY_FIRST_API_KEY` go in your shell profile.

## Updating a skill

Change the SHA in `scripts/sync-skills.sh`, run it, and read the diff, including any new scripts. Then open a PR. CODEOWNERS makes `.claude/` changes need an owner review.

## Security notes

- Every vendored script was checked for network calls. All of them match each skill's stated purpose:
  - taste fetches public-domain images (Met, Art Institute, Wikimedia, Openverse, archive.org).
  - watch calls transcription APIs only when you set those keys.
  - ui-ux-pro-max is offline.
- taste's preview pages load GSAP and Lenis from a CDN. In the app, those get installed through npm.
- Never send client data to Firecrawl, 21st or Context7. Queries leave our infrastructure.
