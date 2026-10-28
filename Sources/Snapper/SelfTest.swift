import AppKit
import SwiftData
import SnapperKit

/// Self-test for agents: runs the app's real functions on a test store,
/// prints PASS or FAIL per check, and quits with exit code 0 or 1.
///   APP_STORE=/tmp/Snapper-self.store ~/Applications/Snapper.app/Contents/MacOS/Snapper --selftest
/// (tools/selftest.sh does this.) Add a check for every story with logic.
@MainActor
enum SelfTest {
    static var requested: Bool { CommandLine.arguments.contains("--selftest") || ProcessInfo.processInfo.environment["APP_SELFTEST"] == "1" }
    /// Read by AppDelegate.applicationWillTerminate.
    static var exitCode: Int32 = 0
    private static var failures = 0
    private static var count = 0
    private static var results: [String] = []

    static func runIfRequested(model: AppModel) {
        guard requested else { return }
        // Print each line at once, so a crash keeps the lines before it.
        setvbuf(stdout, nil, _IOLBF, 0)
        guard Store.isTemporary else {
            print("SELFTEST refused: set APP_STORE to a file in /tmp")
            finish(code: 1)
            return
        }
        Task {
            try? await Task.sleep(for: .seconds(0.5))
            let windows = WindowManager()
            windows.start()
            check("sample windows load without Accessibility", windows.windows.count == 6)
            windows.query = "cmux"
            check("search finds separate windows of the same app", windows.filtered.count == 2)
            check("search selects a visible window", windows.filtered.contains { $0.id == windows.selection })
            windows.query = "PRIVATE"
            check("search matches window titles without case sensitivity", windows.filtered.count == 1)
            check("demo windows cannot be restored", !windows.canRestore)
            let frames = windows.windows.map(\.frame)
            windows.arrange(.left)
            windows.restore()
            windows.focus()
            check("demo actions never move real windows", windows.windows.map(\.frame) == frames)
            for layout in WindowLayout.allCases {
                check("layout symbol exists: \(layout.title)", NSImage(systemSymbolName: layout.symbol, accessibilityDescription: nil) != nil)
            }

            print(failures == 0 ? "SELFTEST PASS \(count) checks" : "SELFTEST FAIL \(failures) of \(count) checks")
            finish(code: failures == 0 ? 0 : 1)
        }
    }

    private static func check(_ name: String, _ ok: Bool, _ detail: String = "") {
        count += 1
        if !ok { failures += 1 }
        results.append(ok ? "PASS \(name)" : "FAIL \(name)")
        print(ok ? "PASS \(name)" : "FAIL \(name)\(detail.isEmpty ? "" : ": \(detail)")")
    }

    /// Quits through NSApp.terminate, never exit(), and closes sheets first:
    /// an open sheet refuses terminate, and the run would wait forever.
    static func finish(code: Int32) {
        exitCode = code
        if Store.isTemporary {
            let report = (results + ["SELFTEST exit \(code)"]).joined(separator: "\n")
            try? report.write(toFile: "/tmp/Snapper-selftest-result.txt", atomically: true, encoding: .utf8)
        }
        for window in NSApp.windows { if let sheet = window.attachedSheet { window.endSheet(sheet) } }
        NSApp.terminate(nil)
    }
}
