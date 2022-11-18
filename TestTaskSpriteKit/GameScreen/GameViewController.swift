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
    
    //MARK: - property
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet var tableViewShowConstraints: [NSLayoutConstraint] = []
    @IBOutlet var tableViewHideConstraints: [NSLayoutConstraint] = []
    
    private var vectorsArray = [Vector]()
    
    var isDataReceived: Bool = false
    private var istableViewShow: Bool = false
    
    private var startX, startY, endX, endY: Int?
    static let cellIdentifier = "cell"
    
    //MARK: - vc lifecycle
    
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
        tableView?.register(CustomCell.self, forCellReuseIdentifier: GameViewController.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView?.reloadData()
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
    
    //MARK: - private methods
    
    private func navigationBarSettings() {
        navigationController?.navigationBar.tintColor = .black
        let transitionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(transitionToAddVectorScreen(_:)))
        let showTableViewButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showAndHideTableView(_:)))
        navigationItem.rightBarButtonItem = transitionButton
        navigationItem.leftBarButtonItem = showTableViewButton
    }
    
    private func createVector(startPoint: CGPoint, endPoint: CGPoint) {
        let vector = Vector(startPoint: startPoint, endPoint: endPoint)
        vectorsArray.append(vector)
    }
    
    //MARK: - actions
    
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

//MARK: - vectorAddViewControllerDelegate

extension GameViewController: VectorAddViewControllerDelegate {
    func parametersBind(startX: Int, startY: Int, endX: Int, endY: Int) {
        self.startX = startX
        self.startY = startY
        self.endX = endX
        self.endY = endY
        
        createVector(startPoint: CGPoint(x: startX, y: startY), endPoint: CGPoint(x: endX, y: endY))
        isDataReceived = true
    }
}

//MARK: - gameSceneProtocol

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

//MARK: - tableView

extension GameViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vectorsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameViewController.cellIdentifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
        cell.bindText(vector: vectorsArray[indexPath.row])
        
        return cell
    }
}
