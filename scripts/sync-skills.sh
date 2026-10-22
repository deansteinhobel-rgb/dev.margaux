#!/usr/bin/env bash
# Vendors Margaux's Claude Code skills into .claude/skills at pinned commits.
# One skill per job, no plugin bundles, no hooks. See docs/skills.md.
#
# To update a skill: change its SHA below, run this script, review the diff
# (read any new or changed scripts before committing), open a PR.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/.claude/skills"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# repo | sha | path-in-repo | skill name in Margaux
SKILLS=(
  "obra/superpowers|2ce8aa15d05bd57213e6f746f953aafb7ded7a8b|skills/writing-plans|writing-plans"
  "obra/superpowers|2ce8aa15d05bd57213e6f746f953aafb7ded7a8b|skills/subagent-driven-development|subagent-driven-development"
  "obra/superpowers|2ce8aa15d05bd57213e6f746f953aafb7ded7a8b|skills/test-driven-development|test-driven-development"
  "obra/superpowers|2ce8aa15d05bd57213e6f746f953aafb7ded7a8b|skills/systematic-debugging|systematic-debugging"
  "obra/superpowers|2ce8aa15d05bd57213e6f746f953aafb7ded7a8b|skills/verification-before-completion|verification-before-completion"
  "obra/superpowers|2ce8aa15d05bd57213e6f746f953aafb7ded7a8b|skills/requesting-code-review|requesting-code-review"
  "obra/superpowers|2ce8aa15d05bd57213e6f746f953aafb7ded7a8b|skills/receiving-code-review|receiving-code-review"
  "obra/superpowers|2ce8aa15d05bd57213e6f746f953aafb7ded7a8b|skills/using-git-worktrees|using-git-worktrees"
  "obra/superpowers|2ce8aa15d05bd57213e6f746f953aafb7ded7a8b|skills/finishing-a-development-branch|finishing-a-development-branch"
  "mattpocock/skills|5beb35b040e3de97e54fa9e386d7e42d15c295c2|skills/productivity/grilling|grill-me"
  "DietrichGebert/ponytail|09c434ab73ca43761c5d8b0c5d341926c2fba710|skills/ponytail|ponytail"
  "JuliusBrussee/caveman|bad48a0e1df55e05e3f52249afa35ecc1909ee76|skills/caveman|caveman"
  "blader/humanizer|8c307f367c91bd974002f10f2be2965d642c13df|.|humanizer"
  "Leonxlnx/taste-skill|6010f91a9935f1c167dfc500fb1a475681892e6b|skills/taste-skill|taste"
  "nextlevelbuilder/ui-ux-pro-max-skill|076a2b3a31394ad788afaa71f55d0bf789e7b3ec|.claude/skills/ui-ux-pro-max|ui-ux-pro-max"
  "bradautomates/claude-video|03ceb42f7fa2c4439aca01752118044baabffb8f|skills/watch|watch"
  "safishamsi/graphify|c588b72d936927790a87ad009955078ed40562a3|graphify/skill.md|graphify"
)

fetch() { # repo sha -> checkout dir
  local repo=$1 sha=$2 dir="$WORK/${1//\//_}"
  if [ ! -d "$dir" ]; then
    git init -q "$dir"
    git -C "$dir" fetch -q --depth 1 "https://github.com/$repo.git" "$sha"
    git -C "$dir" checkout -q FETCH_HEAD
  fi
  echo "$dir"
}

for entry in "${SKILLS[@]}"; do
  IFS='|' read -r repo sha path name <<<"$entry"
  src="$(fetch "$repo" "$sha")/$path"
  out="$DEST/$name"
  rm -rf "$out" && mkdir -p "$out"
  if [ -f "$src" ]; then
    cp "$src" "$out/SKILL.md"
  else
    cp -R "$src/." "$out/"
    # Drop repo/dev clutter that isn't part of the skill itself.
    rm -rf "$out"/{.git,.github,.claude-plugin,.cursor-plugin,tests,evals,agents,CHANGELOG.md,AGENTS.md,README.md}
  fi
  echo "$repo@${sha:0:7} $path -> .claude/skills/$name"
done

# Our skills aren't namespaced, so drop the plugin prefix superpowers uses for cross-references.
grep -rlZ 'superpowers:' "$DEST" | xargs -0 -r sed -i.bak 's/superpowers:\([a-z-]*\)/\1/g'
find "$DEST" -name '*.bak' -delete
# grill-me is the grilling skill under the name the team uses.
sed -i.bak 's/^name: grilling$/name: grill-me/' "$DEST/grill-me/SKILL.md" && rm "$DEST/grill-me/SKILL.md.bak"
