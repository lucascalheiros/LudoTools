//
//  Logger.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

import Foundation

enum LogLevel: String {
    case debug = "🐛 DEBUG"
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"
}

enum Logger {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()

    private static func log(
        _ level: LogLevel,
        _ message: @autoclosure () -> String,
        file: String,
        function: String,
        line: Int
    ) {
#if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let time = dateFormatter.string(from: Date())
        print("\(time) [\(level.rawValue)] \(fileName):\(line) \(function) → \(message())")
#endif
    }

    static func debug(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.debug, message(), file: file, function: function, line: line)
    }

    static func info(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.info, message(), file: file, function: function, line: line)
    }

    static func warning(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.warning, message(), file: file, function: function, line: line)
    }

    static func error(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.error, message(), file: file, function: function, line: line)
    }
}
