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
    func displayAllVectors(node: SKNode)
    var isDataReceived: Bool { get set }
}
