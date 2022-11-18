//
//  VectorAddViewControllerDelegate.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 16.11.22.
//

import Foundation

protocol VectorAddViewControllerDelegate: AnyObject {
    func parametersBind(startX: Int, startY: Int, endX: Int, endY: Int)
}
