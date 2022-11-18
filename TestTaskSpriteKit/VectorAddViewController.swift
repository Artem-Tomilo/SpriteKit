//
//  VectorAddViewController.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 15.11.22.
//

import Foundation
import UIKit

class VectorAddViewController: UIViewController {
    
    @IBOutlet weak var startXTextField: UITextField!
    @IBOutlet weak var startYTextField: UITextField!
    @IBOutlet weak var endXTextField: UITextField!
    @IBOutlet weak var endYTextField: UITextField!
    
    weak var delegate: VectorAddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .black
        title = "Создание вектора"
    }
    
    @IBAction func ok(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
        delegate?.parametersBind(startX: startXTextField.text ?? "", startY: startYTextField.text ?? "", endX: endXTextField.text ?? "", endY: endYTextField.text ?? "")
        
//        delegate?.addArrow(from: CGPoint(x: Int(startXTextField.text ?? "")!, y: Int(startYTextField.text ?? "")!), to: CGPoint(x: Int(endXTextField.text ?? "")!, y: Int(endYTextField.text ?? "")!))
    }
    
}

extension VectorAddViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.allSatisfy {
            $0.isNumber
        }
    }
}
