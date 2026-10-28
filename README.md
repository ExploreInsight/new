# new

Native macOS apps, built by an agent.

This repo is the home for the Mac apps we build. It uses
[BAMA](https://github.com/daveebbelaar/bama) skills, vendored into
`.claude/skills/` so everyone on the team gets them automatically on clone.

## Layout

```
.claude/skills/     the BAMA skill pack (21 skills), vendored and adapted
specs/              12 ready-made build plans (window snapper, launcher, ...)
docs/               the app's brief, research, stories, screenshots
Sources/            the app
tools/              build, snapshot, self-test, grid-lint scripts
build.sh            swift build → .app bundle → codesign → ~/Applications
```

The `new-mac-app` skill scaffolds this exact structure on first run.

## How it works

The agent drives the whole pipeline. One story per commit, and every UI change
is verified by taking snapshots of every page in light and dark mode and
actually looking at them.

```
idea → research → clone → app-brief → user-stories → new-mac-app
     → design → improve-loop (build, snapshot, look, fix, commit) → repeat
```

## Setup

Building a macOS app here needs the **full Xcode** toolchain. The Command
Line Tools alone are not enough: Swift 6.4 turned `@State` into a compiler
macro, and the macro plugin ships inside Xcode.app only.

```bash
brew install xcodes
xcodes install 26.6 --no-superuser --empty-trash
sudo xcode-select -s /Applications/Xcode_26.6.app/Contents/Developer
```

Simulator runtimes are not needed here. The apps are native macOS only.

For the permissions that macOS integrations need (Accessibility, Screen
Recording), a stable "Apple Development" certificate keeps the grants alive
across rebuilds. Without one the build signs ad hoc, and macOS asks for every
permission again after each rebuild. Create a free certificate in Xcode >
Settings > Accounts > Manage Certificates.

## Skills

Ask for the step you want, or ask for the `bama` router and it picks the right
skill for where you are.

Read `.claude/skills/README.md` for what was changed from upstream and how to
update it.

## License

The vendored skills are MIT, from [daveebbelaar/bama](https://github.com/daveebbelaar/bama).
See `.claude/BAMA-LICENSE`.
