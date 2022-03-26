//
//  Guard+Collection.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

public extension Guard where State: Collection {
    
    /// The isEmpty Validation
    static var isEmpty: Self {
        .init("is empty collection") { state in
            state.isEmpty
        }
    }
    
    static func countIn<T: RangeExpression>(
        _ range: T
    ) -> Self where T.Bound == Int {
        var annotatoin: String = "\(range)"
        
        if let range = range as? PartialRangeFrom<T.Bound> {
            annotatoin = "\(range.lowerBound)..."
        }
        
        if let range = range as? PartialRangeThrough<T.Bound> {
            annotatoin = "...\(range.upperBound)"
        }
        
        if let range = range as? PartialRangeUpTo<T.Bound> {
            annotatoin = "..<\(range.upperBound)"
        }
        
        return .init("length in \(annotatoin)") {
            range.contains($0.count)
        }
    }
    
    static func countIn(
        _ values: Int...
    ) -> Self {
        .init("length of \(values)") {
            values.contains($0.count)
        }
    }
    
    static func countIn(
        _ values: [Int]
    ) -> Self {
        .init("length of \(values)") {
            values.contains($0.count)
        }
    }
}
