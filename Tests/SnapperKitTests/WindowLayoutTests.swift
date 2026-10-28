import Foundation
import CoreGraphics
import Testing
@testable import SnapperKit

@Test func halvesRespectDockAndGaps() {
    let area = CGRect(x: 0, y: 25, width: 1440, height: 875)
    let left = WindowLayout.left.frame(in: area)
    let right = WindowLayout.right.frame(in: area)
    #expect(left.minX == 8)
    #expect(left.minY == 33)
    #expect(right.maxX == 1432)
    #expect(right.minX - left.maxX == 8)
    #expect(left.width == right.width)
    #expect(left.maxY == 892)
    #expect(WindowLayout.maximize.frame(in: area, gap: 0) == area)
}

@Test func coordinateConversionRoundTrips() {
    for frame in [CGRect(x: 0, y: 25, width: 1440, height: 875),
                  CGRect(x: -1920, y: -400, width: 1920, height: 1080)] {
        let flipped = WindowGeometry.flip(frame, primaryHeight: 900)
        #expect(WindowGeometry.flip(flipped, primaryHeight: 900) == frame)
    }
}

@Test func selectsDisplayByLargestIntersection() {
    let screens = [CGRect(x: 0, y: 0, width: 1440, height: 900),
                   CGRect(x: -1920, y: 0, width: 1920, height: 1080)]
    #expect(WindowGeometry.screenIndex(for: CGRect(x: -1000, y: 100, width: 1200, height: 600), screens: screens) == 1)
    #expect(WindowGeometry.screenIndex(for: .zero, screens: []) == nil)
}

@Test func gapIsClamped() {
    let area = CGRect(x: 0, y: 0, width: 100, height: 80)
    #expect(WindowLayout.left.frame(in: area, gap: 1000).width > 0)
    #expect(WindowLayout.maximize.frame(in: area, gap: -10) == area)
}
