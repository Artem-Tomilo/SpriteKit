//
//  GameViewController.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 13.11.22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var isDataReceived: Bool = false
    
    private var startX, startY, endX, endY: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.scaleMode = .aspectFill
                scene.gameSceneDelegate = self
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        createTransitionButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func createTransitionButton() {
        let transitionButton = UIButton()
        transitionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(transitionButton)
        
        NSLayoutConstraint.activate([
            transitionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            transitionButton.widthAnchor.constraint(equalToConstant: 40),
            transitionButton.heightAnchor.constraint(equalToConstant: 40),
            transitionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        transitionButton.backgroundColor = .black
        transitionButton.layer.cornerRadius = 20
        transitionButton.setTitle("+", for: .normal)
        transitionButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        transitionButton.setTitleColor(.white, for: .normal)
        transitionButton.titleLabel?.textAlignment = .center
        transitionButton.addTarget(self, action: #selector(transitionToAddVectorScreen(_ :)), for: .primaryActionTriggered)
    }
    
    @objc func transitionToAddVectorScreen(_ sender: UIButton) {
        let vectorViewController = storyboard?.instantiateViewController(withIdentifier: "VectorAddViewController") as! VectorAddViewController
        navigationController?.pushViewController(vectorViewController, animated: true)
        vectorViewController.delegate = self
    }
}

extension GameViewController: VectorAddViewControllerDelegate {
    func parametersBind(startX: Int, startY: Int, endX: Int, endY: Int) {
        self.startX = startX
        self.startY = startY
        self.endX = endX
        self.endY = endY
        
        isDataReceived = true
    }
}

extension GameViewController: GameSceneProtocol {
    
    func addArrow() -> SKShapeNode {
        let arrowPath = UIBezierPath()
        arrowPath.addArrow(start: CGPoint(x: startX ?? 0, y: startY ?? 0), end: CGPoint(x: endX ?? 0, y: endY ?? 0))
        
        let arrow = SKShapeNode(path: arrowPath.cgPath, centered: false)
        arrow.position = CGPoint(x: 0, y: 0)
        arrow.lineWidth = 5
        arrow.strokeColor = .random
        arrow.zPosition = 1
        
        isDataReceived = false
        return arrow
    }
}
