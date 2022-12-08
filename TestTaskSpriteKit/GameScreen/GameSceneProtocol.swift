//
//  GameSceneProtocol.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 18.11.22.
//

import Foundation
import SpriteKit

protocol GameSceneProtocol: AnyObject {
    func addArrow(path: UIBezierPath?) -> SKShapeNode
    func displayAllVectors(node: SKNode)
    func updateVector(node: SKShapeNode)
    var isDataReceived: Bool { get set }
}
