# Stories

Backlog for Snapper. Each acceptance line says how to check it.

Sources: `specs/window-switcher.md` and `specs/window-snapper.md`. Stories marked
"Wins" are the ones Wins 3.6 has and the two specs do not.

## B0 Personal-use baseline

Status: implemented; verification and manual limits in `BASELINE.md`.

As the user on one small monitor, I find an individual window, switch to it,
arrange it on either half of the screen or maximize it, and restore its frame.

Acceptance:
- Search distinguishes multiple windows of the same app.
- Global shortcuts and menu bar actions arrange the focused external window.
- Overview buttons arrange its selected window.
- Repeated snaps keep the frame from before the first snap for Restore.
- Accessibility guidance appears inline; optional preview permission is separate.
- Sample mode never registers hotkeys, captures content, or controls app windows.
- Unit tests cover gaps, display selection, and coordinate conversion.

UX:
- Flow: overview shortcut → select/search a window → Switch or layout action.
- Surface: a normal window with a native list and visible arrangement controls;
  menu bar menu reopens it. Close dismisses the overview; Quit exits the utility.
- States: no permission with Open Accessibility; no windows; no search matches;
  preview loading; unavailable preview with app icon; inline operation feedback.
- Words: Window overview, Switch, Left Half, Right Half, Maximize, Restore, Previews.
- Access: native list keyboard selection, labeled controls, full titles in tooltips,
  menu commands with shortcuts, light and dark system styles.

## M1 Core loop (planned hold-to-switch experience)

### S-001 Open the panel with ⌥Tab
As the user, I hold ⌥ and press Tab, and a panel shows every window on this Space.
Screens: panel.png
Acceptance:
- [snap] Tiles show the app icon and the window title, with the second tile selected.
- [unit] The window filter drops layer 1 windows, windows under 60 pt, and windows with alpha 0.
- [manual] The panel shows about 90 ms after the press, centered on the screen under the pointer.
Status: todo

### S-002 Step through windows
As the user, I press Tab again to move forward and ⇧Tab to move back while holding ⌥.
Depends: S-001
Acceptance:
- [unit] Stepping past the last item wraps to the first, and back from the first wraps to the last.
- [snap] The accent border sits on the selected tile.
Status: todo

### S-003 Let go to switch
As the user, I let go of ⌥ and the selected window comes to the front with keyboard focus.
Depends: S-001
Acceptance:
- [manual] Picking the second window of the same app (two Finder windows) focuses that window, not just the app.
- [manual] Typing right after the switch goes into the new window.
- [manual] A quick tap of ⌥Tab lands in the window I used before and never shows the panel.
Status: todo

### S-004 Cancel with Esc
As the user, I press Esc while holding ⌥ and the panel closes without switching.
Depends: S-001
Acceptance:
- [self] After cancel, the session keys (Esc, arrows, Return) are unregistered.
Status: todo

### S-005 Grant Accessibility, Input Monitoring, and Screen Recording
As the user, I open Snapper for the first time and Settings shows all three permissions with Grant buttons.
Screens: settings-permissions.png
Acceptance:
- [snap] Each row shows On or Off, one line on what breaks without it, and a Grant button.
- [manual] Within 2 seconds of a grant in System Settings, the row shows On and ⌥Tab works without a restart.
- [manual] Settings opens by itself at launch while Accessibility is off.
Status: todo

### S-006 Menu bar item
As the user, I click the Snapper icon to see the trigger, open Settings, or quit.
Screens: menu.png
Acceptance:
- [snap] The menu shows "Switch windows: ⌥⇥", a warning row when a permission is off, Settings, and Quit.
Status: todo

### S-007 Snap the focused window to the left half
As the user, I press ⌥⌘← and the focused window fills the left half of its screen.
Acceptance:
- [unit] `Layout` returns x = area.minX, width = area.width / 2, full height for a 1440x875 area.
- [unit] A frame flipped twice equals the original.
- [manual] In Safari, ⌥⌘← fills the left half below the menu bar and above the Dock.
Status: todo

### S-008 Snap the focused window to the right half
As the user, I press ⌥⌘→ and the focused window fills the right half.
Depends: S-007
Acceptance:
- [unit] `Layout` returns x = area.midX and the same width as the left half.
- [manual] TextEdit snaps right on a second display when its window is on that display.
Status: todo

### S-009 Maximize the focused window
As the user, I press ⌥⌘↩ and the focused window fills the screen without going full screen.
Acceptance:
- [unit] `Layout` returns the whole visible frame.
Status: todo

### S-010 Snap from the menu bar
As the user, I click the Snapper icon and pick a snap action; it moves the window I was using before.
Screens: menu.png
Acceptance:
- [snap] The menu lists every action with its layout glyph and current shortcut, then Settings and Quit.
- [manual] Clicking Left Half snaps the last app's window, not Snapper's own.
Status: todo

### S-011 Close a window from the panel (Wins)
As the user, I press ⌘W while the panel is open and the selected window closes.
Depends: S-001
Acceptance:
- [manual] ⌘W closes the selected window and the panel moves to the next tile.
- [manual] ⌘W on the last tile closes it and the panel closes.
- [manual] Closing a window of the front app does not quit the app.
Status: todo

### S-012 Quit an app from the panel (Wins)
As the user, I press ⌘Q while the panel is open and the app of the selected window quits.
Depends: S-001
Acceptance:
- [manual] ⌘Q quits the app, every window of it disappears from the panel, and the panel closes.
- [manual] Snapper itself is never quit by ⌘Q in the panel.
Status: todo

## M2 Previews and settings

### S-013 Show window previews
As the user, I see a picture of each window in its tile.
Depends: S-001
Screens: panel-previews.png
Acceptance:
- [manual] Tiles show cached pictures at once and fresh ones within a moment.
- [self] A session with 12 windows captures at most 24 and never above 440 by 280 px.
Status: todo

### S-014 Work without Screen Recording
As the user, I use Snapper without Screen Recording and still find my windows.
Depends: S-013
Acceptance:
- [snap] Tiles show a large app icon in place of the picture, and the app name as the title.
- [snap] Settings shows "Screen Recording: Off. Previews and window titles need it." with a Grant button.
Status: todo

### S-015 Move with arrows and click
As the user, I use the arrow keys while holding ⌥, or click a tile.
Depends: S-002
Acceptance:
- [unit] ↓ moves the selection by the column count and wraps.
- [manual] One click on a tile switches, even though the panel is not key.
Status: todo

### S-016 Use ⌘Tab as the trigger
As the user, I pick "⌘ Tab (replaces the macOS app switcher)" in Settings.
Screens: settings-switcher.png
Acceptance:
- [manual] ⌘Tab opens Snapper and the macOS app switcher does not appear.
- [manual] After quitting Snapper, ⌘Tab shows the macOS app switcher again.
Status: todo

### S-017 Turn the switcher or previews off
As the user, I turn off the switcher or the previews in Settings.
Acceptance:
- [self] With the switcher off, no trigger hotkey is registered.
- [self] With previews off, opening the switcher starts no capture.
Status: todo

### S-018 Record a new shortcut
As the user, I click a shortcut field in Settings and press a new combo.
Screens: settings-shortcuts.png
Acceptance:
- [snap] The field shows "Type shortcut…" with an accent border while recording.
- [self] While recording, all global shortcuts are paused and come back after.
- [unit] Assigning a combo used by another action removes it from that action.
- [manual] Esc cancels, Delete clears, a key without a modifier beeps.
- [snap] A combo another app owns shows an orange triangle with help text "Another app already uses this shortcut."
Status: todo

### S-019 Pick the wide width and the gap
As the user, I choose Two thirds, Three quarters, or Five sixths, and a gap from 0 to 40 pt.
Screens: settings-layout.png
Acceptance:
- [unit] With a 10 pt gap, two halves leave 10 pt at each screen edge and 10 pt between them.
- [snap] The Left Wide row title changes to "Left Wide (3/4)".
Status: todo

### S-020 Move the window to the next display
As the user, I press ⌃⌥⌘→ and the window moves to the next display at the same relative spot.
Acceptance:
- [unit] A left-half window on a 1440 wide display becomes a left-half window on a 2560 wide display.
- [unit] With one display, the command returns no frame.
- [manual] Moving from a large display to a small one ends with the right size, not a clamped one.
Status: todo

### S-021 Restore a snapped window
As the user, I press ⌥⌘⌫ and the window goes back to where it was before I first snapped it.
Acceptance:
- [unit] Two snaps in a row keep the frame from before the first snap.
- [manual] Restore with nothing stored beeps.
Status: todo

### S-022 Launch at login
As the user, I turn on "Open at login" in Settings.
Acceptance:
- [self] The toggle reflects `SMAppService.mainApp.status`.
Status: todo

### S-023 Pick an accent color
As the user, I choose an accent color in Settings and the app uses it.
Screens: settings-appearance.png
Acceptance:
- [snap] The picker shows the system accent plus a row of colors, with the current one selected.
- [snap] The panel's selected tile uses the accent fill and border.
Status: todo

## M3 Later

- Snap Island: a drag overlay with layout choices.
- Dock Preview: hover a Dock icon to see that app's windows.
- Aero Shake: shake a window to hide the others.
- Hide All Windows and Hide Others.
- Dock Lock and Flick Dock.
- A Mission Control across all Spaces and displays.

## Dropped
- Activity log of switches
- Per-feature animation speed setting
- URL scheme and debug bridge preview command
