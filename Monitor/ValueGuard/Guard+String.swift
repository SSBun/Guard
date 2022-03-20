//
//  Guard+String.swift
//  Monitor
//
//  Created by SSBun on 2022/3/20.
//

import Foundation

public extension Guard where State: StringProtocol {
    
    static func contains<S: StringProtocol>(
        _ string: S,
        options: NSString.CompareOptions = .init()
    ) -> Self {
        .init {
            $0.range(of: string, options: options) != nil
        }
    }
    
    static func hasPrefix<S: StringProtocol>(
        _ prefix: S
    ) -> Self {
        .init {
            $0.hasPrefix(prefix)
        }
    }
    
    static func hasSuffix<S: StringProtocol>(
        _ suffix: S
    ) -> Self {
        .init {
            $0.hasSuffix(suffix)
        }
    }
    
    static func lengthIn<T: RangeExpression>(
        _ range: T
    ) -> Self where T.Bound == Int {
        countIn(range)
    }
    
    static func lengthIn(
        _ values: Int...
    ) -> Self {
        countIn(values)
    }
}

public extension Guard where State == String {
    
    static func regex(
        _ regularExpression: NSRegularExpression,
        matchingOptions: NSRegularExpression.MatchingOptions = .init()
    ) -> Self {
        .init {
            regularExpression.firstMatch(
                in: $0,
                options: matchingOptions,
                range: .init($0.startIndex..., in: $0)
            ) != nil
        }
    }
    
    static func regex(
        _ pattern: String,
        onInvalidPatternGuard: @autoclosure @escaping () -> Guard<Void> = .reject,
        matchingOptions: NSRegularExpression.MatchingOptions = .init()
    ) -> Self {
        do {
            return self.regex(
                try NSRegularExpression(pattern: pattern),
                matchingOptions: matchingOptions
            )
        } catch {
            return .init { _ in
                onInvalidPatternGuard().check(())
            }
        }
    }
}
