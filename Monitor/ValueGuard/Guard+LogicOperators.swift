//
//  Guard+LogicOperators.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation


public extension Guard {
    
    static prefix func ! (
        guarder: Self
    ) -> Self {
        .init("not (\(guarder.annotation))") {
            !guarder.check($0)
        }
    }
}

public extension Guard {
    
    static func && (
        lhs: Self,
        rhs: @autoclosure @escaping () -> Self
    ) -> Self {
        .init("(\(lhs.annotation)) && (\(rhs().annotation))") {
            lhs.check($0) && rhs().check($0)
        }
    }
    
}

public extension Guard {
    
    static func || (
        lhs: Self,
        rhs: @autoclosure @escaping () -> Self
    ) -> Self {
        .init("(\(lhs.annotation)) || (\(rhs().annotation)") {
            lhs.check($0) || rhs().check($0)
        }
    }
    
}
