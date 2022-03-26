//
//  Guard+Sequence.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

public extension Guard where State: Sequence, State.Element: Equatable {
    
    static func contains(
        _ elements: State.Element...
    ) -> Self {
        .init("contains at least one of \(elements)") { value in
            elements.map(value.contains).contains(true)
        }
    }
    
    static func containsAll(
        elements: State.Element...
    ) -> Self {
        .init("contains all of \(elements)") {
            !elements.map($0.contains).contains(false)
        }
    }
    
    static func startsWith(
        _ elements: State.Element...
    ) -> Self {
        .init("prefix with \(elements)") { value in
            value.starts(with: elements)
        }
    }
}
