//
//  BentoLayout.swift
//  BentoLayout
//
//  Created by Wit Owczarek on 24/01/2025.
//

import SwiftUI
import Foundation

public struct BentoStack: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    
    public init(
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        guard proposal.width != 0 && proposal.height != 0 else { return .zero }
        
        let packer = BentoCalculator(
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        )
        
        let placedRects = packer.packAll(subviews, in: proposal.replacingUnspecifiedDimensions())
        
        let maxX = placedRects.map { $0.maxX }.max() ?? 0
        let maxY = placedRects.map { $0.maxY }.max() ?? 0
        
        return CGSize(width: maxX, height: maxY)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        guard proposal.width != 0 && proposal.height != 0 else { return }
        
        let packer = BentoCalculator(
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        )
        
        let placedRects = packer.packAll(subviews, in: proposal.replacingUnspecifiedDimensions())
        
        for (subview, placedRect) in zip(subviews, placedRects) {
            subview.place(
                at: CGPoint(
                    x: bounds.minX + placedRect.minX,
                    y: bounds.minY + placedRect.minY
                ),
                anchor: .topLeading,
                proposal: .unspecified
            )
        }
    }
}
