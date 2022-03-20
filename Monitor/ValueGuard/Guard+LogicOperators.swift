//
//  Guard+LogicOperators.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation


public extension Guard {
    
    static prefix func ! (
        guard: Self
    ) -> Self {
        .init {
            !`guard`.check($0)
        }
    }
    
}

public extension Guard {
    
    static func && (
        lhs: Self,
        rhs: @autoclosure @escaping () -> Self
    ) -> Self {
        .init {
            lhs.check($0) && rhs().check($0)
        }
    }
    
}

public extension Guard {
    
    static func || (
        lhs: Self,
        rhs: @autoclosure @escaping () -> Self
    ) -> Self {
        .init {
            lhs.check($0) || rhs().check($0)
        }
    }
    
}
