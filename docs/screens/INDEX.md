# Screen index

Reference: [wins.cool](https://wins.cool), the public website only.

No screens were captured. The app was never installed, so there are no
screenshots to index. What this file holds is the layout and behaviour
reference, written from what the site states, plus the navigation map and the
command map.

The full feature breakdown is in
[../research/wins-reference.md](../research/wins-reference.md).

## The switcher panel

Page: the panel that opens when the switcher is triggered.
Reached from: the system level ⌘-Tab, or the configured trigger.
Layout: one floating surface over the desktop, holding a card for every window
on the current Space. Each card carries the app icon, the window title, and a
live preview of the window.
Elements: one card per window. The selected card is marked with an accent
border. A keystroke legend sits at the bottom of the screen showing the next
key.
Actions: Tab steps forward, ⇧Tab steps back, the arrow keys move between
cards, Return commits, Esc cancels, ⌘W closes the selected window, ⌘Q quits
the app of the selected window.
Shortcuts seen: ⇡ ⇣ ⇠ ⇢ to move, ⌘W to close, ⌘Q to quit.

## The Dock preview

Page: a popup above a Dock icon.
Reached from: hovering a Dock icon.
Layout: one rounded rectangle floating above the Dock icon, holding a preview
of every window of that app.
Actions: hover to show, move to another Dock icon to change the app, click to
focus.
Shortcut: click a Dock icon a second time to minimize that window. The site
calls this Flick Dock.

## Edge split

Page: the desktop while a window is being dragged.
Layout: an outline shows where the window will land.
Actions: drag a window to the edge of the screen to split it.

## Snap Island

Page: a floating strip that appears while a window is dragged.
Layout: a row of layout choices the drag can land on.
Actions: drag onto a choice to apply that layout.

## Aero Shake

Page: the desktop while a window is shaken.
Layout: the shaken window stays, the others are hidden.
Actions: drag a window left to right and back in an oval to hide the rest.

## Mission Control

Page: the system Mission Control overview.
Layout: the normal grid of window groups.
Actions: ⌘W closes the window under the pointer, ⌘Q quits its app.

## Hide others and hide all

Page: the desktop with the windows hidden.
Actions: one shortcut hides the others, another hides all of them.

## Dock Lock

Page: a notice, shown when the requirements are not met.
Layout: a list of requirements with a checkmark or a cross, then a button that
opens the right System Settings pane.
Requirements: the Dock at the bottom, "Automatically hide and show the Dock"
off, and "Displays have separate Spaces" on. May require signing out.

## Navigation map

```
System Settings > Snapper          a pane, like the site describes for Wins
  ├─ General       turn each feature on and off
  ├─ Shortcuts     every action with a recorded combo
  ├─ Appearance    accent colour, light and dark
  └─ Permissions  Accessibility, Screen Recording, Input Monitoring

Snapper's own menu bar item
  ├─ the trigger, and a way to change it
  ├─ a warning row when a permission is off
  ├─ Settings
  └─ Quit
```

## Command map

| Command | Shortcut | Permission |
| --- | --- | --- |
| Switch windows | system level ⌘-Tab | Accessibility, Screen Recording |
| Step forward | Tab | none |
| Step back | ⇧Tab | none |
| Move the selection | ⇡ ⇣ ⇠ ⇢ | none |
| Commit | Return | none |
| Cancel | Esc | none |
| Close the selected window | ⌘W | Accessibility |
| Quit the selected app | ⌘Q | Accessibility |
| Snap left half | configurable | Accessibility |
| Snap right half | configurable | Accessibility |
| Maximise | configurable | Accessibility |
| Snap wide left | configurable | Accessibility |
| Snap wide right | configurable | Accessibility |
| Next display | configurable | Accessibility |
| Previous display | configurable | Accessibility |
| Restore | configurable | Accessibility |
| Hide other windows | configurable | Accessibility |
| Hide all windows | configurable | Accessibility |
| Dock preview | hover a Dock icon | Screen Recording |
| Aero shake | drag a window in a circle | Accessibility, Input Monitoring |

## Data model guess

```
Shortcut   id, keyCode, modifiers, keyName, isEnabled
Action     id, title, glyph, defaultShortcut, category
Setting    toggle or choice, per category
Permission kind, state
Layout     wideFraction, gap, snapKind
```

Nothing in a database. Settings in `UserDefaults`. No window history, no
account, no network.

## Look

- The system accent colour.
- Floating surfaces are rounded, about 32 pt on the corners.
- The switcher is one floating surface, not a grid of separate windows.
- App icons are template images next to the title.
- Titles in the system text style, secondary colour.
- Dark mode follows the system.

## What Snapper takes from this

- The switcher replaces the system ⌘-Tab.
- The panel holds a card per window with an icon, a title and a live preview.
- The selected card is marked with an accent border.
- ⌘W closes and ⌘Q quits from the panel.
- A keystroke legend at the bottom tells the user what the next key does.
- Every layout has a shortcut, and every shortcut is configurable.
- Permission states sit on one Settings page, each with a button that opens
  the right System Settings pane.
