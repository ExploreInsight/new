# Personal-use baseline — 28 October 2026

This baseline implements the first useful slice of the BAMA plan: discover and
search individual windows, switch to one, snap left/right/maximize, and restore
the first saved position. Optional window pictures refresh on request.

The overview opens with Control–Option–Space. It is a normal native window,
not yet a hold-and-release Alt–Tab overlay. Arrangement is per window; saved
layouts, drag-to-layout, and automatic multi-window arrangement are next steps.

## Verification

- Full app debug build and bundle signing passed using Xcode's Swift 6.4 toolchain.
- Swift Testing passed: geometry/gaps, coordinate conversion round trips, display
  selection with negative coordinates, gap clamping, and existing title tests.
- In-app self-test passed 9 checks on sample windows and a temporary store:
  discovery fixture, separate same-app search results, visible selection,
  case-insensitive title search, disabled restore, inert sample actions, and
  the three layout symbols. Report: `/tmp/Snapper-selftest-result.txt`.
- Source grid lint and whitespace checks passed. Runtime grid probes passed for
  all six overview/Settings captures.
- Sample overview reviewed in light/dark: six separate windows, readable app
  names and titles, search, arrangement controls, and visible sample-mode status.
- General Settings contains permission status, explanations, and shortcuts;
  Appearance retains the existing system-accent picker. Light/dark captures are
  under `/tmp/Snapper-review3-shots/`. Some window chrome was inactive during
  automated capture, so active focus/contrast still needs an interactive check.

## Remaining hands-on checks

These require the user's actual app permission grants and representative windows:

1. Open two Brave windows and two cmux windows; switch to each exact window.
2. Use global left/right/maximize on an external focused window.
3. Snap twice, then Restore; confirm the original frame returns.
4. Enable previews with Screen Recording and confirm pictures correspond to their
   windows. No picture is written to disk by the preview feature.
5. Test minimum-size windows and monitor/Dock arrangements on the actual display.
6. Check global shortcut conflicts, VoiceOver, and reopening the overview after Close.

The app deliberately skips minimized and non-standard windows. Accessibility may
expose windows from other Spaces. Full-screen/fixed-size windows can reject a
move. Preview failures retain icon-and-title operation. No Input Monitoring,
keystroke logging, accounts, network service, or persistent screenshot cache.

## Development environment

Direct GUI execution from this restricted shell aborted in AppKit. The isolated
sample apps launched through native app control, allowing the self-test and
snapshot workflow to run. Build/test locations were overridden into `/tmp`.
The original personal checkout is outside this session's writable directories;
changes are in a separate checkout. SSH uses the existing `github-personal`
alias. Network access from the shell is currently unable to resolve github.com;
the connected GitHub account reports read-only permission on ExploreInsight/new.
