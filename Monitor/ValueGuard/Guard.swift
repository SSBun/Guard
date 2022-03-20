//
//  Guard.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

public struct Guard<State> {
    private let check: (State) -> Bool
    
    public init(_ check: @escaping (State) -> Bool) {
        self.check = check
    }
    
    public func check(_ value: State) -> Bool {
        check(value)
    }
}

public extension Guard {
    /// Always check success.
    static var pass: Self {
        .init { _ in
            true
        }
    }
    
    /// Always check failure.
    static var reject: Self {
        .init { _ in
            false
        }
    }
}

public func check<Value>(_ value: Value, _ guard: Guard<Value>) -> Value? {
    `guard`.check(value) ? value : nil
}


func test() {
    let value = 100
    _ = check(value, .>100 && .<=200 || .==999)
}


