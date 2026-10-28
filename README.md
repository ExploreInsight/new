# Snapper

A native macOS window manager. Every open window in one Mission-Control-style
panel, so you can switch, close, or arrange them without hunting.

Built with the [BAMA](https://github.com/daveebbelaar/bama) skills, vendored
into `.claude/skills/` so everyone on the team gets them automatically on clone.

## What it does

1. Hold ⌥ (or ⌘) and press Tab to open a panel of every window on this Space,
   with live previews. Release to focus one, press ⌘W to close it, ⌘Q to quit
   its app.
2. Snap the focused window to the left half, the right half, or full screen
   with a shortcut, and send it to the next display.
3. Change every shortcut, the accent color, and the snap widths in Settings.

The reference is [Wins](https://wins.cool), which costs money. This is the
free version, built for one person.

## Layout

```
.claude/skills/     the BAMA skill pack (21 skills), vendored and adapted
specs/              build plans this app grew out of
docs/
  BRIEF.md          what the app is, in one page
  STORIES.md        the backlog, 23 stories in milestones
  SPEC-switcher.md  the switcher spec
  SPEC-snapper.md   the snapping spec
Sources/Snapper/    the app
Sources/SnapperKit/ rules and data logic, no SwiftUI, so tests run fast
tools/              build, snapshot, self-test, grid-lint scripts
build.sh            swift build → .app bundle → codesign → ~/Applications
```

## Build and check

```bash
./build.sh --open                     # build, install to ~/Applications, launch
swift test --scratch-path ~/Library/Developer/Snapper/test-build
tools/selftest.sh                    # exit 0 when every check passes
tools/snap.sh                        # light + dark PNGs of every page
tools/grid-lint.sh                   # spacing on the 4 pt grid
```

A change is done when the build has no errors, the grid checks pass, and you
have looked at the light and dark snapshots.

## Setup

Building needs the **full Xcode** toolchain. The Command Line Tools alone are
not enough: Swift 6.4 turned `@State` into a compiler macro, and the macro
plugin ships inside Xcode.app only.

```bash
brew install xcodes
xcodes install 26.6 --no-superuser --empty-trash
sudo xcode-select -s /Applications/Xcode_26.6.app/Contents/Developer
```

Simulator runtimes are not needed. The app is native macOS only.

### Signing matters here

This app moves other apps' windows, so it needs **Accessibility**, **Screen
Recording**, and **Input Monitoring**. macOS stores those grants per code
signature and path. With ad-hoc signing, every rebuild wipes them and you
re-grant by hand.

Create one "Apple Development" certificate and keep it:

> Xcode → Settings → Accounts → + → Apple ID → Manage Certificates → Create
> "Apple Development"

`build.sh` picks the first Apple Development certificate in the keychain
automatically. Install to the same path every time, and do not enable the App
Sandbox: it blocks event taps and other apps' windows.

## Skills

Ask for the step you want, or ask for the `bama` router and it picks the right
skill for where you are.

Read `.claude/skills/README.md` for what was changed from upstream and how to
update it.

## License

The vendored skills are MIT, from [daveebbelaar/bama](https://github.com/daveebbelaar/bama).
See `.claude/BAMA-LICENSE`.
