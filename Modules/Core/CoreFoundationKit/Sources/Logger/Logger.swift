//
//  Logger.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/15.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
//import Then

public let Log = Logger.shared

public final class Logger {
    public static let shared = Logger()

    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }
    
//    private let dateFormatter = DateFormatter().then { $0.dateFormat = "yy-MM-dd HH:mm:ss.SSS" }
    private var measure = PerformMeasure(start: 0, laped: 0)

    public func analytics(_ items: Any?..., separator: String = " | ", file: String = #file, line: Int = #line, function: String = #function) {
        print(items, separator: separator, file: file, line: line, function: function, level: .analytics)
    }

    public func debug(_ items: Any?..., separator: String = " | ", file: String = #file, line: Int = #line, function: String = #function) {
        print(items, separator: separator, file: file, line: line, function: function, level: .debug)
    }

    public func error(_ items: Any?..., separator: String = " | ", file: String = #file, line: Int = #line, function: String = #function) {
        print(items, separator: separator, file: file, line: line, function: function, level: .error)
    }

    public func info(_ items: Any?..., separator: String = " | ", file: String = #file, line: Int = #line, function: String = #function) {
        print(items, separator: separator, file: file, line: line, function: function, level: .info)
    }

    public func measure(_ items: Any?..., separator: String = " | ", file: String = #file, line: Int = #line, function: String = #function) {
        var newItems = items
        newItems.append(measure.lap())
        print(newItems, separator: separator, file: file, line: line, function: function, level: .measure)
    }

    public func print(_ items: Any?..., separator: String = " | ", file: String = #file, line: Int = #line, function: String = #function) {
        print(items, separator: separator, file: file, line: line, function: function, level: .debug)
    }

    public func warning(_ items: Any?..., separator: String = " | ", file: String = #file, line: Int = #line, function: String = #function) {
        print(items, separator: separator, file: file, line: line, function: function, level: .warning)
    }

    public func measureReset() {
        measure.reset()
    }
}

extension Logger {
    private func print(_ items: [Any?], separator: String, file: String, line: Int, function: String, level: LogLevel = .debug) {
        guard BuildConfiguration.isDebug else { return }
        let items = items.compactMap { $0 }
        let message = items.map({ String(describing: $0) }).joined(separator: separator)
        Swift.print("\(dateFormatter.string(from: Date())) \(level.rawValue)\(fileName(file)).\(function): \(line) - \(message)")
    }

    private func fileName(_ filePath: String) -> String {
        let lastPathComponent = NSString(string: filePath).lastPathComponent
        if let name = lastPathComponent.components(separatedBy: ".").first {
            return name
        } else {
            return lastPathComponent
        }
    }
}
