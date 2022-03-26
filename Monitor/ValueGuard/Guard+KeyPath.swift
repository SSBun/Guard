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
        _ guarder: Guard<T>
    ) -> Self {
        .init("the vlaue of key `\(NSExpression(forKeyPath: keyPath).keyPath)` matches \(guarder.annotation)") {
            guarder.check($0[keyPath: keyPath])
        }
    }
    
    static func keyPath(
        _ keyPath: KeyPath<State, Bool>
    ) -> Self {
        .init("the value of key `\(NSExpression(forKeyPath: keyPath).keyPath)` is true") {
            $0[keyPath: keyPath]
        }
    }
}
