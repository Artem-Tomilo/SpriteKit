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
    private var isTableViewShow: Bool = false
    var isDataReceived: Bool = false
    private var startX = 0, startY = 0, endX = 0, endY = 0
    private var nodeName = 0
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
    
    private func createPathForVector() -> UIBezierPath {
        let arrowPath = UIBezierPath()
        arrowPath.addArrow(start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
        return arrowPath
    }
    
    private func createVector(shapeNode: SKShapeNode) {
        let vector = Vector(startPoint: CGPoint(x: startX, y: startY), endPoint: CGPoint(x: endX, y: endY), node: shapeNode, lenght: calculateVectorLength())
        vectorsArray.append(vector)
        tableView?.reloadData()
    }
    
    private func calculateVectorLength() -> Double {
        let coordinateX = Double(endX - startX)
        let coordinateY = Double(endY - startY)
        let lenghtVector = sqrt(coordinateX * coordinateX + coordinateY * coordinateY)
        return lenghtVector
    }
    
    //MARK: - actions
    
    @objc func showAndHideTableView(_ sender: UIBarButtonItem) {
        if !isTableViewShow {
            NSLayoutConstraint.deactivate(tableViewHideConstraints)
            NSLayoutConstraint.activate(tableViewShowConstraints)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            isTableViewShow = true
        } else {
            NSLayoutConstraint.deactivate(tableViewShowConstraints)
            NSLayoutConstraint.activate(tableViewHideConstraints)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            isTableViewShow = false
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
        
        isDataReceived = true
    }
}

//MARK: - gameSceneProtocol

extension GameViewController: GameSceneProtocol {
    
    func addArrow() -> SKShapeNode {
        let arrow = SKShapeNode(path: createPathForVector().cgPath, centered: false)
        arrow.position = CGPoint(x: 0, y: 0)
        arrow.lineWidth = 5
        arrow.strokeColor = .random
        arrow.zPosition = 1
        arrow.name = String(nodeName)
        createVector(shapeNode: arrow)
        nodeName += 1
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, close in
            guard let self = self else { return }
            if let shapeNode = self.getShapeNode(indexPath) {
                self.deleteVector(indexPath: indexPath, shapeNode: shapeNode)
            }
        }
        return UISwipeActionsConfiguration(actions: [
            deleteCell
        ])
    }
    
    private func deleteVector(indexPath: IndexPath, shapeNode: SKShapeNode) {
        let alert = UIAlertController(title: "Хотите удалить данный вектор?", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.vectorsArray.removeAll(where: { $0.node == shapeNode })
            shapeNode.removeFromParent()
            self.tableView?.performBatchUpdates {
                self.tableView?.deleteRows(at: [indexPath], with: .automatic)
            } completion: { _ in
                self.tableView?.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func getShapeNode(_ indexPath: IndexPath) -> SKShapeNode? {
        if vectorsArray.count > indexPath.row {
            return vectorsArray[indexPath.row].node
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        highlightVector(indexPath: indexPath)
    }
    
    private func highlightVector(indexPath: IndexPath) {
        let arrow = getShapeNode(indexPath)
        arrow?.lineWidth = 7
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            arrow?.lineWidth = 5
        }
    }
}
