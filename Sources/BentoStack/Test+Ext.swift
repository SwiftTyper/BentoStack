//
//  File.swift
//  BentoStack
//
//  Created by Wit Owczarek on 18/04/2025.
//

import Foundation
import SwiftUI

public protocol Subviews: RandomAccessCollection where Element: Subview, Index == Int {}

public protocol Subview {
    func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize
    func place(at position: CGPoint, anchor: UnitPoint, proposal: ProposedViewSize)
}

extension LayoutSubviews: Subviews {}
extension LayoutSubview: Subview {}
