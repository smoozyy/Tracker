//
//  DaysValueTransformable.swift
//  Tracker
//
//  Created by Антон on 06.10.2026.
//

import Foundation
@objc
final class DaysValueTransformer: ValueTransformer {
    
    //MARK: - Override Class Methods
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    //MARK: - Override Methods
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDay] else {return nil}
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else {return nil}
        return try? JSONDecoder().decode([WeekDay].self, from: data as Data)
    }
    
    //MARK: - Register
    static func register() {
        ValueTransformer.setValueTransformer(DaysValueTransformer(), forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self)))
    }
        
}
