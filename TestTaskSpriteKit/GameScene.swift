//
//  GameScene.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 13.11.22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var background = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        background = self.childNode(withName: "back") as! SKSpriteNode
        background.name = "back"
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom(_:)))
        self.view?.addGestureRecognizer(gestureRecognizer)
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
        let winSize = self.size
        var retval = newPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = CGFloat(min(0, retval.y))
        retval.y = CGFloat(max(-(background.size.height) + winSize.height, retval.y))
        
        return retval
    }
    
    private func panForTranslation(translation: CGPoint) {
        let position = background.position
        let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        background.position = boundLayerPosition(newPosition: aNewPosition)
    }
}
