import AppKit
import SwiftData
import SwiftUI
import SnapperKit

// Snapper
//   Snapper                      the app
//   APP_STORE=<file> Snapper     use another database (tests, experiments)
//   APP_SNAPSHOT=<dir> Snapper   save a PNG of every sidebar page and Settings tab in light and dark mode, then quit
//   APP_SEED=1 Snapper           fill an empty /tmp store with sample items (tools/snap.sh)
//   Snapper --selftest           run the self-test on a /tmp store and quit with 0 or 1 (tools/selftest.sh)
//   APP_ACCENT=<id> Snapper      run with another accent from Theme.all (UI/Theme.swift)
//   APP_GRID=1 Snapper           draw the 8 pt grid and the layout probes over the window

@main
struct SnapperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @StateObject private var windows = WindowManager()
    @State private var model = AppModel(container: Store.makeContainer())

    var body: some Scene {
        Window("Snapper", id: "main") {
            ContentView()
                .environment(model)
                .environmentObject(windows)
                .themed()
                .overlay { if GridOverlay.enabled { GridOverlay() } }
                .frame(minWidth: 760, minHeight: 480)
        }
        .modelContainer(model.container)
        .defaultSize(width: 880, height: 640)
        .windowToolbarStyle(.unified)
        .commands {
            ToolbarCommands()
            CommandGroup(replacing: .newItem) {}
            CommandMenu("Windows") {
                Button("Show Window Overview") { windows.showOverview() }
                    .keyboardShortcut(.space, modifiers: [.control, .option])
                Button("Refresh Windows") { windows.refresh() }.keyboardShortcut("r")
                Button("Switch to Selected Window") { windows.focus() }
                    .keyboardShortcut("s", modifiers: [.command, .option])
                    .disabled(windows.selected == nil || windows.isDemo)
                Divider()
                ForEach(WindowLayout.allCases) { layout in
                    Button(layout.title) { windows.arrange(layout) }
                        .keyboardShortcut(layout == .left ? .leftArrow : layout == .right ? .rightArrow : .return,
                                          modifiers: [.command, .option])
                        .disabled(windows.selected == nil || windows.isDemo)
                }
                Button("Restore Window") { windows.restore() }
                    .keyboardShortcut("r", modifiers: [.command, .option])
                    .disabled(!windows.canRestore || windows.isDemo)
            }
        }

        MenuBarExtra("Snapper", systemImage: "macwindow.on.rectangle") {
            Button("Show Window Overview (⌃⌥Space)") { windows.showOverview() }
            Divider()
            ForEach(WindowLayout.allCases) { layout in
                Button(layout.title) { windows.arrangeFocused(layout) }
                    .disabled(windows.selected == nil || windows.isDemo)
            }
            Button("Restore Window") { windows.restoreFocused() }.disabled(!windows.hasRestorableWindow)
            Divider()
            SettingsLink()
            Button("Quit Snapper") { NSApp.terminate(nil) }.keyboardShortcut("q")
        }

        Settings {
            SettingsView()
                .environment(model)
                .environmentObject(windows)
                .themed()
        }
        .windowResizability(.contentSize)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Started from a terminal, the process is not a foreground app yet.
        NSApp.setActivationPolicy(.regular)
        NSApp.activate()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }

    /// The self-test's result becomes the exit code, after a normal quit.
    func applicationWillTerminate(_ notification: Notification) {
        if SelfTest.requested { exit(SelfTest.exitCode) }
    }
}

/// Where the data lives: ~/Library/Application Support/Snapper/Snapper.store
enum Store {
    /// True when APP_STORE points somewhere else (tests, snapshots, seed data).
    static var isOverridden: Bool {
        !(ProcessInfo.processInfo.environment["APP_STORE"] ?? "").isEmpty
    }

    static var isTemporary: Bool {
        guard let path = ProcessInfo.processInfo.environment["APP_STORE"] else { return false }
        let resolved = URL(fileURLWithPath: path).resolvingSymlinksInPath().path
        return resolved.hasPrefix("/private/tmp/") || resolved.hasPrefix("/tmp/")
    }

    static var url: URL {
        if let path = ProcessInfo.processInfo.environment["APP_STORE"], !path.isEmpty {
            return URL(fileURLWithPath: path)
        }
        let dir = URL.applicationSupportDirectory.appending(path: "Snapper", directoryHint: .isDirectory)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appending(path: "Snapper.store")
    }

    static func makeContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: Item.self, configurations: ModelConfiguration(url: url))
        } catch {
            fatalError("Could not open the database at \(url.path): \(error)")
        }
    }
}
