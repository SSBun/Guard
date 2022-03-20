//
//  Guard+Comparable.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

public extension Guard where State: Comparable {
    
    static func less(
        _ state: State
    ) -> Self {
        .init {
            $0 < state
        }
    }
    
    static func lessOrEqual(
        _ state: State
    ) -> Self {
        .init {
            $0 <= state
        }
    }
    
    static func greater(
        _ state: State
    ) -> Self {
        .init {
            $0 > state
        }
    }
    
    static func greaterOrEqual(
        _ state: State
    ) -> Self {
        .init {
            $0 >= state
        }
    }
}

