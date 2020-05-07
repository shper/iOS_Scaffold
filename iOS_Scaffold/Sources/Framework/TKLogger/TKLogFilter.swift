//
//  TKLogFilter.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/21.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation

/// FilterType is a protocol that describes something that determines
/// whether or not a message gets logged. A filter answers a Bool when it
/// is applied to a value. If the filter passes, it shall return true,
/// false otherwise.
///
/// A filter must contain a target, which identifies what it filters against
/// A filter can be required meaning that all required filters against a specific
/// target must pass in order for the message to be logged. At least one non-required
/// filter must pass in order for the message to be logged
public protocol FilterType : class {
    func apply(_ value: Any) -> Bool
    func getTarget() -> TKLogFilter.TargetType
    func isRequired() -> Bool
    func isExcluded() -> Bool
    func reachedMinLevel(_ level: TKLogger.Level) -> Bool
}

/// Filters is syntactic sugar used to easily construct filters
public class Filters {
    public static let Path = PathFilterFactory.self
    public static let Function = FunctionFilterFactory.self
    public static let Message = MessageFilterFactory.self
}

/// Filter is an abstract base class for other filters
public class TKLogFilter {
    public enum TargetType {
        case Path(TKLogFilter.ComparisonType)
        case Function(TKLogFilter.ComparisonType)
        case Message(TKLogFilter.ComparisonType)
    }

    public enum ComparisonType {
        case StartsWith([String], Bool)
        case Contains([String], Bool)
        case Excludes([String], Bool)
        case EndsWith([String], Bool)
        case Equals([String], Bool)
        case Custom((String) -> Bool)
    }

    let targetType: TKLogFilter.TargetType
    let required: Bool
    let minLevel: TKLogger.Level

    public init(_ target: TKLogFilter.TargetType, required: Bool, minLevel: TKLogger.Level) {
        self.targetType = target
        self.required = required
        self.minLevel = minLevel
    }

    public func getTarget() -> TKLogFilter.TargetType {
        return self.targetType
    }

    public func isRequired() -> Bool {
        return self.required
    }

    public func isExcluded() -> Bool {
        return false
    }

    /// returns true of set minLevel is >= as given level
    public func reachedMinLevel(_ level: TKLogger.Level) -> Bool {
        //print("checking if given level \(level) >= \(minLevel)")
        return level.rawValue >= minLevel.rawValue
    }
}

/// CompareFilter is a FilterType that can filter based upon whether a target
/// starts with, contains or ends with a specific string. CompareFilters can be
/// case sensitive.
public class CompareFilter: TKLogFilter, FilterType {

    private var filterComparisonType: TKLogFilter.ComparisonType?

    override public init(_ target: TKLogFilter.TargetType, required: Bool, minLevel: TKLogger.Level) {
        super.init(target, required: required, minLevel: minLevel)

        let comparisonType: TKLogFilter.ComparisonType?
        switch self.getTarget() {
        case let .Function(comparison):
            comparisonType = comparison

        case let .Path(comparison):
            comparisonType = comparison

        case let .Message(comparison):
            comparisonType = comparison

            /*default:
             comparisonType = nil*/
        }
        self.filterComparisonType = comparisonType
    }

    public func apply(_ value: Any) -> Bool {
        guard let value = value as? String else {
            return false
        }

        guard let filterComparisonType = self.filterComparisonType else {
            return false
        }

        let matches: Bool
        switch filterComparisonType {
        case let .Contains(strings, caseSensitive):
            matches = !strings.filter { string in
                return caseSensitive ? value.contains(string) :
                    value.lowercased().contains(string.lowercased())
                }.isEmpty

        case let .Excludes(strings, caseSensitive):
            matches = !strings.filter { string in
                return caseSensitive ? !value.contains(string) :
                    !value.lowercased().contains(string.lowercased())
                }.isEmpty

        case let .StartsWith(strings, caseSensitive):
            matches = !strings.filter { string in
                return caseSensitive ? value.hasPrefix(string) :
                    value.lowercased().hasPrefix(string.lowercased())
                }.isEmpty

        case let .EndsWith(strings, caseSensitive):
            matches = !strings.filter { string in
                return caseSensitive ? value.hasSuffix(string) :
                    value.lowercased().hasSuffix(string.lowercased())
                }.isEmpty

        case let .Equals(strings, caseSensitive):
            matches = !strings.filter { string in
                return caseSensitive ? value == string :
                    value.lowercased() == string.lowercased()
                }.isEmpty
        case let .Custom(predicate):
            matches = predicate(value)
        }

        return matches
    }

    override public func isExcluded() -> Bool {
        guard let filterComparisonType = self.filterComparisonType else { return false }

        switch filterComparisonType {
        case .Excludes(_, _):
            return true
        default:
            return false
        }
    }
}

// Syntactic sugar for creating a function comparison filter
public class FunctionFilterFactory {
    public static func startsWith(_ prefixes: String..., caseSensitive: Bool = false,
                                  required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Function(.StartsWith(prefixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func contains(_ strings: String..., caseSensitive: Bool = false,
                                required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Function(.Contains(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func excludes(_ strings: String..., caseSensitive: Bool = false,
                                required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Function(.Excludes(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func endsWith(_ suffixes: String..., caseSensitive: Bool = false,
                                required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Function(.EndsWith(suffixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func equals(_ strings: String..., caseSensitive: Bool = false,
                              required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Function(.Equals(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func custom(required: Bool = false, minLevel: TKLogger.Level = .verbose, filterPredicate: @escaping (String) -> Bool) -> FilterType {
        return CompareFilter(.Function(.Custom(filterPredicate)), required: required, minLevel: minLevel)
    }
}

// Syntactic sugar for creating a message comparison filter
public class MessageFilterFactory {
    public static func startsWith(_ prefixes: String..., caseSensitive: Bool = false,
                                  required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Message(.StartsWith(prefixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func contains(_ strings: String..., caseSensitive: Bool = false,
                                required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Message(.Contains(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func excludes(_ strings: String..., caseSensitive: Bool = false,
                                required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Message(.Excludes(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func endsWith(_ suffixes: String..., caseSensitive: Bool = false,
                                required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Message(.EndsWith(suffixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func equals(_ strings: String..., caseSensitive: Bool = false,
                              required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Message(.Equals(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func custom(required: Bool = false, minLevel: TKLogger.Level = .verbose, filterPredicate: @escaping (String) -> Bool) -> FilterType {
        return CompareFilter(.Message(.Custom(filterPredicate)), required: required, minLevel: minLevel)
    }
}

// Syntactic sugar for creating a path comparison filter
public class PathFilterFactory {
    public static func startsWith(_ prefixes: String..., caseSensitive: Bool = false,
                                  required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Path(.StartsWith(prefixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func contains(_ strings: String..., caseSensitive: Bool = false,
                                required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Path(.Contains(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func excludes(_ strings: String..., caseSensitive: Bool = false,
                                required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Path(.Excludes(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func endsWith(_ suffixes: String..., caseSensitive: Bool = false,
                                required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Path(.EndsWith(suffixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func equals(_ strings: String..., caseSensitive: Bool = false,
                              required: Bool = false, minLevel: TKLogger.Level = .verbose) -> FilterType {
        return CompareFilter(.Path(.Equals(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func custom(required: Bool = false, minLevel: TKLogger.Level = .verbose, filterPredicate: @escaping (String) -> Bool) -> FilterType {
        return CompareFilter(.Path(.Custom(filterPredicate)), required: required, minLevel: minLevel)
    }
}

extension TKLogFilter.TargetType : Equatable {
}

// The == does not compare associated values for each enum. Instead == evaluates to true
// if both enums are the same "types", ignoring the associated values of each enum
public func == (lhs: TKLogFilter.TargetType, rhs: TKLogFilter.TargetType) -> Bool {
    switch (lhs, rhs) {

    case (.Path(_), .Path(_)):
        return true

    case (.Function(_), .Function(_)):
        return true

    case (.Message(_), .Message(_)):
        return true

    default:
        return false
    }
}
