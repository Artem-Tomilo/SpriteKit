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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        createTransitionToAddVectorVCButton()
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
    
    func createTransitionToAddVectorVCButton() {
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
        let vc = VectorAddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
