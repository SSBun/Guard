//
//  Guard+Optional.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

extension Optional: Optionalable {
    
    public var wrapped: Wrapped? {
        
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            return nil
        }
    }
}
