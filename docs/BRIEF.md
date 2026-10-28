# Snapper

A menu bar window manager for macOS that puts every open window in one Mission-Control-style panel, so you can switch, close, or arrange them without hunting.

## Replaces
Wins (paid), AltTab, Magnet, Rectangle, and the habit of dragging windows by hand.

## Main jobs
1. Hold ⌥ (or ⌘) and press Tab to open a panel of every window on this Space, with live previews. Release to focus one, press ⌘W to close it, ⌘Q to quit its app.
2. Snap the focused window to the left half, the right half, or full screen with a shortcut, and send it to the next display.
3. Change every shortcut, the accent color, and the snap widths in Settings.

## Data
- Settings: trigger (option or command), previews on or off, accent color id. UserDefaults.
- Shortcuts: action, key code, modifiers, key name. JSON in UserDefaults.
- Layout: wide fraction (default 2/3), gap in points (default 0). UserDefaults.
- Preview cache: window ID to image. Memory only.

## Shape
Menu bar extra with no Dock icon (LSUIElement), plus a floating non-activating panel and a Settings window. macOS 26 or later. Local data. Works offline. No accounts.

## System hooks
Carbon global shortcuts (⌥Tab, ⌥⇧Tab, and the snap combos), a listen-only event tap for the modifier release, Accessibility to move and focus windows, Screen Recording for previews and window titles, Input Monitoring for the tap, menu bar item, launch at login.

## Reference
Wins (windows.cool). The panel is the reference for layout and feel. The spec for the switcher is `specs/window-switcher.md` and for snapping is `specs/window-snapper.md`.

## Look
Native macOS, with an accent color the user picks in Settings (system accent by default). Liquid Glass on the floating panel only, never on content. Apple's controls and system text styles. The panel reads as a refinement of Mission Control, not a web page in a window.

## Not in version one
- Snap Island, the drag-to-edge overlay with layout choices.
- Aero Shake, Dock Preview, Dock Lock, Flick Dock, Hide All Windows.
- A Mission Control across all Spaces or all displays.
- Tiling, window tabs, and virtual desktops.
