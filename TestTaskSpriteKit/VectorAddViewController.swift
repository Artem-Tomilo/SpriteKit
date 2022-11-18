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
    
    private var sendDataButton: UIBarButtonItem?
    
    weak var delegate: VectorAddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .black
        title = "Создание вектора"
        
        sendDataButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction(_:)))
        navigationItem.rightBarButtonItem = sendDataButton
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        parametersValidate()
    }
    
    private func parametersValidate() {
        if let startX = Int(startXTextField.text ?? ""),
           let startY = Int(startYTextField.text ?? ""),
           let endX = Int(endXTextField.text ?? ""),
           let endY = Int(endYTextField.text ?? "") {
            delegate?.parametersBind(startX: startX, startY: startY, endX: endX, endY: endY)
        }
    }
    
}

extension VectorAddViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.allSatisfy {
            $0.isNumber
        }
    }
}
