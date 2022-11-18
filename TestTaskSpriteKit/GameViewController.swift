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
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet var tableViewShowConstraints: [NSLayoutConstraint] = []
    @IBOutlet var tableViewHideConstraints: [NSLayoutConstraint] = []
    
    var isDataReceived: Bool = false
    private var istableViewShow: Bool = false
    
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
        
        navigationBarSettings()
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
    
    private func navigationBarSettings() {
        navigationController?.navigationBar.tintColor = .black
        let transitionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(transitionToAddVectorScreen(_:)))
        let showTableViewButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showAndHideTableView(_:)))
        navigationItem.rightBarButtonItem = transitionButton
        navigationItem.leftBarButtonItem = showTableViewButton
    }
    
    @objc func showAndHideTableView(_ sender: UIBarButtonItem) {
        if !istableViewShow {
            NSLayoutConstraint.deactivate(tableViewHideConstraints)
            NSLayoutConstraint.activate(tableViewShowConstraints)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            istableViewShow = true
        } else {
            NSLayoutConstraint.deactivate(tableViewShowConstraints)
            NSLayoutConstraint.activate(tableViewHideConstraints)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            istableViewShow = false
        }
    }
    
    @objc func transitionToAddVectorScreen(_ sender: UIBarButtonItem) {
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
