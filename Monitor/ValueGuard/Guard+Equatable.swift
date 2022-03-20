//
//  Guard+Equatable.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

public extension Guard where State: Equatable {
    
    static func equals(
        _ value: State
    ) -> Self {
        .init {
            $0 == value
        }
    }
}
