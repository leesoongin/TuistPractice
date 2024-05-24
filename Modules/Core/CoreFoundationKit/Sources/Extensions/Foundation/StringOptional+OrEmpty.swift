//
//  StringOptional+OrEmpty.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/17.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    public var orEmpty: String {
        switch self {
        case .some(let value):
            return value
        case .none:
            return ""
        }
    }
}
