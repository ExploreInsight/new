import Foundation
import CoreGraphics

public enum WindowLayout: String, CaseIterable, Identifiable, Sendable {
    case left, right, maximize
    public var id: String { rawValue }
    public var title: String {
        switch self {
        case .left: "Left Half"
        case .right: "Right Half"
        case .maximize: "Maximize"
        }
    }
    public var symbol: String {
        switch self {
        case .left: "rectangle.lefthalf.filled"
        case .right: "rectangle.righthalf.filled"
        case .maximize: "arrow.up.left.and.arrow.down.right"
        }
    }
    /// Input and output use Accessibility's global, top-left coordinate space.
    public func frame(in area: CGRect, gap: CGFloat = 8) -> CGRect {
        let g = min(max(0, gap), min(area.width, area.height) / 4)
        let inner = area.insetBy(dx: g, dy: g)
        switch self {
        case .maximize: return inner
        case .left: return CGRect(x: inner.minX, y: inner.minY,
                                 width: (inner.width - g) / 2, height: inner.height)
        case .right: return CGRect(x: inner.midX + g / 2, y: inner.minY,
                                  width: (inner.width - g) / 2, height: inner.height)
        }
    }
}

public enum WindowGeometry {
    /// AppKit and Accessibility share x, but flip y around the primary display's top.
    public static func flip(_ frame: CGRect, primaryHeight: CGFloat) -> CGRect {
        CGRect(x: frame.minX, y: primaryHeight - frame.maxY,
               width: frame.width, height: frame.height)
    }
    /// Prefer the display containing most of the window; allow negative display origins.
    public static func screenIndex(for frame: CGRect, screens: [CGRect]) -> Int? {
        screens.indices.max { a, b in
            area(frame.intersection(screens[a])) < area(frame.intersection(screens[b]))
        }
    }
    private static func area(_ rect: CGRect) -> CGFloat {
        rect.isNull ? 0 : rect.width * rect.height
    }
}
