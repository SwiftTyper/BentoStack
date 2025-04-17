//
//  File.swift
//  BentoStack
//
//  Created by Wit Owczarek on 17/04/2025.
//

import SwiftUI
import Foundation

internal extension CGRect {
    func contains(_ rect: CGRect) -> Bool {
        minX <= rect.minX &&
        minY <= rect.minY &&
        minX + width >= rect.minX + rect.width &&
        minY + height >= rect.minY + rect.height
    }
    
    func canFit(in space: CGRect) -> Bool {
        return space.width >= self.width && space.height >= self.height
    }
    
    func getFreeSpaces(in space: CGRect) -> [CGRect] {
        var freeSpaces: [CGRect] = []
        if space.intersects(self) {
            if space.minY < self.minY {
                let newSpace = CGRect(
                    x: space.minX,
                    y: space.minY,
                    width: space.width,
                    height: self.minY - space.minY
                )
                freeSpaces.append(newSpace)
            }
            
            if space.minX + space.width > self.minX + self.width {
                let newSpace = CGRect(
                    x: self.minX + self.width,
                    y: space.minY,
                    width: space.minX + space.width - (self.minX + self.width),
                    height: space.height
                )
                freeSpaces.append(newSpace)
            }
            
            if space.minY + space.height > self.minY + self.height {
                let newSpace = CGRect(
                    x: space.minX,
                    y: self.minY + self.height,
                    width: space.width,
                    height: space.minY + space.height - (self.minY + self.height)
                )
                freeSpaces.append(newSpace)
            }
            
            if space.minX < self.minX {
                let newSpace = CGRect(
                    x: space.minX,
                    y: space.minY,
                    width: self.minX - space.minX,
                    height: space.height
                )
                freeSpaces.append(newSpace)
            }
        } else {
            freeSpaces.append(space)
        }
        return freeSpaces
    }
}
