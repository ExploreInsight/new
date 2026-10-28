# Screen index

Reference: **Wins 3.6.1** (cools.wins.main), the app Snapper is modelled on.

Screens were captured from the demo videos bundled in
`Wins.app/Contents/Resources/Wins.prefPane/Contents/Resources/`. The frames are
Wins' own artwork and are not kept in this repo. What follows is what was
measured from them.

The videos are one per feature:

| Video | Feature |
| --- | --- |
| `commandTabPlus.mp4` | Cmd-Tab Plus, the switcher panel |
| `dockPreviewView_en.mp4` | Dock Preview |
| `snapIsland_en.mp4` | Snap Island, the drag overlay |
| `edgeSnap.mp4` | Edge snap, the target outline |
| `aeroShakeView_en.mp4` | Aero Shake |
| `missionControlProStatus.mp4` | Mission Control Pro |
| `missionControlProClosesWindow.mp4` | Mission Control Pro, closing a window |
| `missionControlProQuitApp.mp4` | Mission Control Pro, quitting an app |
| `hiddenAllWindow_en.mp4` | Hide All Windows |
| `hiddenOtherWindows_en.mp4` | Hide Other Windows |
| `nextDisplay.mp4`, `prevDisplay.mp4` | Move to another display |
| `flickDock.mp4` | Flick Dock |
| `dockLock.mp4` | Dock Lock |
| `center_en.mp4` | Centre a window |

## 01 Dock preview

Page: a popup above a Dock icon. Reached from: hovering a Dock icon.
Layout: one rounded rectangle, corner radius about 32 pt, floating above the
Dock icon. Inside it the window preview, and under the preview the app name in
a system text style, centred.
Elements: window preview image, app name label.
Actions: hover to show, move to another Dock icon to change the app, click to
focus.
Notes: the popup is not a window of the app being previewed. It belongs to
Wins and floats over everything.

## 02 Cmd-Tab Plus

Page: the switcher panel. Reached from: holding the trigger and pressing Tab.
Layout: the windows of the current Space laid out in a grid across the screen,
each as a card with the app icon and the window title. The selected card is
marked with an accent border.
Elements: one card per window, each holding the window preview, the app icon,
and the title. A keystroke legend sits at the bottom of the screen showing
the next key, for example ⌘ and an arrow.
Actions: Tab steps forward, ⇧Tab steps back, ⌘W closes the selected window,
⌘Q quits the app of the selected window, arrows move between cards, Return
commits.
Shortcuts seen: ⌘ plus an arrow for the legend, ⌘W close, ⌘Q quit.

## 03 Edge snap

Page: the screen itself while a window is being dragged.
Layout: a coloured outline shows where the window will land. The outline is the
system accent blue, 4 pt, with rounded corners.
Actions: drag a window to an edge, release to snap.

## 04 Mission Control Pro

Page: the Mission Control overview. Reached from: the system shortcut.
Layout: the normal Mission Control grid of window groups, with the added
ability to close a window or quit an app from it.
Actions: ⌘W closes the window under the pointer, ⌘Q quits its app.

## 05 Snap Island

Page: a floating strip that appears when a window is dragged. Reached from:
dragging any window.
Layout: a row of layout choices that the drag can land on.
Actions: drag onto a choice to apply that layout.

## 06 Dock Lock

Page: a notice. Reached from: trying to turn Dock Lock on when the
requirements are not met.
Layout: a small dialog listing the requirements, each with a checkmark or a
cross, then a button that opens the right System Settings pane.
Copy seen: "Turn off Automatically hide and show the Dock", "Position the Dock
at the bottom", "Turn on Displays have separate Spaces", "May require signing
out."

## 07 Aero Shake

Page: the screen while a window is shaken. Reached from: shaking a window.
Layout: the shaken window stays, the others are hidden.
Actions: shake a window to hide the rest.

## 08 Hide All and Hide Others

Page: the screen with the windows hidden. Reached from: a shortcut.
Actions: one shortcut hides the others, another hides all.

## Navigation map

```
menu bar item
  ├─ switch trigger (⌥Tab or ⌘Tab)
  ├─ snap actions (left, right, wide, full, next display, restore)
  ├─ hide others, hide all
  ├─ Settings (a pane in System Settings)
  └─ Quit
Settings pane
  ├─ General: enable switches, per feature on and off
  ├─ Shortcuts: every action with a recorded combo
  ├─ Appearance: dark mode follows the system
  ├─ Permissions: Accessibility, Screen Recording, Input Monitoring
  └─ Activation: license key and email
```

## Command map

| Command | Shortcut | Permission |
| --- | --- | --- |
| Switch windows | hold ⌥ or ⌘, then Tab | Accessibility, Screen Recording |
| Step forward | Tab | none |
| Step back | ⇧Tab | none |
| Move selection | arrows | none |
| Commit | Return | none |
| Cancel | Esc | none |
| Close window | ⌘W | Accessibility |
| Quit app | ⌘Q | Accessibility |
| Snap left half | configurable, default ⌥⌘← | Accessibility |
| Snap right half | configurable, default ⌥⌘→ | Accessibility |
| Maximise | configurable, default ⌥⌘↩ | Accessibility |
| Snap wide left | configurable, default ⌥⌘↓ | Accessibility |
| Snap wide right | configurable, default ⌥⌘↑ | Accessibility |
| Next display | configurable, default ⌃⌥⌘→ | Accessibility |
| Previous display | configurable, default ⌃⌥⌘← | Accessibility |
| Restore | configurable, default ⌥⌘⌫ | Accessibility |
| Hide others | configurable | Accessibility |
| Hide all | configurable | Accessibility |
| Dock preview | hover a Dock icon | Screen Recording |
| Aero shake | shake a window | Accessibility, Input Monitoring |

## Data model guess

```
Shortcut   id, keyCode, modifiers, keyName, isEnabled
Action     id, title, glyph, defaultShortcut, category
Setting    toggle or choice, per category
Permission kind (accessibility, screenRecording, inputMonitoring), state
Layout     wideFraction, gap, snapKind
```

Nothing is stored in a database. Settings live in `UserDefaults`. Wins keeps no
window history and no account.

## Look

- System accent colour. The edge snap outline is the system blue.
- Card corner radius about 32 pt on floating surfaces.
- The switcher panel is one floating surface, not a grid of separate windows.
- App icons are template images, 16 to 20 pt, next to the title.
- Titles in the system text style, secondary colour.
- Dark mode follows the system, no separate setting.

## What Snapper takes from this

- The panel is one floating surface with a grid of window cards, each with an
  app icon and a title.
- The selected card is marked with an accent border, not a fill.
- The close and quit actions belong to the panel, on ⌘W and ⌘Q.
- A keystroke legend at the bottom tells the user what the next key does.
- Permission states live on one Settings page, each with a button that opens
  the right System Settings pane.
