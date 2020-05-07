//
//  TKLogger.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/20.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation

public final class TKLogger {

    public enum Level: Int {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4
    }
    
    // a set of active destinations
    public private(set) static var destinations = Set<TKLogBaseDestination>()
    private(set) static var loggerTag = "Shper"
    
    /// 初始化TKLogger
    ///
    /// - Parameters:
    ///   - tag: 日志标签
    ///   - useNSLog: use NSLog instead of print, default is false.
    ///               NSLog difference: https://stackoverflow.com/questions/25951195/swift-print-vs-println-vs-nslog
    /// - Returns: 是否初始化成功
    @discardableResult
    public class func setup(tag: String, useNSLog: Bool = false) -> Bool {
        guard !tag.isEmpty else { return false }
        
        loggerTag = tag
        let console = TKLogConsoleDestination.init()
        console.useNSLog = useNSLog
        return addDestination(console)
    }
    
    // MARK: Destination Handling

    /// returns boolean about success
    @discardableResult
    public class func addDestination(_ destination: TKLogBaseDestination) -> Bool {
        if destinations.contains(destination) {
            return false
        }

        destinations.insert(destination)
        return true
    }
    
    /// if you need to start fresh
    public class func removeAllDestinations() {
        destinations.removeAll()
    }

    /// returns the current thread name
    class func threadName() -> String {
        if Thread.isMainThread {
            return ""
        } else {
            let threadName = Thread.current.name
            if let threadName = threadName, !threadName.isEmpty {
                return threadName
            } else {
                return String(format: "%p", Thread.current)
            }
        }
    }

    // MARK: Levels

    /// log something which help during debugging (low priority)
    public class func debug(_ message: @autoclosure () -> Any, _ internalInfo: @autoclosure () -> Any = Void.self, _
        file: String = #file, _ function: String = #function, line: Int = #line) {
        custom(level: .debug, message: message(), internalInfo: internalInfo(), file: file, function: function, line: line)
    }

    /// log something which you are really interested but which is not an issue or error (normal priority)
    public class func info(_ message: @autoclosure () -> Any, _ internalInfo: @autoclosure () -> Any = Void.self, _
        file: String = #file, _ function: String = #function, line: Int = #line) {
        custom(level: .info, message: message(), internalInfo: internalInfo(), file: file, function: function, line: line)
    }

    /// log something which may cause big trouble soon (high priority)
    public class func warning(_ message: @autoclosure () -> Any? = Void.self,
                              _ internalInfo: @autoclosure () -> Any = Void.self,
                              _ file: String = #file,
                              _ function: String = #function,
                              line: Int = #line) {
        custom(level: .warning, message: message(), internalInfo: internalInfo(), file: file, function: function, line: line)
    }

    /// log something which will keep you awake at night (highest priority)
    public class func error(_ message: @autoclosure () -> Any, _ internalInfo: @autoclosure () -> Any = Void.self, _
        file: String = #file, _ function: String = #function, line: Int = #line) {
        custom(level: .error, message: message(), internalInfo: internalInfo(), file: file, function: function, line: line)
    }

    /// custom logging to manually adjust values, should just be used by other frameworks
    class func custom(level: TKLogger.Level, message: @autoclosure () -> Any, internalInfo: @autoclosure () -> Any,
                             file: String = #file, function: String = #function, line: Int = #line) {
        dispatch_send(level: level, message: message(), internalInfo: internalInfo(), thread: threadName(),
                      file: file, function: function, line: line)
    }

    /// internal helper which dispatches send to dedicated queue if minLevel is ok
    class func dispatch_send(level: TKLogger.Level, message: @autoclosure () -> Any, internalInfo: @autoclosure () -> Any,
        thread: String, file: String, function: String, line: Int) {
        
        var msgStr = "\(message())"
        if (msgStr == "()") {
            msgStr = ""
        }
        
        var innerMessage = "\(internalInfo())"
        if (innerMessage == "()") {
            innerMessage = ""
        }
        
        for dest in destinations {

            guard let queue = dest.queue else { continue }

            if dest.shouldLevelBeLogged(level, path: file, function: function, message: msgStr) {
                
                let f = stripParams(function: function)

                if dest.asynchronously {
                    queue.async {
                        _ = dest.send(level, msg: msgStr, internalInfo: innerMessage, thread: thread, file: file, function: f, line: line)
                    }
                } else {
                    queue.sync {
                        _ = dest.send(level, msg: msgStr, internalInfo: innerMessage, thread: thread, file: file, function: f, line: line)
                    }
                }
            }
        }
    }

    /// removes the parameters from a function because it looks weird with a single param
    class func stripParams(function: String) -> String {
        var f = function
        if let indexOfBrace = f.firstIndex(of: "(") {
            f = String(f[..<indexOfBrace])
        }
        f += "()"
        return f
    }
}

extension TKLogger {
    public static func paramInvalid(_ paramName: String) -> String {
        return "The parameter: \(paramName) is empty. do nothing!"
    }
}
