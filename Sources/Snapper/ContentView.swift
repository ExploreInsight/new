import SwiftUI
import SnapperKit

struct ContentView: View {
    @Environment(AppModel.self) private var model
    @EnvironmentObject private var windows: WindowManager
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(alignment: .leading, spacing: Space.lg) {
            header.gridProbe("header", area: "overview")
            if !windows.accessibility && !windows.isDemo {
                permissionNotice.gridProbe("permission", area: "overview")
            }
            HStack {
                TextField("Find an app or window", text: $windows.query)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Find an app or window")
                Toggle("Previews", isOn: $windows.previewsEnabled)
                    .help("Show window pictures with Screen Recording permission. Pictures stay in memory.")
                if windows.loadingPreviews { ProgressView().controlSize(.small) }
            }
            .gridProbe("search", area: "overview")
            if windows.previewsEnabled && !windows.screenRecording && !windows.isDemo {
                HStack {
                    Text("Window previews need Screen Recording. Window names and arranging still work.")
                        .foregroundStyle(.secondary)
                    Button("Open Screen Recording") { windows.openPermission("Privacy_ScreenCapture") }
                }
            }
            windowList
            VStack(alignment: .leading, spacing: Space.lg) {
                actions.gridProbe("actions", area: "footer")
                Text(windows.message)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel("Status: \(windows.message)")
                    .gridProbe("status", area: "footer")
            }
            .gridArea("footer", inset: 0)
        }
        .padding(Space.margin)
        .gridArea("overview")
        .navigationTitle("Windows")
        .noInitialFocus()
        .toolbar {
            ToolbarItem {
                Button("Refresh Windows", systemImage: "arrow.clockwise") { windows.refresh() }
                    .help("Refresh open windows (Command-R)")
            }
        }
        .task {
            windows.openOverview = { openWindow(id: "main") }
            windows.start()
            SelfTest.runIfRequested(model: model)
            Snapshot.runIfRequested(model: model, openSettings: openSettings)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Space.sm) {
            Text("Make room for what matters").font(.title2).bold()
            Text("Choose a window. Give it a place. Keep the rest within reach.")
                .foregroundStyle(.secondary)
            Text("Open overview: ⌃⌥Space · Arrange focused window: ⌥⌘← / → / Return · Restore: ⌥⌘R")
                .font(.callout).foregroundStyle(.secondary)
        }
    }

    private var permissionNotice: some View {
        VStack(alignment: .leading, spacing: Space.sm) {
            Label("Allow Accessibility to find and arrange your windows", systemImage: "hand.raised")
                .font(.headline)
            Text("Enable Snapper in System Settings, then return here. The window list updates automatically.")
                .foregroundStyle(.secondary)
            Button("Open Accessibility") { windows.openPermission("Privacy_Accessibility") }
        }
    }

    private var windowList: some View {
        List(selection: $windows.selection) {
            ForEach(windows.filtered) { window in
                HStack(spacing: Space.md) {
                    if let preview = windows.previews[window.id] {
                        Image(nsImage: preview).resizable().scaledToFit()
                            .frame(width: 144, height: 88)
                            .accessibilityLabel("Window preview")
                    } else if let icon = window.icon {
                        Image(nsImage: icon).resizable().scaledToFit()
                            .frame(width: 32, height: 32).accessibilityHidden(true)
                    }
                    VStack(alignment: .leading, spacing: Space.xs) {
                        Text(window.title).lineLimit(1).help(window.title)
                        Text(window.appName).font(.callout).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Switch") { windows.selection = window.id; windows.focus() }
                        .disabled(windows.isDemo)
                        .help("Bring this window to the front")
                }
                .padding(.vertical, Space.xs)
                .tag(window.id)
                .contextMenu {
                    Button("Switch to Window") { windows.selection = window.id; windows.focus() }
                    ForEach(WindowLayout.allCases) { layout in
                        Button(layout.title) { windows.selection = window.id; windows.arrange(layout) }
                    }
                }
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .overlay {
            if windows.filtered.isEmpty {
                ContentUnavailableView(windows.query.isEmpty ? "No Windows Yet" : "No Matching Windows",
                    systemImage: "macwindow.on.rectangle",
                    description: Text(windows.query.isEmpty ? "Allow Accessibility and open an app window, then refresh." : "Try another app name or window title."))
            }
        }
    }

    private var actions: some View {
        HStack(spacing: Space.sm) {
            ForEach(WindowLayout.allCases) { layout in
                Button(layout.title, systemImage: layout.symbol) { windows.arrange(layout) }
            }
            Button("Restore", systemImage: "arrow.uturn.backward") { windows.restore() }
                .disabled(!windows.canRestore)
                .help("Restore the position from before this window's first snap (Option-Command-R)")
            Spacer()
            Text("\(windows.filtered.count) windows").foregroundStyle(.secondary)
        }
        .disabled(windows.selected == nil || windows.isDemo)
    }
}
