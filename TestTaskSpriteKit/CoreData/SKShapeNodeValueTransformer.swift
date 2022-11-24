//
//  SKShapeNodeValueTransformer.swift
//  TestTaskSpriteKit
//
//  Created by Артем Томило on 24.11.22.
//

import Foundation
import SpriteKit

@objc(SKShapeNodeValueTransformer)
public final class SKShapeNodeValueTransformer: ValueTransformer {
    
    override public class func transformedValueClass() -> AnyClass {
        return SKShapeNode.self
    }
    
    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let shapeNode = value as? SKShapeNode else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: shapeNode, requiringSecureCoding: true)
            return data
        } catch {
            assertionFailure("Failed to transform `SKShapeNode` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            let shapeNode = try NSKeyedUnarchiver.unarchivedObject(ofClass: SKShapeNode.self, from: data as Data)
            return shapeNode
        } catch {
            assertionFailure("Failed to transform `Data` to `SKShapeNode`")
            return nil
        }
    }
}

extension SKShapeNodeValueTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: SKShapeNodeValueTransformer.self))
    
    public static func register() {
        let transformer = SKShapeNodeValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
