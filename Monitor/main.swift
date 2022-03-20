//
//  main.swift
//  Monitor
//
//  Created by SSBun on 2022/3/19.
//

import Foundation

// MARK: - Reporter

public protocol Reporter {
    associatedtype ReportableData
    init(reportedData: ReportableData)
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
    public typealias ReportableData = T
    public let data: T
    public init(reportedData: T) {
        data = reportedData
    }
}

public extension Sentry where T == MonitoredParser {
    var report: KeywordArgumentsCallable<Any> { KeywordArgumentsCallable { report($0) } }
    func report(_ pairs: KeyValuePairs<String, Any>) {
        
    }
}

public extension Sentry where T == String {
    var report: KeywordArgumentsCallable<Any> { KeywordArgumentsCallable { report($0) } }
    func report(_ pairs: KeyValuePairs<String, Any>) {
        
    }
}

// MARK: - Reportable

@propertyWrapper
public struct Reportable<S: Reporter> {
    let value: S.ReportableData
    let reporterType: S.Type
    
    public var wrappedValue: S.ReportableData {
        value
    }
    
    /// If the `ReportedValue` is of value type, the value of this reporter
    /// will never be changed again after reading.
    public var projectedValue: S {
        reporterType.init(reportedData: value)
    }
    
    public init(wrappedValue: S.ReportableData, _ reporterType: S.Type) {
        self.value = wrappedValue
        self.reporterType = reporterType
    }
}

// MARK: - MonitoredParser

public struct MonitoredParser {
    let decoder: Decoder
    let errors = Storage()
    init(_ decoder: Decoder) {
        self.decoder = decoder
    }
    
    func parse<T>(
        _ key: String,
        _ guard: Guard<T> = .reject,
        default: T,
        file: String = #file,
        line: Int = #line
    ) -> T {
//        do {
//            try
//        } catch {
//        }
        `default`
    }
    
    
    func tryParse<T>(
        _ key: String,
        _ guard: Guard<T> = .pass
    ) throws -> T {
        throw NSError(domain: "", code: 402, userInfo: nil)
    }
    
    func parse<T>(
        _ key: String,
        _ guard: Guard<T>
    ) -> Optional<T> {
        .none
    }
    
    class Storage {
        var erros: [Any] = []
    }
}

struct FloowStatus: Codable {
    let id: String
    let isFollowing: Bool
    let weight: Double
    let userEmail: String?
    init(from decoder: Decoder) throws {
        @Reportable(Sentry.self)
        var parser = MonitoredParser(decoder)
        
        isFollowing = parser.parse("is_following", default: false)
        weight = parser.parse("weight", .greater(10) ,default: 0)
        userEmail = parser.parse("avatar", .lengthIn(8...20))
        id = try parser.tryParse("id", .greaterOrEqual("0"))
        
//        $parser.report(name: "csl", id: 100, target: "iOS")
        $parser.report(["name": "ssbun"])
        
//        Sentry(reportedData: 0)
        
//        @Monitor<Sentry>(translater: .JSON)
//        var errors: [Error] = []
//        $parser?.commit()
//        parser = MonitoredParser(decoder)
        
//        isFollowed = parser()
//        let container = try decoder.container(keyedBy: <#T##CodingKey.Protocol#>)
        
        
        
//        MonitoredDecoder(decoder) {
//            Parser(&isFollowing, value: true)
//        }
        //        Analysis(decoder, &errors) {
        //            Parse("is_following", isFollowing, validation: .constant(false), default: false)
        //        }
        
//        isFollowing = try container.decodeIfPresent("is_following") ?? false
//        isFollowed = try container.decodeIfPresent("is_followed") ?? false
        
//        $errors.commit()
    }
}

_ = Guarded<Int, NoneReporter>(wrappedValue: 100, .<=200)
