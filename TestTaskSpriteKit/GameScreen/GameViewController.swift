//
//  GameViewController.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 13.11.22.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreData

class GameViewController: UIViewController {
    
    //MARK: - property
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet var tableViewShowConstraints: [NSLayoutConstraint] = []
    @IBOutlet var tableViewHideConstraints: [NSLayoutConstraint] = []
    
    private var vectorsArray = [Vector]()
    private var isTableViewShow: Bool = false
    var isDataReceived: Bool = false
    private var startX = 0, startY = 0, endX = 0, endY = 0
    private var moc: NSManagedObjectContext?
    static let cellIdentifier = "cell"
    
    //MARK: - vc lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
                vectorsArray = (try? moc?.fetch(Vector.fetchRequest())) ?? []
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
    
    private func createVector(shapeNode: SKShapeNode) -> Vector? {
        if let moc = moc {
            let vector = Vector(context: moc)
            vector.startPointX = Float(startX)
            vector.startPointY = Float(startY)
            vector.endPointX = Float(endX)
            vector.endPointY = Float(endY)
            vector.lenght = calculateVectorLength(vector: vector)
            vector.node = shapeNode
            vector.name = String(vectorsArray.count)
            
            return vector
        }
        return nil
    }
    
    private func calculateVectorLength(vector: Vector) -> Double {
        let coordinateX = Double(vector.endPointX - vector.startPointX)
        let coordinateY = Double(vector.endPointY - vector.startPointY)
        let lenghtVector = sqrt(coordinateX * coordinateX + coordinateY * coordinateY)
        return lenghtVector
    }
    
    private func getVector(_ indexPath: IndexPath) -> Vector? {
        if vectorsArray.count > indexPath.row {
            return vectorsArray[indexPath.row]
        }
        return nil
    }
    
    private func highlightVector(indexPath: IndexPath) {
        let arrow = getVector(indexPath)?.node as? SKShapeNode
        arrow?.lineWidth = 7
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            arrow?.lineWidth = 5
            self.tableView?.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func showDeleteVectorAlert(indexPath: IndexPath, vector: Vector) {
        let alert = UIAlertController(title: "Хотите удалить данный вектор?", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.deleteVector(vector: vector)
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
    
    private func deleteVector(vector: Vector) {
        if let shapeNode = vector.node as? SKShapeNode {
            shapeNode.removeFromParent()
        }
        self.vectorsArray.removeAll(where: { $0 == vector })
        self.moc?.delete(vector)
        try? self.moc?.save()
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
    
    func addArrow(path: UIBezierPath?) -> SKShapeNode {
        var arrow = SKShapeNode()
        if let path = path {
            arrow = SKShapeNode().addArrow(path: path)
        } else {
            let newPath = createPathForVector()
            arrow = SKShapeNode().addArrow(path: newPath)
            if let vector = createVector(shapeNode: arrow) {
                arrow.name = vector.name
                vectorsArray.append(vector)
                try? moc?.save()
            }
        }
        
        tableView?.reloadData()
        isDataReceived = false
        return arrow
    }
    
    func displayAllVectors(node: SKNode) {
        for i in vectorsArray {
            if let shapeNode = i.node as? SKShapeNode {
                node.addChild(shapeNode)
            }
        }
    }
    
    func updateVector(node: SKShapeNode) {
        for i in vectorsArray {
            if node == i.node as? SKShapeNode,
               let index = self.vectorsArray.firstIndex(of: i)  {
                self.moc?.delete(i)
                startX = Int(Float(node.frame.minX))
                startY = Int(node.frame.minY)
                endX = Int(node.frame.maxX)
                endY = Int(node.frame.maxY)
                
                if let newVector = createVector(shapeNode: node) {
                    self.vectorsArray.removeAll(where: { $0.node == node })
                    self.vectorsArray.insert(newVector, at: index)
                    try? self.moc?.save()
                    tableView?.reloadData()
                }
            }
        }
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
            if let vector = self.getVector(indexPath) {
                self.showDeleteVectorAlert(indexPath: indexPath, vector: vector)
            }
        }
        return UISwipeActionsConfiguration(actions: [
            deleteCell
        ])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        highlightVector(indexPath: indexPath)
    }
}
