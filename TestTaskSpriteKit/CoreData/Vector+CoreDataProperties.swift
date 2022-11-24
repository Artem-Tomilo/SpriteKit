//
//  Vector+CoreDataProperties.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 24.11.22.
//

import Foundation
import CoreData


extension Vector {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vector> {
        return NSFetchRequest<Vector>(entityName: "Vector")
    }
    
    @NSManaged public var startPointX: Float
    @NSManaged public var startPointY: Float
    @NSManaged public var endPointX: Float
    @NSManaged public var endPointY: Float
    @NSManaged public var lenght: Double
    @NSManaged public var name: String
    @NSManaged public var node: NSObject?
    
}

extension Vector : Identifiable {
    
}
