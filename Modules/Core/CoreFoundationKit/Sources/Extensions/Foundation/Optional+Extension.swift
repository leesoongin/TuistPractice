//
//  Optional+Extension.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/07/31.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

extension Optional {
    public var isNil: Bool {
        switch self {
        case .some:
            return false
        case .none:
            return true
        }
    }

    public var isNotNil: Bool {
        !isNil
    }
}
