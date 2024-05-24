//
//  PerformMeasure.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/15.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

public struct PerformMeasure {
    var start: TimeInterval
    var laped: TimeInterval

    mutating func reset() {
        start = 0
        laped = 0
        print("Performance Measure Reset..")
    }

    mutating func lap() -> String {
        if start == 0 {
            start = CFAbsoluteTimeGetCurrent()
            return "Performance Measure Start at \(start) =========================>"
        }
        laped = CFAbsoluteTimeGetCurrent() - start
        return "\(laped) measured"
    }
}
