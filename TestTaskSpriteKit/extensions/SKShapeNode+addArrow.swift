//
//  SKShapeNode+addArrow.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 24.11.22.
//

import Foundation
import SpriteKit

extension SKShapeNode {
    func addArrow(path: UIBezierPath) -> SKShapeNode {
        let arrow = SKShapeNode(path: path.cgPath, centered: false)
        arrow.position = CGPoint(x: 0, y: 0)
        arrow.lineWidth = 5
        arrow.strokeColor = .random
        arrow.zPosition = 1
        return arrow
    }
}
