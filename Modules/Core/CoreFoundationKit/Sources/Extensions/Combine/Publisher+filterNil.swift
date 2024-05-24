//
//  Publisher+filterNil.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/09/26.
//  Copyright © 2023 Swit. All rights reserved.
//

import Combine

extension Publisher where Output: OptionalType {
    public func filterNil() -> Publishers.CompactMap<Self, Output.Wrapped> {
        return compactMap { $0.value }
    }
}
