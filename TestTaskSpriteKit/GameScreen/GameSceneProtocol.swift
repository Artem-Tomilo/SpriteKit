//
//  GameSceneProtocol.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 18.11.22.
//

import Foundation
import SpriteKit

protocol GameSceneProtocol: AnyObject {
    func addArrow() -> SKShapeNode
    var isDataReceived: Bool { get set }
    var isNeededRemove: Bool { get set }
    var shapeNode: SKShapeNode { get set }
}
