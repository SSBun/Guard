//
//  Guarded.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

public struct NoneReporter<Value>: Reporter {
    public typealias ReportableData = Value
    
    public init(reportedData: Value) {}
}

@propertyWrapper
public struct Guarded<State, R: Reporter> {
    public private(set) var state: State
    public let `guard`: Guard<State>
    private let reporterType: R.Type
    
    public var wrappedValue: State {
        get {
            state
        }
        set {
            state = newValue
        }
    }
    
    public init(
        wrappedValue: State,
        _ guard: Guard<State>,
        _ reporterType: R.Type
    ) where R.ReportableData == State {
        self.`guard` = `guard`
        self.state = wrappedValue
        self.reporterType = reporterType
    }
    
    public init(
        wrappedValue: State,
        _ guard: Guard<State>
    ) where R.ReportableData == State {
        self.`guard` = `guard`
        self.state = wrappedValue
        self.reporterType = NoneReporter<State>.self as! R.Type
    }
}

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
