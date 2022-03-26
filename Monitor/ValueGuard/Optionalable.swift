//
//  Optionalable.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//


import Foundation

// MARK: - Optionalable

public protocol Optionalable: ExpressibleByNilLiteral {
    
    associatedtype Wrapped
    
    var wrapped: Wrapped? { get }
    
    init(_ some: Wrapped)
    
}
