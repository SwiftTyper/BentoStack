//
//  BentoPacker.swift
//  BentoLayout
//
//  Created by Wit Owczarek on 24/01/2025.
//

import Foundation
import SwiftUI

internal struct BentoCalculator {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
  
    init(
        horizontalSpacing: CGFloat,
        verticalSpacing: CGFloat
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
    
    func packAll(_ subviews: some Subviews, in size: CGSize) -> [CGRect] {
        let rects = subviews.map { subview in
            let size = subview.sizeThatFits(.unspecified)
            return CGRect(
                x: 0,
                y: 0,
                width: size.width + horizontalSpacing,
                height: size.height + verticalSpacing
            )
        }
        
        let layout = compute(rects, in: size)
        return removeExtraSpacing(layout)
    }

    private func pack(_ rect: CGRect, spaces: inout [CGRect]) -> CGRect? {
        var rect = rect
        guard let bestSpace = findBestSpace(for: rect, in: spaces) else { return nil }
        
        rect.origin = bestSpace.origin
        updateSpaces(&spaces, with: rect)
        
        return rect
    }
    
    private func compute(_ layout: [CGRect], in size: CGSize) -> [CGRect]{
        var spaces = [CGRect(
            origin: .zero,
            size: CGSize(width: size.width+horizontalSpacing, height: .infinity)
        )]
        
        var computed: [CGRect] = []
        for item in layout {
            guard let placedRect = pack(item, spaces: &spaces) else { continue }
            computed.append(placedRect)
        }
        return computed
    }
    
    private func findBestSpace(for rect: CGRect, in spaces: [CGRect]) -> CGRect? {
        let sortedSpaces = spaces.sorted { first, second in
            if first.minY == second.minY {
                return first.minX < second.minX
            }
            return first.minY < second.minY
        }
        
        return sortedSpaces.first { space in
            rect.canFit(in: space)
        }
    }

    private func updateSpaces(_ spaces: inout [CGRect], with rect: CGRect) {
        var newSpaces: [CGRect] = []
        for space in spaces {
            newSpaces+=rect.getFreeSpaces(in: space)
        }
        spaces = mergeSpaces(newSpaces)
    }
    
    private func mergeSpaces(_ spaces: [CGRect]) -> [CGRect] {
        var result = spaces
        var i = 0
        while i < result.count {
            var j = i + 1
            while j < result.count {
                if result[i].contains(result[j]) {
                    result.remove(at: j)
                } else if result[j].contains(result[i]) {
                    result.remove(at: i)
                    i -= 1
                    break
                } else {
                    j += 1
                }
            }
            i += 1
        }
        return result
    }
    
    //MARK: Spacing
    
    private func removeExtraSpacing(_ layout: [CGRect]) -> [CGRect] {
        var rects = layout
        let trailingSkylineRects = findTrailingSkylineRectangles(rects)
        let extremeTrailingRects = findMostTrailingRectangles(trailingSkylineRects)

        for rect in extremeTrailingRects {
            guard let index = rects.firstIndex(where: { $0 == rect }) else { continue }
            var size = rects[index].size
            size.width -= horizontalSpacing
            rects[index] = CGRect(origin: rects[index].origin, size: size)
        }

        let bottomSkylineRects = findBottomSkylineRectangles(rects)
        let extremeBottomRects = findMostBottomRectangles(bottomSkylineRects)

        for rect in extremeBottomRects {
            guard let index = rects.firstIndex(where: { $0 == rect }) else { continue }
            var size = rects[index].size
            size.height -= verticalSpacing
            rects[index] = CGRect(origin: rects[index].origin, size: size)
        }
        
        return rects
    }
    
    private func findBottomSkylineRectangles(_ rects: [CGRect]) -> [CGRect] {
        guard !rects.isEmpty else { return [] }
        
        return rects.filter { rect in
            let downwardRects = rects.filter { otherRect in
                guard otherRect != rect else { return false }
                return otherRect.minY >= rect.minY + rect.height
            }
            
            if downwardRects.isEmpty {
                return true
            }
            
            let rectLeft = rect.minX
            let rectRight = rect.minX + rect.width
            var currentX = rectLeft
            let sortedDownward = downwardRects.sorted(by: { $0.minX < $1.minX })
            
            var i = 0
            while currentX < rectRight && i < sortedDownward.count {
                let downRect = sortedDownward[i]
                if downRect.minX > currentX {
                    return true
                }
                currentX = max(currentX, downRect.minX + downRect.width)
                i += 1
            }
            return currentX < rectRight
        }
    }
    
    private func findTrailingSkylineRectangles(_ rects: [CGRect]) -> [CGRect] {
        guard !rects.isEmpty else { return [] }
        
        return rects.filter { rect in
            let rightwardRects = rects.filter { otherRect in
                guard otherRect != rect else { return false }
                return otherRect.minX >= rect.minX + rect.width
            }
            
            if rightwardRects.isEmpty {
                return true
            }
            
            let rectTop = rect.minY
            let rectBottom = rect.minY + rect.height
            var currentY = rectTop
            let sortedRightward = rightwardRects.sorted(by: { $0.minY < $1.minY })
            
            var i = 0
            while currentY < rectBottom && i < sortedRightward.count {
                let rightRect = sortedRightward[i]
                if rightRect.minY > currentY {
                    return true
                }
                currentY = max(currentY, rightRect.minY + rightRect.height)
                i += 1
            }
            return currentY < rectBottom
        }
    }
  
    private func findMostTrailingRectangles(_ rects: [CGRect]) -> [CGRect] {
        guard !rects.isEmpty else { return [] }
        
        return rects.filter { rect in
            let rightwardRects = rects.filter { otherRect in
                guard otherRect != rect else { return false }
                return otherRect.minX >= rect.minX + rect.width
            }
            
            if rightwardRects.isEmpty {
                return true
            } else {
                return false
            }
        }
    }
    
    private func findMostBottomRectangles(_ rects: [CGRect]) -> [CGRect] {
        guard !rects.isEmpty else { return [] }
        
        return rects.filter { rect in
            let downwardRects = rects.filter { otherRect in
                guard otherRect != rect else { return false }
                return otherRect.minY >= rect.minY + rect.height
            }
            
            if downwardRects.isEmpty {
                return true
            } else {
                return false
            }
        }
    }
}
