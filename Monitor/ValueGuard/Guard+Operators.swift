//
//  Guard+Operators.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation


prefix operator .<
prefix operator .<=
prefix operator .>
prefix operator .>=
prefix operator .==

prefix func .<<T: Comparable>(_ value: T) -> Guard<T> {
    .less(value)
}

prefix func .<=<T: Comparable>(_ value: T) -> Guard<T> {
    .lessOrEqual(value)
    
}

prefix func .><T: Comparable>(_ value: T) -> Guard<T> {
    .greater(value)
}

prefix func .>=<T: Comparable>(_ value: T) -> Guard<T> {
    .greaterOrEqual(value)
}

prefix func .==<T: Equatable>(_ value: T) -> Guard<T> {
    .equals(value)
}

