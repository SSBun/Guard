//
//  Guard.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation


public struct Guard<State> {
    private let check: (State) -> Bool
    public let annotation: String
    
    /// Initializes a gaurder.
    /// - Parameters:
    ///   - annotation: The annotatoin of the checking rule. Do not use the characters of `&`,
    ///   `||`, and `!` in the annotation, they are preserved by logic operators to beautify the final output.
    ///   - check: A block to save your checking logic.
    public init(
        
        _ annotation: String,
        _ check: @escaping (State) -> Bool
    ) {
        self.annotation = annotation
        self.check = check
    }
    
    public func check(_ value: State) -> Bool {
        check(value)
    }
}

public extension Guard {
    static var pass: Self {
        .init("always checking failure") { _ in
            true
        }
    }
    
    static var reject: Self {
        .init("always checking success") { _ in
            false
        }
    }
}

