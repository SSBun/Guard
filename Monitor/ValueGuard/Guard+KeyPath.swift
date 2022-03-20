//
//  Guard+KeyPath.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

public extension Guard {
    
    static func keyPath<T>(
        _ keyPath: KeyPath<State, T>,
        _ guard: Guard<T>
    ) -> Self {
        .init {
            `guard`.check($0[keyPath: keyPath])
        }
    }
    
    static func keyPath(
        _ keyPath: KeyPath<State, Bool>
    ) -> Self {
        .init {
            $0[keyPath: keyPath]
        }
    }
}
