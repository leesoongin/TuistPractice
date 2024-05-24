//
//  CodableHasUnknownEnumType.swift
//  CoreFoundationKit
//
//  Created by Leo on 2024/02/06.
//  Copyright © 2024 Swit. All rights reserved.
//

import Foundation

public protocol CodableHasUnknownEnumType: Codable, RawRepresentable {
    static var unknown: Self { get }
}

public extension CodableHasUnknownEnumType where Self.RawValue == String {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.unknown
    }
}
