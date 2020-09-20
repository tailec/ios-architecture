//
//  Params.swift
//  Log
//
//  Created by Dmytro Shulzhenko on 4/25/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation

struct Params {
    let level: Level
    let filename: StaticString
    let function: StaticString
    let line: UInt
    let message: () -> Any
    
    init(level: Level,
         filename: StaticString,
         function: StaticString,
         line: UInt,
         message: @escaping () -> Any) {
        self.level = level
        self.filename = filename
        self.function = function
        self.line = line
        self.message = message
    }
}

extension Params {
    static func debug(_ message: @escaping @autoclosure () -> Any = "",
                      _ file: StaticString = #file,
                      _ function: StaticString = #function,
                      _ line: UInt = #line) -> Params {
        return Params(level: .debug,
                      filename: file,
                      function: function,
                      line: line,
                      message: message)
    }
    
    static func info(_ message: @escaping @autoclosure () -> Any = "",
                     _ file: StaticString = #file,
                     _ function: StaticString = #function,
                     _ line: UInt = #line) -> Params {
        return Params(level: .info,
                      filename: file,
                      function: function,
                      line: line,
                      message: message)
    }
    
    static func warning(_ message: @escaping @autoclosure () -> Any = "",
                        _ file: StaticString = #file,
                        _ function: StaticString = #function,
                        _ line: UInt = #line) -> Params {
        return Params(level: .warning,
                      filename: file,
                      function: function,
                      line: line,
                      message: message)
    }
    
    static func error(_ message: @escaping @autoclosure () -> Any = "",
                      _ file: StaticString = #file,
                      _ function: StaticString = #function,
                      _ line: UInt = #line) -> Params {
        return Params(level: .error,
                      filename: file,
                      function: function,
                      line: line,
                      message: message)
    }
    
    static func fatal(_ message: @escaping @autoclosure () -> Any = "",
                      _ file: StaticString = #file,
                      _ function: StaticString = #function,
                      _ line: UInt = #line) -> Params {
        return Params(level: .fatal,
                      filename: file,
                      function: function,
                      line: line,
                      message: message)
    }
}
