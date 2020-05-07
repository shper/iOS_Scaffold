//
//  TKLogBaseDestination.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/21.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import Dispatch

// store operating system / platform
#if os(iOS)
let OS = "iOS"
#elseif os(OSX)
let OS = "OSX"
#elseif os(watchOS)
let OS = "watchOS"
#elseif os(tvOS)
let OS = "tvOS"
#elseif os(Linux)
let OS = "Linux"
#elseif os(FreeBSD)
let OS = "FreeBSD"
#elseif os(Windows)
let OS = "Windows"
#elseif os(Android)
let OS = "Android"
#else
let OS = "Unknown"
#endif

/// destination which all others inherit from. do not directly use
open class TKLogBaseDestination: Hashable, Equatable {
    
    /// output format pattern, see documentation for syntax
    /// output format pattern, see documentation for syntax
    /// $ is separator.
    /// D: start of datetime format; HH:mm:ss.SSS Hour Minute Second; d: end of datetime format
    /// C: color; L: level (debug, error, info)
    /// c: reset 符号
    /// N: name of file;    F: function name;   l: line
    /// M: message
    /// https://docs.swiftybeaver.com/article/20-custom-format
    //    open var format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M $i"
    
    open var format = "$Dyyyy-MM-dd HH:mm:ss$d $C$L$c $T $N.$F:$l - $M $i"
    
    /// runs in own serial background thread for better performance
    open var asynchronously = true
    
    /// do not log any message which has a lower level than this one
    open var minLevel = TKLogger.Level.verbose
    
    /// set custom log level words for each level
    open var levelString = LevelString()
    
    /// set custom log level colors for each level
    open var levelColor = LevelColor()
    
    public struct LevelString {
        public var verbose = "V"
        public var debug = "D"
        public var info = "I"
        public var warning = "W"
        public var error = "E"
    }
    
    // For a colored log level word in a logged line
    // empty on default
    public struct LevelColor {
        public var verbose = ""     // silver
        public var debug = ""       // green
        public var info = ""        // blue
        public var warning = ""     // yellow
        public var error = ""       // red
    }
    
    var reset = ""
    var escape = ""
    
    var filters = [FilterType]()
    let formatter = DateFormatter()
    let startDate = Date()
    
    // each destination class must have an own hashValue Int
    lazy public var hashValue: Int = self.defaultHashValue
    open var defaultHashValue: Int {return 0}
    
    // each destination instance must have an own serial queue to ensure serial output
    // GCD gives it a prioritization between User Initiated and Utility
    var queue: DispatchQueue? //dispatch_queue_t?
    var debugPrint = false // set to true to debug the internal filter logic of the class
    
    public init() {
        let uuid = NSUUID().uuidString
        let queueLabel = "TKLog-queue-" + uuid
        queue = DispatchQueue(label: queueLabel, target: queue)
    }
    
    /// send / store the formatted log message to the destination
    /// returns the formatted log message for processing by inheriting method
    /// and for unit tests (nil if error)
    open func send(_ level: TKLogger.Level,
                   msg: String,
                   internalInfo: String,
                   thread: String,
                   file: String,
                   function: String,
                   line: Int) -> String? {
        
        return formatMessage(format,
                             level:level,
                             msg: msg,
                             innerMessage: internalInfo,
                             thread: thread,
                             file: file,
                             function: function,
                             line: line)
    }
    
    public func execute(synchronously: Bool, block: @escaping () -> Void) {
        guard let queue = queue else {
            fatalError("Queue not set")
        }
        if synchronously {
            queue.sync(execute: block)
        } else {
            queue.async(execute: block)
        }
    }
    
    public func executeSynchronously<T>(block: @escaping () throws -> T) rethrows -> T {
        guard let queue = queue else {
            fatalError("Queue not set")
        }
        return try queue.sync(execute: block)
    }
    
    public func hash(into hasher: inout Hasher) {
    }

    ////////////////////////////////
    // MARK: Format
    ////////////////////////////////
    
    /// returns (padding length value, offset in string after padding info)
    private func parsePadding(_ text: String) -> (Int, Int)
    {
        // look for digits followed by a alpha character
        var s: String!
        var sign: Int = 1
        if text.first == "-" {
            sign = -1
            s = String(text.suffix(from: text.index(text.startIndex, offsetBy: 1)))
        } else {
            s = text
        }
        let numStr = s.prefix { $0 >= "0" && $0 <= "9" }
        if let num = Int(String(numStr)) {
            return (sign * num, (sign == -1 ? 1 : 0) + numStr.count)
        } else {
            return (0, 0)
        }
    }
    
    private func paddedString(_ text: String, _ toLength: Int, truncating: Bool = false) -> String {
        if toLength > 0 {
            // Pad to the left of the string
            if text.count > toLength {
                // Hm... better to use suffix or prefix?
                return truncating ? String(text.suffix(toLength)) : text
            } else {
                return "".padding(toLength: toLength - text.count, withPad: " ", startingAt: 0) + text
            }
        } else if toLength < 0 {
            // Pad to the right of the string
            let maxLength = truncating ? -toLength : max(-toLength, text.count)
            return text.padding(toLength: maxLength, withPad: " ", startingAt: 0)
        } else {
            return text
        }
    }
    
    /// returns the log message based on the format pattern
    func formatMessage(_ format: String,
                       level: TKLogger.Level,
                       msg: String,
                       innerMessage: String,
                       thread: String,
                       file: String,
                       function: String,
                       line: Int) -> String {
        
        var text = ""
        // Prepend a $I for 'ignore' or else the first character is interpreted as a format character
        // even if the format string did not start with a $.
        let phrases: [String] = ("$I" + format).components(separatedBy: "$")
        
        for phrase in phrases where !phrase.isEmpty {
            let (padding, offset) = parsePadding(phrase)
            let formatCharIndex = phrase.index(phrase.startIndex, offsetBy: offset)
            let formatChar = phrase[formatCharIndex]
            let rangeAfterFormatChar = phrase.index(formatCharIndex, offsetBy: 1)..<phrase.endIndex
            let remainingPhrase = phrase[rangeAfterFormatChar]
            
            switch formatChar {
            case "I":  // ignore
                text += remainingPhrase
            case "L":
                text += paddedString(levelWord(level), padding) + remainingPhrase
            case "M":
                text += paddedString(msg, padding) + remainingPhrase
            case "i": // innerMessage
                text += paddedString(innerMessage, padding) + remainingPhrase
            case "T":
                text += paddedString(thread, padding) + remainingPhrase
            case "N":
                // name of file without suffix
                text += paddedString(fileNameWithoutSuffix(file), padding) + remainingPhrase
            case "n":
                // name of file with suffix
                text += paddedString(fileNameOfFile(file), padding) + remainingPhrase
            case "F":
                text += paddedString(function, padding) + remainingPhrase
            case "l":
                text += paddedString(String(line), padding) + remainingPhrase
            case "D":
                // start of datetime format
                text += paddedString(formatDate(String(remainingPhrase)), padding)
            case "d":
                text += remainingPhrase
            case "U":
                text += paddedString(uptime(), padding) + remainingPhrase
            case "Z":
                // start of datetime format in UTC timezone
                text += paddedString(formatDate(String(remainingPhrase), timeZone: "UTC"), padding)
            case "z":
                text += remainingPhrase
            case "C":
                // color code ("" on default)
                text += escape + colorForLevel(level) + remainingPhrase
            case "c":
                text += reset + remainingPhrase
            default:
                text += phrase
            }
        }
        // right trim only
        return text.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
    
    /// returns the string of a level
    func levelWord(_ level: TKLogger.Level) -> String {
        
        var str = ""
        
        switch level {
        case .debug:
            str = levelString.debug
            
        case .info:
            str = levelString.info
            
        case .warning:
            str = levelString.warning
            
        case .error:
            str = levelString.error
            
        default:
            // Verbose is default
            str = levelString.verbose
        }
        return str + "/\(TKLogger.loggerTag)" // append loggerTag
    }
    
    /// returns color string for level
    func colorForLevel(_ level: TKLogger.Level) -> String {
        var color = ""
        
        switch level {
        case .debug:
            color = levelColor.debug
            
        case .info:
            color = levelColor.info
            
        case .warning:
            color = levelColor.warning
            
        case .error:
            color = levelColor.error
            
        default:
            color = levelColor.verbose
        }
        return color
    }
    
    /// returns the filename of a path
    func fileNameOfFile(_ file: String) -> String {
        let fileParts = file.components(separatedBy: "/")
        if let lastPart = fileParts.last {
            return lastPart
        }
        return ""
    }
    
    /// returns the filename without suffix (= file ending) of a path
    func fileNameWithoutSuffix(_ file: String) -> String {
        let fileName = fileNameOfFile(file)
        
        if !fileName.isEmpty {
            let fileNameParts = fileName.components(separatedBy: ".")
            if let firstPart = fileNameParts.first {
                return firstPart
            }
        }
        return ""
    }
    
    /// returns a formatted date string
    /// optionally in a given abbreviated timezone like "UTC"
    func formatDate(_ dateFormat: String, timeZone: String = "") -> String {
        if !timeZone.isEmpty {
            formatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        formatter.dateFormat = dateFormat
        //let dateStr = formatter.string(from: NSDate() as Date)
        let dateStr = formatter.string(from: Date())
        return dateStr
    }
    
    /// returns a uptime string
    func uptime() -> String {
        let interval = Date().timeIntervalSince(startDate)
        
        let hours = Int(interval) / 3600
        let minutes = Int(interval / 60) - Int(hours * 60)
        let seconds = Int(interval) - (Int(interval / 60) * 60)
        let milliseconds = Int(interval.truncatingRemainder(dividingBy: 1) * 1000)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%03d", arguments: [hours, minutes, seconds, milliseconds])
    }
    
    /// returns the json-encoded string value
    /// after it was encoded by jsonStringFromDict
    func jsonStringValue(_ jsonString: String?, key: String) -> String {
        guard let str = jsonString else {
            return ""
        }
        
        // remove the leading {"key":" from the json string and the final }
        let offset = key.count + 5
        let endIndex = str.index(str.startIndex,
                                 offsetBy: str.count - 2)
        let range = str.index(str.startIndex, offsetBy: offset)..<endIndex
        return String(str[range])
    }
    
    /// turns dict into JSON-encoded string
    func jsonStringFromDict(_ dict: [String: Any]) -> String? {
        var jsonString: String?
        
        // try to create JSON string
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            jsonString = String(data: jsonData, encoding: .utf8)
        } catch {
            print("TKLogger could not create JSON from dict.")
        }
        return jsonString
    }
    
    ////////////////////////////////
    // MARK: Filters
    ////////////////////////////////
    
    /// Add a filter that determines whether or not a particular message will be logged to this destination
    public func addFilter(_ filter: FilterType) {
        filters.append(filter)
    }
    
    /// Remove a filter from the list of filters
    public func removeFilter(_ filter: FilterType) {
        let index = filters.firstIndex {
            return ObjectIdentifier($0) == ObjectIdentifier(filter)
        }
        
        guard let filterIndex = index else {
            return
        }
        
        filters.remove(at: filterIndex)
    }
    
    /// Answer whether the destination has any message filters
    /// returns boolean and is used to decide whether to resolve
    /// the message before invoking shouldLevelBeLogged
    func hasMessageFilters() -> Bool {
        return !getFiltersTargeting(TKLogFilter.TargetType.Message(.Equals([], true)),
                                    fromFilters: self.filters).isEmpty
    }
    
    /// checks if level is at least minLevel or if a minLevel filter for that path does exist
    /// returns boolean and can be used to decide if a message should be logged or not
    func shouldLevelBeLogged(_ level: TKLogger.Level, path: String,
                             function: String, message: String? = nil) -> Bool {
        
        if filters.isEmpty {
            if level.rawValue >= minLevel.rawValue {
                if debugPrint {
                    print("filters is empty and level >= minLevel")
                }
                return true
            } else {
                if debugPrint {
                    print("filters is empty and level < minLevel")
                }
                return false
            }
        }
        
        let (matchedExclude, allExclude) = passedExcludedFilters(level, path: path,
                                                                 function: function, message: message)
        if allExclude > 0 && matchedExclude != allExclude {
            if debugPrint {
                print("filters is not empty and message was excluded")
            }
            return false
        }
        
        let (matchedRequired, allRequired) = passedRequiredFilters(level,
                                                                   path: path,
                                                                   function: function,
                                                                   message: message)
        let (matchedNonRequired, allNonRequired) = passedNonRequiredFilters(level,
                                                                            path: path,
                                                                            function: function,
                                                                            message: message)
        
        // If required filters exist, we should validate or invalidate the log if all of them pass or not
        if allRequired > 0 {
            return matchedRequired == allRequired
        }
        
        // If a non-required filter matches, the log is validated
        if allNonRequired > 0 {  // Non-required filters exist
            
            if matchedNonRequired > 0 { return true }  // At least one non-required filter matched
            else { return false }  // No non-required filters matched
        }
        
        if level.rawValue < minLevel.rawValue {
            if debugPrint {
                print("filters is not empty and level < minLevel")
            }
            return false
        }
        
        return true
    }
    
    func getFiltersTargeting(_ target: TKLogFilter.TargetType, fromFilters: [FilterType]) -> [FilterType] {
        return fromFilters.filter { filter in
            return filter.getTarget() == target
        }
    }
    
    /// returns a tuple of matched and all filters
    func passedRequiredFilters(_ level: TKLogger.Level,
                               path: String,
                               function: String,
                               message: String?) -> (Int, Int) {
        let requiredFilters = self.filters.filter { filter in
            return filter.isRequired() && !filter.isExcluded()
        }
        
        let matchingFilters = applyFilters(requiredFilters,
                                           level: level,
                                           path: path,
                                           function: function,
                                           message: message)
        if debugPrint {
            print("matched \(matchingFilters) of \(requiredFilters.count) required filters")
        }
        
        return (matchingFilters, requiredFilters.count)
    }
    
    /// returns a tuple of matched and all filters
    func passedNonRequiredFilters(_ level: TKLogger.Level,
                                  path: String,
                                  function: String,
                                  message: String?) -> (Int, Int) {
        let nonRequiredFilters = self.filters.filter { filter in
            return !filter.isRequired() && !filter.isExcluded()
        }
        
        let matchingFilters = applyFilters(nonRequiredFilters,
                                           level: level,
                                           path: path,
                                           function: function,
                                           message: message)
        if debugPrint {
            print("matched \(matchingFilters) of \(nonRequiredFilters.count) non-required filters")
        }
        return (matchingFilters, nonRequiredFilters.count)
    }
    
    /// returns a tuple of matched and all exclude filters
    func passedExcludedFilters(_ level: TKLogger.Level,
                               path: String,
                               function: String,
                               message: String?) -> (Int, Int) {
        let excludeFilters = self.filters.filter { filter in
            return filter.isExcluded()
        }
        
        let matchingFilters = applyFilters(excludeFilters,
                                           level: level,
                                           path: path,
                                           function: function,
                                           message: message)
        if debugPrint {
            print("matched \(matchingFilters) of \(excludeFilters.count) exclude filters")
        }
        return (matchingFilters, excludeFilters.count)
    }
    
    func applyFilters(_ targetFilters: [FilterType],
                      level: TKLogger.Level,
                      path: String,
                      function: String,
                      message: String?) -> Int {
        return targetFilters.filter { filter in
            
            let passes: Bool
            
            if !filter.reachedMinLevel(level) {
                return false
            }
            
            switch filter.getTarget() {
            case .Path(_):
                passes = filter.apply(path)
                
            case .Function(_):
                passes = filter.apply(function)
                
            case .Message(_):
                guard let message = message else {
                    return false
                }
                
                passes = filter.apply(message)
            }
            
            return passes
        }.count
    }
    
}

public func == (lhs: TKLogBaseDestination, rhs: TKLogBaseDestination) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
