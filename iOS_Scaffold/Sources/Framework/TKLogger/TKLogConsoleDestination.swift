//
//  TKLogConsoleDestination.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/21.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation

public class TKLogConsoleDestination: TKLogBaseDestination {
    
    /// use NSLog instead of print, default is false
    /// difference: https://stackoverflow.com/questions/25951195/swift-print-vs-println-vs-nslog
    public var useNSLog = false
    
    override public var defaultHashValue: Int { return 1 }
    
    public override init() {
        super.init()
        levelColor.verbose = "💜 "     // silver
        levelColor.debug = "💚 "        // green
        levelColor.info = "💙 "         // blue
        levelColor.warning = "💛 "     // yellow
        levelColor.error = "❤️ "       // red
    }
    
    // print to Xcode Console. uses full base class functionality
    override public func send(_ level: TKLogger.Level, msg: String, internalInfo: String, thread: String,
                              file: String, function: String, line: Int) -> String? {
        let formattedString = super.send(level, msg: msg, internalInfo: internalInfo, thread: thread, file: file, function: function, line: line)
        
        if let str = formattedString {
            if useNSLog {
                #if os(Linux)
                print(str)
                #else
                NSLog("%@", str)
                #endif
            } else {
                print(str)
            }
        }
        return formattedString
    }
    
}
