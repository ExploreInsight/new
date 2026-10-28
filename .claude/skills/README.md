# BAMA skills (vendored)

These are the [BAMA](https://github.com/daveebbelaar/bama) skills by Dave Ebbelaar,
vendored into this repo so that **every teammate gets them automatically** when
they clone. No global install, no per-machine setup, no version drift.

Upstream is MIT licensed. The license text is in `.claude/BAMA-LICENSE`.

## What was changed from upstream

BAMA ships as a Claude Code plugin with a nested layout. It was adapted for
this repo so both Claude Code and OpenCode discover it:

| Change | Why |
| --- | --- |
| Flattened `skills/<stage>/<name>/` to `skills/<name>/` | OpenCode and the agent-skills standard expect one folder per skill, with `SKILL.md` directly inside. The folder name must match the `name:` in the frontmatter. |
| `${CLAUDE_SKILL_DIR}` replaced with `$(git rev-parse --show-toplevel)/.claude/skills/<skill>` (5 files, 8 spots) | `CLAUDE_SKILL_DIR` only exists inside Claude Code. The repo-relative path works in every agent and from any subdirectory. |
| Cross-skill links rewritten from `../../<stage>/<skill>/file.md` to `../<skill>/file.md` | The skills are now siblings, so the stage segment is gone. |
| `specs/` moved from the plugin root to the repo root | The specs are build plans for the app, so they belong with the app, not with the tooling. The `bama` and `app-brief` skills point at the new location. |

The skill content itself is unmodified. All scripts resolve their own paths
relative to themselves, so they work from any location.

## Using them

Skills load on demand. In Claude Code or OpenCode, ask for the step you want,
or call the router skill `bama` and it picks the right skill for where you are.

The pipeline:

```
idea → research → clone (optional) → app-brief → user-stories → new-mac-app
     → mac-design + design-system + app-icon → improve-loop → repeat
```

To start from a ready-made build plan, copy one out of `specs/` and ask for it
by name:

```
Build the app in specs/window-snapper.md with BAMA.
```

## Updating from upstream

```bash
git remote add bama https://github.com/daveebbelaar/bama.git
git fetch bama
# copy skills/<stage>/<name>/ into .claude/skills/<name>/, then re-apply the
# four changes in the table above
```

Re-applying the changes is mechanical, but do it by hand rather than merging:
upstream rewrites are small and the substitutions are all in one pass.

## Requirements

Building a macOS app from these skills needs the **full Xcode** toolchain, not
just the Command Line Tools. Swift 6.4 turned `@State` into a compiler macro,
and the macro plugin (`libSwiftUIMacros.dylib`) ships inside Xcode.app only.
See the repo README for the setup notes.
