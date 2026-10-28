import AppKit
import Combine
import ScreenCaptureKit
import SnapperKit

final class WindowManager: ObservableObject {
    @Published private(set) var windows: [ManagedWindow] = []
    @Published var selection: UUID?
    @Published var query = "" {
        didSet {
            if !filtered.contains(where: { $0.id == selection }) { selection = filtered.first?.id }
        }
    }
    @Published private(set) var accessibility = false
    @Published private(set) var screenRecording = false
    @Published private(set) var message = "Choose a window, then choose where it belongs."
    @Published private(set) var previews: [UUID: NSImage] = [:]
    @Published private(set) var loadingPreviews = false
    @Published var previewsEnabled = UserDefaults.standard.bool(forKey: "windows.previews") {
        didSet {
            if !isDemo { UserDefaults.standard.set(previewsEnabled, forKey: "windows.previews") }
            refresh()
        }
    }
    var openOverview: (() -> Void)?
    private let shortcuts = GlobalShortcuts()
    private var started = false
    private var permissionTask: Task<Void, Never>?
    private var previewTask: Task<Void, Never>?
    private var originals: [(AXUIElement, CGRect)] = []
    private var lastExternalPID: pid_t?
    private var generation = 0

    var isDemo: Bool {
        Store.isTemporary && (ProcessInfo.processInfo.environment["APP_SEED"] == "1" || SelfTest.requested)
    }
    var selected: ManagedWindow? { windows.first { $0.id == selection } }
    var hasRestorableWindow: Bool { !originals.isEmpty }
    var canRestore: Bool {
        guard let element = selected?.element else { return false }
        return originals.contains { CFEqual($0.0, element) }
    }
    var filtered: [ManagedWindow] {
        windows.filter { query.isEmpty || "\($0.appName) \($0.title)".localizedStandardContains(query) }
    }

    func start() {
        guard !started else { return }
        started = true
        if isDemo { loadDemo(); return }
        shortcuts.perform = { [weak self] id in
            guard let self else { return }
            if id == 0 { self.showOverview() }
            else { self.actOnFrontWindow(id: id) }
        }
        if !shortcuts.start() { message = "A shortcut is already in use. Quit the conflicting app, then reopen Snapper." }
        refresh()
        permissionTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2))
                guard let self else { return }
                let trusted = AXIsProcessTrusted()
                let capture = CGPreflightScreenCaptureAccess()
                if trusted != self.accessibility || capture != self.screenRecording { self.refresh() }
            }
        }
    }

    func refresh() {
        guard !isDemo else { return }
        generation += 1
        previewTask?.cancel()
        loadingPreviews = false
        accessibility = AXIsProcessTrusted()
        screenRecording = CGPreflightScreenCaptureAccess()
        if let front = NSWorkspace.shared.frontmostApplication, front.processIdentifier != getpid() {
            lastExternalPID = front.processIdentifier
        }
        guard accessibility else { windows = []; selection = nil; previews = [:]; return }
        windows = WindowAccess.windows(previous: windows)
        if !windows.contains(where: { $0.id == selection }) {
            selection = windows.first(where: { $0.pid == lastExternalPID })?.id ?? windows.first?.id
        }
        originals.removeAll { saved in !windows.contains { $0.element.map { CFEqual($0, saved.0) } == true } }
        let ids = Set(windows.map(\.id))
        previews = previews.filter { ids.contains($0.key) }
        if !screenRecording || !previewsEnabled { previews = [:]; return }
        let version = generation
        let candidates = Array(windows.prefix(24))
        previewTask = Task { [weak self] in
            guard let self else { return }
            self.loadingPreviews = true
            defer { if self.generation == version { self.loadingPreviews = false } }
            do {
                let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
                for window in candidates {
                    guard !Task.isCancelled, self.generation == version else { return }
                    // Match only an unambiguous window. Never show another window's content.
                    let matches = content.windows.filter {
                        $0.owningApplication?.processID == window.pid &&
                        abs($0.frame.minX - window.frame.minX) < 2 &&
                        abs($0.frame.minY - window.frame.minY) < 2 &&
                        abs($0.frame.width - window.frame.width) < 2 &&
                        abs($0.frame.height - window.frame.height) < 2 &&
                        ($0.title == window.title || $0.title == nil || $0.title == "")
                    }
                    guard matches.count == 1, let source = matches.first else { continue }
                    let config = SCStreamConfiguration()
                    let scale = min(440 / source.frame.width, 280 / source.frame.height)
                    config.width = max(1, Int(source.frame.width * scale))
                    config.height = max(1, Int(source.frame.height * scale))
                    config.showsCursor = false
                    let filter = SCContentFilter(desktopIndependentWindow: source)
                    guard let image = try? await SCScreenshotManager.captureImage(contentFilter: filter, configuration: config) else { continue }
                    guard !Task.isCancelled, self.generation == version else { return }
                    self.previews[window.id] = NSImage(cgImage: image, size: .zero)
                }
            } catch {
                if self.generation == version { self.message = "Previews unavailable. You can still select and arrange windows." }
            }
        }
    }

    func showOverview() {
        refresh()
        openOverview?()
        NSApp.activate()
        NSApp.windows.first { $0.identifier?.rawValue == "main" }?.makeKeyAndOrderFront(nil)
    }

    func focus() {
        guard !isDemo, let window = selected else { return }
        message = WindowAccess.focus(window) ? "Switched to \(window.appName)." : "Unable to focus this window. Refresh and try again."
    }

    func arrange(_ layout: WindowLayout) {
        guard !isDemo, AXIsProcessTrusted(), let window = selected,
              let element = window.element, let current = WindowAccess.frame(element),
              let primary = NSScreen.screens.first else { return }
        let areas = NSScreen.screens.map { WindowGeometry.flip($0.visibleFrame, primaryHeight: primary.frame.height) }
        guard let index = WindowGeometry.screenIndex(for: current, screens: areas) else { return }
        let original = originals.first { CFEqual($0.0, element) }
        // Store the original before trying: some apps accept only part of a move.
        if original == nil { originals.append((element, current)) }
        let success = WindowAccess.move(window, to: layout.frame(in: areas[index]))
        let focused = WindowAccess.focus(window)
        refresh()
        message = success && focused ? "Moved \(window.appName) to \(layout.title.lowercased())." : "This window could not be fully arranged. Try another window, or Restore. Some apps enforce a minimum size."
    }

    func restore() {
        guard !isDemo, let window = selected, let element = window.element,
              let index = originals.firstIndex(where: { CFEqual($0.0, element) }) else { return }
        if WindowAccess.move(window, to: originals[index].1) {
            originals.remove(at: index)
            _ = WindowAccess.focus(window)
            refresh()
            message = "Restored \(window.appName)."
        } else { message = "Unable to restore this window. Check that its display is connected." }
    }

    func arrangeFocused(_ layout: WindowLayout) {
        let id: UInt32 = layout == .left ? 1 : layout == .right ? 2 : 3
        actOnFrontWindow(id: id)
    }

    func restoreFocused() { actOnFrontWindow(id: 4) }

    private func actOnFrontWindow(id: UInt32) {
        guard let front = NSWorkspace.shared.frontmostApplication, front.processIdentifier != getpid() else {
            if id == 4 { restore() } else if let layout = [WindowLayout.left, .right, .maximize][safe: Int(id) - 1] { arrange(layout) }
            return
        }
        refresh()
        let app = AXUIElementCreateApplication(front.processIdentifier)
        guard let value = WindowAccess.attribute(app, kAXFocusedWindowAttribute), CFGetTypeID(value) == AXUIElementGetTypeID(),
              let match = windows.first(where: { $0.element.map { CFEqual($0, value) } == true }) else { return }
        selection = match.id
        if id == 4 { restore() } else if let layout = [WindowLayout.left, .right, .maximize][safe: Int(id) - 1] { arrange(layout) }
    }

    func openPermission(_ pane: String) {
        guard !isDemo, let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?\(pane)") else { return }
        NSWorkspace.shared.open(url)
    }

    private func loadDemo() {
        let samples = [("Brave Browser", "Research — Brave"), ("Brave Browser", "Private Window"),
                       ("ChatGPT", "Plan my next feature"), ("Claude", "Review the implementation"),
                       ("cmux", "Snapper — terminal"), ("cmux", "Backend — development server")]
        windows = samples.map { ManagedWindow(id: UUID(), pid: 0, appName: $0.0, title: $0.1,
            frame: CGRect(x: 0, y: 0, width: 800, height: 600), element: nil,
            icon: NSImage(systemSymbolName: "macwindow", accessibilityDescription: nil)) }
        selection = windows.first?.id
        message = "Sample windows for review. Demo mode never controls other apps."
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? { indices.contains(index) ? self[index] : nil }
}
