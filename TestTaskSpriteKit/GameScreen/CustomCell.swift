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
            label.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        label.backgroundColor = .systemCyan
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
    }
    
    func bindText(vector: Vector) {
        let stringLenght = String(format: "%.2f", vector.lenght)
        label.text = """
                      A (\(Int(vector.startPoint.x)); \(Int(vector.startPoint.y)))
                      B (\(Int(vector.endPoint.x)); \(Int(vector.endPoint.y)))
                      Lenght = \(stringLenght)
                    """
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        label.backgroundColor = {
            selected ? .systemYellow :  .systemCyan
        }()
    }
}
