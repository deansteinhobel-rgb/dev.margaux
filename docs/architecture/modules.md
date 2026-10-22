# Modules: how anything plugs into Margaux

Every capability goes in as a **module**: a Lumaux feature, one of the two merged tools, a new API integration, an AI agent, a Grok bot, a vibe-coded side tool. The core app stays small (shell, auth, navigation, permissions, shared UI). Modules register with it; the core never reaches into them.

## Folder layout

```
modules/
  <module-id>/
    module.ts          # manifest (see below)
    README.md          # what it does, owner, data it touches
    app/               # routes/pages it contributes
    server/            # server-only code: API clients, actions, jobs
    ui/                # components private to the module
    db/                # SQL migrations for its own schema (copied into supabase/migrations)
    tests/
```

## Manifest contract (shape, to be implemented in batch 1)

```ts
export default defineModule({
  id: "visibility-tracker",          // kebab-case, unique
  name: "Visibility Tracker",
  owner: "@bordeaux-burgundy/margaux-core",
  routes: ["/visibility"],            // mounted under the app shell
  nav: { label: "Visibility", icon: "radar" },
  permissions: ["visibility.read", "visibility.write"],
  env: { server: ["PARALLEL_API_KEY"], public: [] }, // validated with zod at boot
  dbSchema: "visibility",            // its own Postgres schema, RLS on
  flags: { enabledIn: ["development", "dev"] },  // ship to dev first, then live
});
```

## Rules

1. **Own schema per module.** Tables go in `<dbSchema>.*` with RLS enabled. Shared entities (users, orgs, clients) live in `core` and are referenced by ID.
2. **No cross-module imports.** Modules talk through the core's public API (`@margaux/core`) or through events and DB views. Never through each other's internals.
3. **Secrets stay server-side.** A module declares which env vars it needs. If they're missing, the module turns itself off rather than breaking the app.
4. **Feature-flagged.** Every module ships to dev first. Enabling it on live is a deliberate config change.
5. **External tools.** A separately hosted vibe-coded tool can come in two ways: (a) port its code into a module (preferred), or (b) wrap it as a "remote module" that calls the tool's API from the server, with auth between services. Never iframe something we don't control, and never pass user tokens through.
6. **Agents/bots** (Claude, Grok, Parallel tasks) are modules too. Their prompts are versioned in the repo and their runs are logged to the module's schema.
