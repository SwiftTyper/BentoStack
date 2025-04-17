import Testing
import SwiftUI
import Foundation
@testable import BentoStack

@MainActor
@Test("Subviews shouldn't overlap")
func testLayoutSubviewsOverlap() throws {
    for _ in 0..<100 {
        let bentoStack = BStack()
        let proposal = ProposedViewSize(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height
        )
        let subviews = createSubviews()
        var cache: () = {}()
        let size = bentoStack.sizeThatFits(proposal: proposal, subviews: subviews, cache: &cache)
        
        bentoStack.placeSubviews(
            in: CGRect(origin: .zero, size: size),
            proposal: proposal,
            subviews: subviews,
            cache: &cache
        )
        
        let frames = subviews.map { $0.placement ?? .zero }
        let (hasOverlap, overlappingPair) = verifyNoOverlaps(in: frames)
        #expect(!hasOverlap, "Found overlapping views: \(String(describing: overlappingPair))")
    }
}

fileprivate func framesOverlap(_ frame1: CGRect, _ frame2: CGRect) -> Bool {
    frame1.intersects(frame2)
}

fileprivate func verifyNoOverlaps(in frames: [CGRect]) -> (hasOverlap: Bool, overlappingPair: (CGRect, CGRect)?) {
    for i in 0..<frames.count {
        for j in (i + 1)..<frames.count {
            if framesOverlap(frames[i], frames[j]) {
                return (true, (frames[i], frames[j]))
            }
        }
    }
    return (false, nil)
}

fileprivate func createSubviews() -> [TestSubview] {
    var subviews: [TestSubview] = []
    for _ in 0..<100 {
        let size = CGSize(
            width: CGFloat.random(in: 10...500),
            height: CGFloat.random(in: 10...500)
        )
        subviews.append(.init(size: size))
    }
    return subviews
}
