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
        .init { state in
            state.isEmpty
        }
    }
    
    static func countIn<T: RangeExpression>(
        _ range: T
    ) -> Self where T.Bound == Int {
        .init {
            range.contains($0.count)
        }
    }
    
    static func countIn(
        _ values: Int...
    ) -> Self {
        .init {
            values.contains($0.count)
        }
    }
    
    static func countIn(
        _ values: [Int]
    ) -> Self {
        .init {
            values.contains($0.count)
        }
    }
}
