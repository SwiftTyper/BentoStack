//
//  File.swift
//  BentoStack
//
//  Created by Wit Owczarek on 18/04/2025.
//

import Testing
import SwiftUI
import Foundation
@testable import BentoStack

public class TestSubview: BentoStack.Subview {
    var placement: CGRect?
    var size: CGSize

    init(size: CGSize) {
        self.size = size
    }

    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        size
    }
  
    public func place(at position: CGPoint, anchor: UnitPoint, proposal: ProposedViewSize) {
        let size = sizeThatFits(proposal)
        placement = CGRect(origin: position, size: size)
    }
}

extension [TestSubview]: BentoStack.Subviews {}
