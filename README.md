# Snapper

A personal macOS window manager for a crowded screen. Find a window, give it
half the screen or maximize it, and restore it when you are done.

## Working baseline

- A searchable overview lists individual app windows, including multiple
  windows of the same app. Select a row and use Switch or an arrangement button.
- Left Half, Right Half, and Maximize use the display's usable area, leaving
  the menu bar and Dock clear, with an 8 pt gap.
- Restore remembers the frame before the first snap, for this app session.
- Optional window pictures use ScreenCaptureKit. They refresh when you open
  or refresh the overview, stay in memory, and are cleared when disabled.
  Capture is limited to the first 24 windows and 440 × 280 px per picture.
- A menu bar menu keeps the overview available after closing its window.
- Settings explains Accessibility, optional Screen Recording, and shortcuts.

| Action | Global shortcut |
| --- | --- |
| Show overview | Control–Option–Space |
| Snap focused window left | Option–Command–Left Arrow |
| Snap focused window right | Option–Command–Right Arrow |
| Maximize focused window | Option–Command–Return |
| Restore focused window | Option–Command–R |

While Snapper is in front, arrangement shortcuts act on its selected window.
Command–R refreshes the list; Option–Command–S switches to the selected window.
The menu bar's arrangement actions use the focused external window.

## Build and use

Requires macOS 26+ and full Xcode, including its Swift toolchain.

```sh
./build.sh --open
```

Allow **Snapper** in System Settings → Privacy & Security → Accessibility.
It is required to list and arrange windows. The status refreshes automatically.
Screen Recording is optional: enable it and turn on Previews if you want pictures.
No Input Monitoring permission is needed for this baseline.

A stable Apple Development signing certificate is recommended. The build
selects one automatically, or signs ad hoc when none is available. Ad hoc
rebuilds can require granting permissions again.

## Verification

```sh
swift test --scratch-path /tmp/Snapper-test-build
tools/selftest.sh
tools/snap.sh
tools/grid-lint.sh
swift tools/check-layout.swift /tmp/Snapper-shots/*-layout.json
```

Self-tests and snapshots use a temporary store and sample windows. They never
register global shortcuts or control other apps. `docs/BASELINE.md` records
verification results and remaining manual checks.

Build location overrides: `SNAPPER_BUILD_DIR` and `SNAPPER_APP_PATH`.
For hosts already running inside a process sandbox,
`SNAPPER_DISABLE_SWIFTPM_SANDBOX=1` disables only SwiftPM's nested sandbox.

## Limits and next steps

This is a normal window overview, not a hold-and-release Alt–Tab replacement.
The list includes standard, non-minimized windows exposed by Accessibility;
availability across Spaces depends on the app. Full-screen and fixed-size
windows may refuse arrangement. Some apps enforce a minimum width larger
than half a small display. Refresh after opening or closing external windows.
Previews are snapshots, not continuous video.

Saved groups, arranging multiple windows in one action, configurable shortcuts,
thirds/quarters, and a drag-to-layout overlay are future work. The original
M1/M2 stories in `docs/STORIES.md` remain the longer-term plan.

## Project

`Sources/Snapper/` contains the SwiftUI app and macOS integrations.
`Sources/SnapperKit/` contains geometry rules, tested without controlling apps.
The original SwiftData schema is retained for compatibility with starter stores;
window positions and pictures are not persisted to that database.

The 21 [BAMA](https://github.com/daveebbelaar/bama) skills are vendored under
`.claude/skills/`. See `.claude/skills/README.md` and `.claude/BAMA-LICENSE`.
