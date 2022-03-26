//
//  main.swift
//  Monitor
//
//  Created by SSBun on 2022/3/19.
//

import Foundation

// MARK: - Reporter

public protocol Reporter {
    associatedtype AcceptableData
    mutating func update(data: AcceptableData)
}

// MARK: - KeywordArgumentsCallable

@dynamicCallable
public struct KeywordArgumentsCallable<Value> {
    private let invokeCallback: (KeyValuePairs<String, Value>) -> Void
    
    init(_ invokeCallback: @escaping (KeyValuePairs<String, Value>) -> Void) {
        self.invokeCallback = invokeCallback
    }
    
    func dynamicallyCall(withKeywordArguments pairs: KeyValuePairs<String, Value>) {
        invokeCallback(pairs)
    }
}

// MARK: - Sentry

public struct Sentry<T>: Reporter {
    public typealias AcceptableData = T
    
    public var data: T?
    
    public mutating func update(data: T) {
        self.data = data
    }
}

public extension Sentry where T == MonitoredParser {
    var report: KeywordArgumentsCallable<Any> {
        KeywordArgumentsCallable { [self] in report($0) } }
    func report(_ pairs: KeyValuePairs<String, Any>) {
        guard let data = data else { return }
        let message = """
            Sentry Error Report:
            \(pairs.map { "\($0.key): \($0.value)" }.joined(separator: "\n"))
            \(data.errors.values.joined(separator: "\n"))
            """
        print(message)
    }
}

public extension Sentry where T == String {
    var report: KeywordArgumentsCallable<Any> { KeywordArgumentsCallable { report($0) } }
    func report(_ pairs: KeyValuePairs<String, Any>) {
        
    }
}

// MARK: - Reportable

@propertyWrapper
public struct Reportable<R: Reporter> {
    var value: R.AcceptableData {
        didSet {
            reporter.update(data: value)
        }
    }
    var reporter: R
    
    public var wrappedValue: R.AcceptableData {
        get {
            value
        }
        set {
            value = newValue
        }
    }
    
    /// If the `ReportedValue` is of value type, the value of this reporter
    /// will never be changed again after reading.
    public var projectedValue: R {
        reporter
    }
    
    public init(wrappedValue: R.AcceptableData, reporter: R) {
        self.reporter = reporter
        self.value = wrappedValue
        self.reporter.update(data: wrappedValue)
    }
}

// MARK: - MonitoredParser

public class MonitoredParser {
    let decoder: [String: Any]
    let errors = Storage()
    private var alreadyReported: Bool = false
    init(_ decoder: [String: Any]) {
        self.decoder = decoder
    }
    
    func parse<T>(
        _ key: String,
        _ guarder: Guard<T> = .reject,
        default: T,
        file: String = #file,
        line: Int = #line
    ) -> T {
        guard let value = decoder[key] else {
            reportError(
                file: file,
                line: line,
                key: key,
                guarderAnnotation: guarder.annotation,
                reason: "Not found",
                originalValue: "",
                valueType: T.self)
                
            return `default`
        }
        
        guard let parsedValue = value as? T else {
            reportError(
                file: file,
                line: line,
                key: key,
                guarderAnnotation: guarder.annotation,
                reason: "Casting type failure",
                originalValue: value,
                valueType: T.self)
            return `default`
        }
        
        if !guarder.check(parsedValue) {
            reportError(
                file: file,
                line: line,
                key: key,
                guarderAnnotation: guarder.annotation,
                reason: "Validation failure",
                originalValue: parsedValue,
                valueType: T.self)
        }
        
        return parsedValue
    }
    
    
    func tryParse<T>(
        _ key: String,
        _ guarder: Guard<T> = .pass
    ) throws -> T {
        throw NSError(domain: "", code: 402, userInfo: nil)
    }
    
    func parse<T>(
        _ key: String,
        _ guarder: Guard<T>,
        notNil: Bool = false,
        file: String = #file,
        line: Int = #line
    ) -> Optional<T> {
        guard let value = decoder[key] else {
            if notNil {
                reportError(
                    file: file,
                    line: line,
                    key: key,
                    guarderAnnotation: guarder.annotation,
                    reason: "Not found",
                    originalValue: "<<nil>>",
                    valueType: T.self)
            }
            return nil
        }
        
        guard let parsedValue = value as? T else {
            reportError(
                file: file,
                line: line,
                key: key,
                guarderAnnotation: guarder.annotation,
                reason: "Type casting failure",
                originalValue: value,
                valueType: T.self)
            return nil
        }
        
        if !guarder.check(parsedValue) {
            reportError(
                file: file,
                line: line,
                key: key,
                guarderAnnotation: guarder.annotation,
                reason: "Validation failure",
                originalValue: parsedValue,
                valueType: T.self)
        }
        
        return parsedValue
    }
    
    private func reportError(
        file: String,
        line: Int,
        key: String,
        guarderAnnotation: String,
        reason: String,
        originalValue: Any,
        valueType: Any
    ) {
        let str = """
            ParsedKey:     \(key)
            OriginalValue: \(originalValue)
            CastTo:        \(valueType)
            Reason:        \(reason)
            Validation:    \(guarderAnnotation)
            Address:       \(file)::\(line)
        
        """
        errors.record(str)
    }
    
    func report() {
        alreadyReported = true
        var sentry = Sentry<MonitoredParser>()
        sentry.update(data: self)
        sentry.report()
    }
    
    deinit {
        if !alreadyReported {
            report()
        }
    }
    
    class Storage {
        private(set) var values: [String] = []
        func record(_ error: String) {
            values.append(error)
        }
    }
}

struct TestModel {
    let id: Int
    let isFollowing: Bool
    let weight: Double
    let userEmail: String?
    var score: Int
    var categories: [String]
    
    init(from decoder: [String: Any]) throws {
        
        let parser = MonitoredParser(decoder)
        
        isFollowing = parser.parse("is_following", default: false)
        weight = parser.parse("weight", !(.>0) ,default: 0)
        id = parser.parse("id", .greater(0), default: 0)
        score = parser.parse("score", .>=0 && .<=100, default: 0)
        categories = parser.parse("categories", .countIn(1...), default: [])
        userEmail = parser.parse("email", .regex("^.*@zhihu.com"), notNil: true)
    }
}

let remoteData: [String: Any] = [
    "is_following": 1,
    "weight": 30.4,
    "email": "caishilin@yahoo.com",
    "id": -1,
    "score": 999,
    "math_score": "null",
    "categories": []
]

do {
    let _ = try TestModel(from: remoteData)
} catch(let error) {
    print("Error:\n \(error)")
}


