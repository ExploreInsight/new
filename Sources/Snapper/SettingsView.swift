import SwiftUI

/// The Settings window (Command-Comma). One tab per topic, at most about
/// six. Each tab is a grouped Form that sizes to its content, so the
/// window grows to fit and shows no scroll bar it does not need.
struct SettingsView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        @Bindable var model = model
        TabView(selection: $model.settingsTab) {
            ForEach(SettingsTab.allCases) { tab in
                page(tab)
                    .tabItem { Label(tab.title, systemImage: tab.symbol) }
                    .tag(tab)
            }
        }
        .noInitialFocus()
    }

    @ViewBuilder
    private func page(_ tab: SettingsTab) -> some View {
        Form {
            switch tab {
            case .general: GeneralSettings()
            case .appearance: AppearanceSettings()
            }
        }
        .formStyle(.grouped)
        .fitsContent()
        .frame(width: 520)
    }
}

/// The Settings tabs. Snapshot mode walks through every case.
enum SettingsTab: String, CaseIterable, Identifiable {
    case general, appearance

    var id: String { rawValue }

    var title: String {
        switch self {
        case .general: "General"
        case .appearance: "Appearance"
        }
    }

    var symbol: String {
        switch self {
        case .general: "gearshape"
        case .appearance: "paintpalette"
        }
    }
}

struct GeneralSettings: View {
    @EnvironmentObject private var windows: WindowManager

    var body: some View {
        Section("Permissions") {
            LabeledContent("Accessibility", value: windows.accessibility ? "On" : "Off")
            Text("Required to list, focus, and arrange app windows.").foregroundStyle(.secondary)
            Button("Open Accessibility") { windows.openPermission("Privacy_Accessibility") }
            LabeledContent("Screen Recording", value: windows.screenRecording ? "On" : "Off")
            Text("Optional. Enables window pictures, held only in memory.").foregroundStyle(.secondary)
            Button("Open Screen Recording") { windows.openPermission("Privacy_ScreenCapture") }
        }
        Section("Shortcuts") {
            LabeledContent("Show window overview", value: "⌃⌥Space")
            LabeledContent("Left / right half", value: "⌥⌘← / →")
            LabeledContent("Maximize", value: "⌥⌘Return")
            LabeledContent("Restore", value: "⌥⌘R")
            Text("Snap shortcuts act on the focused app window. In Snapper, they act on the selected window.")
                .foregroundStyle(.secondary)
        }
    }
}
