//
//  CustomCell.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 19.11.22.
//

import UIKit

class CustomCell: UITableViewCell {
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: widthAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor, constant: -5)
        ])
        
        label.backgroundColor = .systemCyan
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        backgroundColor = .clear
    }
    
    func bindText(vector: Vector) {
        label.text = """
                      A (\(Int(vector.startPoint.x)); \(Int(vector.startPoint.y)))
                      B (\(Int(vector.endPoint.x)); \(Int(vector.endPoint.y)))
                      Lenght = 400
                    """
    }
}
