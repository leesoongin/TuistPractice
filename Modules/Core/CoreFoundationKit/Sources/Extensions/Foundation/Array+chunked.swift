//
//  Array+chunked.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/07/12.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

extension Array {
    public func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
