//
//  GameScene.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 13.11.22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - property
    
    weak var gameSceneDelegate: GameSceneProtocol?
    
    private var background = SKNode()
    private var paper = SKSpriteNode()
    
    //MARK: - scene methods
    
    override func didMove(to view: SKView) {
        guard let background = self.childNode(withName: "back"),
              let paper = background.childNode(withName: "paper") as? SKSpriteNode,
              let view = self.view else { return }
        self.background = background
        self.background.name = "back"
        self.paper = paper
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameSceneDelegate?.isDataReceived == true {
            if let arrow = gameSceneDelegate?.addArrow(){
                paper.addChild(arrow)
            }
        }
    }
    
    //MARK: - private methods
    
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
    
    //MARK: - actions
    
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
}

extension GameScene: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
