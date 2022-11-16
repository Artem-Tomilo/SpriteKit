//
//  GameScene.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 13.11.22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var background = SKNode()
    private var paper = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        guard let background = self.childNode(withName: "back"),
              let paper = background.childNode(withName: "paper") as? SKSpriteNode,
              let view = self.view else { return }
        self.background = background
        self.background.name = "back"
        self.paper = paper
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handlePanFrom(_ recognizer : UIPanGestureRecognizer) {
        
        if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            panForTranslation(translation: translation)
            recognizer.setTranslation(CGPointZero, in: recognizer.view)
            
        } else if recognizer.state == .ended {
            let scrollDuration = 0.2
            let velocity = recognizer.velocity(in: recognizer.view)
            let position = background.position
            
            let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
            
            var newPosition = CGPoint(x: position.x + p.x, y: position.y - p.y)
            newPosition = boundLayerPosition(newPosition: newPosition)
            background.removeAllActions()
            
            let moveTo = SKAction.move(to: newPosition, duration: scrollDuration)
            moveTo.timingMode = .easeOut
            background.run(moveTo)
        }
    }
    
    private func boundLayerPosition(newPosition: CGPoint) -> CGPoint {
        let sceneSize = self.size
        var returnValue = newPosition
        returnValue.x = CGFloat(min(returnValue.x, 50))
        returnValue.x = CGFloat(max(returnValue.x, -(paper.size.width) + sceneSize.width))
        returnValue.y = CGFloat(min(0, returnValue.y))
        returnValue.y = CGFloat(max(-(paper.size.height) + sceneSize.height, returnValue.y))
        
        return returnValue
    }
    
    private func panForTranslation(translation: CGPoint) {
        let position = background.position
        let newPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        background.position = boundLayerPosition(newPosition: newPosition)
    }
    
    private func addArrow(from: CGPoint, to: CGPoint) {
        let arrowPath = UIBezierPath()
        arrowPath.addArrow(start: CGPoint(x: from.x, y: from.y), end: CGPoint(x: to.x, y: to.y))
        
        let arrow = SKShapeNode(path: arrowPath.cgPath, centered: false)
        arrow.position = CGPoint(x: 0, y: 0)
        arrow.lineWidth = 5
        arrow.strokeColor = .random
        arrow.zPosition = 1
        
        background.addChild(arrow)
    }
}
