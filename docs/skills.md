# Claude Code skills and MCP servers

Status: **proposal, awaiting decisions** (marked ❓). Checked 2026-10-22. Once agreed, we enable plugins for the whole team through `.claude/settings.json` (`extraKnownMarketplaces` + `enabledPlugins`), so everyone gets the same setup automatically. Install everything one way only (plugin marketplace). Mixing it with `npx skills add` duplicates skills.

## Who owns which job (one owner per job)

| Job | Owner | Not used for this job |
|---|---|---|
| Requirements on complex or unclear work | `/grill-me` (mattpocock/skills) | superpowers `brainstorming`, Addy `interview-me` |
| Planning → execution | superpowers (`writing-plans`, `executing-plans`, `subagent-driven-development`) | Addy `planning-and-task-breakdown` |
| Multi-session / epic planning | `wayfinder` (mattpocock/skills, manual only) | — |
| TDD / debugging / verification | superpowers | Addy and Pocock duplicates |
| Code review | superpowers `requesting-code-review` + built-in `/code-review`, `/security-review` | caveman-review, ponytail-review, Addy and Pocock review |
| "Keep it simple" bias | ponytail at `lite` level ❓ | — |
| Production automation | Addy agent-skills, **selected only**: `security-and-hardening`, `ci-cd-and-automation`, `observability-and-instrumentation`, `performance-optimization`, `shipping-and-launch`, `documentation-and-adrs` | the rest of Addy's set |
| Visual design | taste-skill for public and marketing pages; UI/UX Pro Max core skill as a lookup (palettes, fonts, charts) for app screens | Pro Max `slides` / `brand` / `design` sub-skills (clash with Figma and B&B deck skills; call paid APIs) |
| Components | 21st MCP + shadcn/ui | — |
| Design source of truth | Figma MCP | — |
| Copy | humanizer (every piece of user-facing text) | caveman |
| Token saving | caveman **on demand only**, chat output only ❓ | never in copy, docs, commits, PR text |
| Codebase map | Graphify ❓ (or Understand-Anything, but not both) | — |
| Library docs | Context7 | web search |
| Live web pages | Firecrawl | — |
| Web research at scale (product feature) | Parallel API | — |
| Trend / social research | last30days | — |
| Learning from videos | claude-video `/watch` | — |
| Fast classify / route / rank | Jev (TypeSafe AI) ❓ to be confirmed | — |

## Clashes found

1. **Three skills inject rules at every session start.** Superpowers, ponytail and caveman each add a SessionStart hook, and ponytail and caveman also add per-prompt and per-subagent hooks. Superpowers says "brainstorm and plan first", ponytail says "smallest possible change", caveman says "be terse". With all three always on, Claude gets mixed instructions on every turn. Fix: superpowers stays always-on as the methodology. Ponytail runs at `lite` level, or off and invoked per task. Caveman is never left on.
2. **Superpowers forces brainstorming before any creative work**, which overlaps `/grill-me`. Fix: `/grill-me` runs first on complex or unclear features (your rule). Superpowers then plans from the grill output. On small tasks we tell it to skip brainstorming.
3. **TDD, code review, debugging and planning are duplicated** across superpowers, Addy Osmani and Matt Pocock (Addy and superpowers even share the skill name `test-driven-development`). Fix: install only the Addy skills listed above.
4. **Ponytail vs superpowers / Addy philosophy.** "No abstractions, one line over fifty" works against TDD, observability and hardening. Fix: security and tests always win. Ponytail only stops gold-plating.
5. **Caveman vs humanizer.** One produces terse grunts, the other natural prose. Fix: caveman never touches anything a human outside the team reads.
6. **Three design skills auto-trigger on UI work** (taste, Pro Max, Addy `frontend-ui-engineering`). Fix: as in the table. The Figma file beats all of them.
7. **Graphify and Understand-Anything both rebuild a code graph and steer how Claude reads files** (Graphify adds a PreToolUse hook and edits CLAUDE.md; Understand-Anything adds SessionStart/PostToolUse hooks). Running both doubles token spend. Fix: pick one. Recommended: **Graphify** (local tree-sitter, deterministic, cheaper). Its CLAUDE.md section has to stay short.
8. **Web tools overlap** (Firecrawl, Parallel, WebSearch, last30days). Fix: as in the table.
9. **"Wayfinder" is a planning skill, not a code-flow tool.** For code flows, Graphify covers it.

## Security notes before rollout

- Several of these run code on every session through hooks: superpowers, ponytail, caveman, Understand-Anything, claude-video, Graphify. Someone reads each hook before we enable it team-wide.
- Understand-Anything's SessionStart hook tells Claude to act "without asking the user". That's another reason to prefer Graphify.
- Use the caveman **skill/plugin only**, not the `@caveman-ai/cli`. The CLI has telemetry on by default and an optional cloud mode that sends prompts and CLAUDE.md content off-machine.
- Ponytail: leave its `webhookUrl` empty. It writes a local cost ledger in `~/.config/ponytail`.
- last30days: run with `--no-browser-cookies`. Its keys go in your shell env, never in the repo.
- claude-video: don't set `GEMINI_API_KEY` for internal or client videos, since the whole video is then sent to Google.
- Never pass client data to Firecrawl, Parallel, 21st or Context7. Their queries leave our infrastructure.

## MCP servers (`.mcp.json`, shared)

All keys come from each developer's shell environment through `${VAR}` expansion. No key is ever written into the file. Supabase MCP gets added once the dev project exists, scoped to `margaux-dev` and `read_only=true`. It never points at prod.
