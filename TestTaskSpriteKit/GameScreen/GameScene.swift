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
    private var paperNode = SKSpriteNode()
    private var selectedNode: SKNode?
    private var isCanBeEdited = false
    
    //MARK: - scene methods
    
    override func didMove(to view: SKView) {
        guard let background = self.childNode(withName: "back"),
              let paperNode = background.childNode(withName: "paper") as? SKSpriteNode,
              let view = self.view else { return }
        self.background = background
        self.background.name = "back"
        self.paperNode = paperNode
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGestureAction(_:)))
        view.addGestureRecognizer(longGesture)
        longGesture.delegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameSceneDelegate?.isDataReceived == true {
            if let arrow = gameSceneDelegate?.addArrow() {
                paperNode.addChild(arrow)
            }
        }
    }
    
    //MARK: - private methods
    
    private func boundLayerPosition(newPosition: CGPoint) -> CGPoint {
        let sceneSize = self.size
        var returnValue = newPosition
        returnValue.x = CGFloat(min(returnValue.x, 50))
        returnValue.x = CGFloat(max(returnValue.x, -(paperNode.size.width) + sceneSize.width))
        returnValue.y = CGFloat(min(0, returnValue.y))
        returnValue.y = CGFloat(max(-(paperNode.size.height) + sceneSize.height, returnValue.y))
        
        return returnValue
    }
    
    private func panForTranslation(translation: CGPoint) {
        let backgroundPosition = background.position
        let selectedNodePosition = selectedNode?.position
        
        if selectedNode?.name != "paper" && isCanBeEdited == true {
            selectedNode?.position = CGPoint(x: selectedNodePosition!.x + translation.x, y: selectedNodePosition!.y + translation.y)
        } else {
            let newPosition = CGPoint(x: backgroundPosition.x + translation.x, y: backgroundPosition.y + translation.y)
            background.position = boundLayerPosition(newPosition: newPosition)
        }
    }
    
    //MARK: - actions
    
    @objc func panGestureAction(_ recognizer : UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            selectedNode = self.atPoint(touchLocation)
        case .changed:
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            panForTranslation(translation: translation)
            recognizer.setTranslation(CGPointZero, in: recognizer.view)
        case .ended:
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
            isCanBeEdited = false
        default:
            break
        }
    }
    
    @objc func longGestureAction(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            if let _ = selectedNode as? SKShapeNode {
                isCanBeEdited = true
            }
        }
    }
}

extension GameScene: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
