//
//  Guarded.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

//public struct NoneReporter<Value>: Reporter {
//    public typealias AcceptableData = Value
//
//    public init(reportedData: Value) {}
//}
//
//@propertyWrapper
//public struct Guarded<State, R: Reporter> {
//    public private(set) var state: State
//    public let guarder: Guard<State>
//    private let reporterType: R.Type
//
//    public var wrappedValue: State {
//        get {
//            state
//        }
//        set {
//            state = newValue
//        }
//    }
//
//    public init(
//        wrappedValue: State,
//        _ guarder: Guard<State>,
//        _ reporterType: R.Type
//    ) where R.AcceptableData == State {
//        self.guarder = guarder
//        self.state = wrappedValue
//        self.reporterType = reporterType
//    }
    
//    public init<>(
//        wrappedValue: State,
//        _ guard: Guard<State>
//    ) where R: Never {
//        self.`guard` = `guard`
//        self.state = wrappedValue
//        self.reporterType =
//    }
//}

//public extension Guarded where State: Optionalable {
//    
//    init(
//        wrappedValue: State = nil,
//        _ guard: Guard<State.Wrapped>,
//        onNilGuard: Guard<Void> = .reject
//    ) {
//        self.init(
//            wrappedValue: wrappedValue,
//            .init {
//                $0.wrapped.flatMap(`guard`.check) ?? onNilGuard.check(())
//            },
//            reporter: NoneReporter.self
//        )
//    }
//}
//
