# Reference: Wins (wins.cool)

Source: the public website only. The app was not installed and nothing was
copied out of it. Everything below is what wins.cool states about itself.

Wins is a Mac app that adds Windows-like window management. It charges a
one-time fee per licence, from $11.99 to $29.99, with a one-day free trial.
It claims 13,266 users.

## Features, as the site lists them

| Feature | What the site says |
| --- | --- |
| Dock Lock | Lock your Dock to any display, so it stays right where you want it and you stay focused. Needs the Dock at the bottom, "Automatically hide and show the Dock" off, and "Displays have separate Spaces" on. |
| Snap Island | Drag to see Snap Island and drag on to quick split. |
| Cmd-Tab Plus | System-level ⌘-Tab, upgraded. Preview, switch, and close in a flash, no mouse needed. Navigate with ⇡⇣⇠⇢, finish with ⌘W/⌘Q. The site calls this "the one we're most proud of". |
| Flick Dock | Clicking the Dock a second time automatically minimizes its window. |
| Mission Control Pro | Enhance Mission Control. Also supports closing windows fast with ⌘+W, or exiting apps with ⌘+Q in Mission Control. |
| Dock Preview | Hover the mouse over the Dock to show a preview of all the windows of that app. |
| Aero Shake | Drag a window and repeat from left to right following the oval pattern, then it focuses on one window. |
| Quick Split Window | Drag the window to the edge of the screen to split a window. |
| Hide other windows | Hide other windows with a single keystroke. |
| Hide All Windows | Hide all windows with just one shortcut key, the fastest way to declutter your Mac screen. |
| Move to another display | Move windows between displays with ease. |
| Custom Keyboard Shortcuts | Customize your shortcut keys to trigger any window layout you want. |
| System Level Integration | No separate window, dock or menu bar. The settings live in System Settings. |
| Dark Mode | "Following the Trend" aligns with the Mac. |
| High Efficiency | Memory under 30 MB, CPU under 10%, and in most cases about 0.1%. |
| Apple Silicon | Native support for Apple Silicon and Intel. |
| Compatibility | macOS 12 or higher, including macOS 27. |

## Command map

Every command Wins exposes, as stated on the site. Every shortcut except the
switcher ones is configurable by the user.

| Command | Shortcut | Permission it needs |
| --- | --- | --- |
| Switch windows | system-level ⌘-Tab | Accessibility, Screen Recording |
| Step between windows | ⇡ ⇣ ⇠ ⇢ | none |
| Close the selected window | ⌘W | Accessibility |
| Quit the app of the selected window | ⌘Q | Accessibility |
| Close a window in Mission Control | ⌘W | Accessibility |
| Quit an app in Mission Control | ⌘Q | Accessibility |
| Quick split by dragging to an edge | drag | Accessibility |
| Hide other windows | configurable | Accessibility |
| Hide all windows | configurable | Accessibility |
| Move to another display | configurable | Accessibility |
| Aero shake | drag a window in a circle | Accessibility, Input Monitoring |
| Dock preview | hover a Dock icon | Screen Recording |
| Flick Dock | click a Dock icon twice | none |
| Dock Lock | configurable | none |

## Shape

- No separate window, no separate dock, no menu bar item. The settings are a
  pane inside System Settings.
- The switcher is a system-level ⌘-Tab replacement.
- Mission Control is the existing one, enhanced.

## What the site says it replaces

Nothing by name. It says it "makes your Mac experience more efficient with
Windows-like window management features, quick splitting, and enhanced
productivity tools", and users call it "essential Mac productivity tool" and
"a game-changer for multitasking".

## What Snapper takes from this

- The switcher is a system-level ⌘-Tab replacement, not a separate shortcut.
- The switcher shows previews, and closes with ⌘W and quits with ⌘Q.
- Mission Control is where ⌘W and ⌘Q also work.
- Snap by dragging to a screen edge.
- Shortcuts for every layout, all configurable.
- Settings live in System Settings, not in a separate window.
- The whole thing must stay cheap: under 30 MB of memory.

## Where Snapper differs

- Snapper is a menu bar app. It is easier to ship than a System Settings
  extension, and a System Settings pane cannot hold the live switcher panel.
- Snapper's panel covers the current Space only. Mission Control across every
  Space is a separate job.
- Snapper uses the system accent colour, which the user can change in
  Snapper's own Settings. The site says Wins follows the system.
