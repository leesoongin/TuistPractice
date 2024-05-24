//
//  OptionalType.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/17.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? { self }
}
