import AppKit
import ApplicationServices
import SnapperKit

struct ManagedWindow: Identifiable {
    let id: UUID
    let pid: pid_t
    let appName: String
    let title: String
    let frame: CGRect
    let element: AXUIElement?
    let icon: NSImage?
}

/// All Accessibility calls stay on the main actor and have a bounded timeout.
enum WindowAccess {
    static func attribute(_ element: AXUIElement, _ key: String) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, key as CFString, &value) == .success else { return nil }
        return value
    }

    static func frame(_ element: AXUIElement) -> CGRect? {
        guard let p = attribute(element, kAXPositionAttribute),
              let s = attribute(element, kAXSizeAttribute),
              CFGetTypeID(p) == AXValueGetTypeID(), CFGetTypeID(s) == AXValueGetTypeID() else { return nil }
        var point = CGPoint.zero
        var size = CGSize.zero
        guard AXValueGetValue(p as! AXValue, .cgPoint, &point),
              AXValueGetValue(s as! AXValue, .cgSize, &size) else { return nil }
        return CGRect(origin: point, size: size)
    }

    static func windows(previous: [ManagedWindow]) -> [ManagedWindow] {
        var result: [ManagedWindow] = []
        for app in NSWorkspace.shared.runningApplications where app.activationPolicy == .regular && app.processIdentifier != getpid() {
            let application = AXUIElementCreateApplication(app.processIdentifier)
            AXUIElementSetMessagingTimeout(application, 0.2)
            guard let windows = attribute(application, kAXWindowsAttribute) as? [AXUIElement] else { continue }
            for element in windows {
                guard attribute(element, kAXRoleAttribute) as? String == kAXWindowRole,
                      attribute(element, kAXSubroleAttribute) as? String == kAXStandardWindowSubrole,
                      attribute(element, kAXMinimizedAttribute) as? Bool != true,
                      let frame = frame(element), frame.width >= 60, frame.height >= 60 else { continue }
                let old = previous.first { $0.element.map { CFEqual($0, element) } == true }
                result.append(ManagedWindow(id: old?.id ?? UUID(), pid: app.processIdentifier,
                    appName: app.localizedName ?? "Application",
                    title: (attribute(element, kAXTitleAttribute) as? String).flatMap { $0.isEmpty ? nil : $0 } ?? "Untitled Window",
                    frame: frame, element: element, icon: app.icon))
            }
        }
        return result.sorted { ($0.appName, $0.title) < ($1.appName, $1.title) }
    }

    static func focus(_ window: ManagedWindow) -> Bool {
        guard let element = window.element,
              let app = NSRunningApplication(processIdentifier: window.pid) else { return false }
        app.activate()
        AXUIElementSetAttributeValue(element, kAXMainAttribute as CFString, kCFBooleanTrue)
        AXUIElementSetAttributeValue(element, kAXFocusedAttribute as CFString, kCFBooleanTrue)
        return AXUIElementPerformAction(element, kAXRaiseAction as CFString) == .success
    }

    static func move(_ window: ManagedWindow, to rect: CGRect) -> Bool {
        guard let element = window.element else { return false }
        var positionSettable: DarwinBoolean = false
        var sizeSettable: DarwinBoolean = false
        guard AXUIElementIsAttributeSettable(element, kAXPositionAttribute as CFString, &positionSettable) == .success,
              AXUIElementIsAttributeSettable(element, kAXSizeAttribute as CFString, &sizeSettable) == .success,
              positionSettable.boolValue, sizeSettable.boolValue,
              attribute(element, "AXFullScreen") as? Bool != true else { return false }
        var point = rect.origin
        var size = rect.size
        guard let p = AXValueCreate(.cgPoint, &point), let s = AXValueCreate(.cgSize, &size) else { return false }
        // Shrink before moving so the old display does not clamp the target position.
        let firstSize = AXUIElementSetAttributeValue(element, kAXSizeAttribute as CFString, s)
        let position = AXUIElementSetAttributeValue(element, kAXPositionAttribute as CFString, p)
        let finalSize = AXUIElementSetAttributeValue(element, kAXSizeAttribute as CFString, s)
        return firstSize == .success && position == .success && finalSize == .success
    }
}
