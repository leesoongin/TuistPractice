//
//  Publisher+filterTrueOrFalse.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/11/03.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Combine

extension Publisher where Output == Bool {
    public func filterTrue() -> Publishers.Filter<Self> {
        return filter { $0 }
    }

    public func filterFalse() -> Publishers.Filter<Self> {
        return filter { !$0 }
    }
}
