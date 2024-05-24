//
//  Parsable.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/12.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

public protocol Parsable {
    init?(from: String)
}

private extension Parsable {
    init?(_ string: String, conversion: (String) -> Self?) {
        guard let value = conversion(string) else { return nil }
        self = value
    }
}

extension Int: Parsable {
    public init?(from string: String) {
        self.init(string) { value in Int(value) }
    }
}

extension Int64: Parsable {
    public init?(from string: String) {
        self.init(string) { value in Int64(value) }
    }
}

extension Float: Parsable {
    public init?(from string: String) {
        self.init(string) { value in Float(value) }
    }
}

extension Double: Parsable {
    public init?(from string: String) {
        self.init(string) { value in Double(value) }
    }
}

extension Bool: Parsable {
    public init?(from string: String) {
        self.init(string) { value in
            if value == "1" {
                return true
            } else if value == "0" {
                return false
            } else {
                return Bool(value)
            }
        }
    }
}

extension String: Parsable {
    public init?(from string: String) {
        self = string
    }
}

extension URL: Parsable {
    public init?(from string: String) {
        self.init(string) { value in URL(string: value) }
    }
}

extension Array: Parsable where Array.Element: Parsable {
    public init?(from string: String) {
        let components = string.split(separator: ",")
        self = components
            .map { String($0) }
            .compactMap(Element.init(from:))
    }
}

extension RawRepresentable where Self: Parsable, Self.RawValue == String {
    public init?(from string: String) {
        guard let value = Self(rawValue: string) else { return nil }
        self = value
    }
}

extension Array where Array.Element == URLQueryItem {
    public subscript<T: Parsable>(_ key: String) -> T? {
        getQueryItemValue(for: key)
    }

    public func getQueryItemValue<T: Parsable>(for key: String) -> T? {
        guard let queryItem = self.first(where: { $0.name.lowercased() == key.lowercased() }) else { return nil }

        if let queryValue = queryItem.value, let value = T(from: queryValue) {
            return value
        }

        return nil
    }
}
