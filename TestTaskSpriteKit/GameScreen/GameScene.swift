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
    
    private var touchX: CGFloat = 0
    private var touchY: CGFloat = 0
    
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
        
        gameSceneDelegate?.displayAllVectors(node: paperNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameSceneDelegate?.isDataReceived == true {
            if let arrow = gameSceneDelegate?.addArrow(path: nil) {
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
    
    private func panForTranslation(translation: CGPoint, location: CGPoint) {
        let backgroundPosition = background.position
        if selectedNode?.name != "paper" {
            selectedNode?.position = CGPoint(x: location.x - touchX, y: location.y - touchY)
        } else {
            let newPosition = CGPoint(x: backgroundPosition.x + translation.x, y: backgroundPosition.y + translation.y)
            background.position = boundLayerPosition(newPosition: newPosition)
        }
    }
    
    private func updateVector(touchLocation: CGPoint) {
        let path = UIBezierPath()
        
        if let selectedNode = selectedNode as? SKShapeNode,
           let cgPath = selectedNode.path {
            path.cgPath = cgPath
            if path.bounds.minX <= touchLocation.x && path.bounds.minY <= touchLocation.y {
                let newPath = UIBezierPath()
                newPath.addArrow(start: CGPoint(x: (path.bounds.minX), y: (path.bounds.minY)), end: CGPoint(x: touchLocation.x, y: touchLocation.y))
                let arrow = gameSceneDelegate?.addArrow(path: newPath)
                arrow?.strokeColor = selectedNode.strokeColor
                self.selectedNode?.removeFromParent()
                self.selectedNode = arrow
                paperNode.addChild(arrow!)
            }
        }
    }
    
    //MARK: - actions
    
    @objc func panGestureAction(_ recognizer : UIPanGestureRecognizer) {
        var touchLocation = recognizer.location(in: recognizer.view)
        var translation = recognizer.translation(in: recognizer.view)
        
        switch recognizer.state {
        case .began:
            touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            selectedNode = self.atPoint(touchLocation)
            
            if let selectedNode {
                touchX = touchLocation.x - selectedNode.position.x
                touchY = touchLocation.y - selectedNode.position.y
            }
        case .changed:
            if !isCanBeEdited {
                touchLocation = self.convertPoint(fromView: touchLocation)
                translation = CGPoint(x: translation.x, y: -translation.y)
                panForTranslation(translation: translation, location: touchLocation)
                recognizer.setTranslation(CGPointZero, in: recognizer.view)
            }
        case .ended:
            if let selectedNode = self.selectedNode as? SKShapeNode {
                gameSceneDelegate?.updateVector(node: selectedNode)
                print(selectedNode.frame.maxX - selectedNode.frame.midX)
            }
            
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
        default:
            break
        }
    }
    
    @objc func longGestureAction(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            selectedNode = self.atPoint(touchLocation)
            if let _ = selectedNode as? SKShapeNode {
                print("You can edit the node")
                isCanBeEdited = true
            }
        case .changed:
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            updateVector(touchLocation: touchLocation)
        case .ended:
            isCanBeEdited = false
        default:
            break
        }
    }
}

extension GameScene: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
