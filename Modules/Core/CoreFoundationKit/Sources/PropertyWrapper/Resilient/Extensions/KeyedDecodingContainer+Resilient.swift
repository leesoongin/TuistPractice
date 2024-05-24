//
//  KeyedDecodingContainer+Resilient.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/15.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    // @Resilient non-optional
    public func decode<T>(_ type: Resilient<T>.Type, forKey key: Key) throws -> Resilient<T>
    where T: Resilientable {
        resilientlyDecode(valueForKey: key, fallback: T.decodingFallback)
    }

    // @Resilient optional
    public func decode<T>(_ type: Resilient<T?>.Type, forKey key: Key) throws -> Resilient<T?>
    where T: Resilientable {
        resilientlyDecode(valueForKey: key, fallback: nil)
    }

    // @Resilient array
    public func decode<Element>(_ type: Resilient<[Element]>.Type, forKey key: Key) throws -> Resilient<[Element]>
    where Element: Resilientable {
        resilientlyDecode(valueForKey: key, fallback: [Element].decodingFallback) { _ in
            let value = try self.decode([Element].self, forKey: key)
            return Resilient(wrappedValue: value)
        }
    }

    // @Resilient dictionary
    public func decode<KEY, VALUE>(_ type: Resilient<[KEY: VALUE]>.Type, forKey key: Key) throws -> Resilient<[KEY: VALUE]>
    where KEY: Hashable,
          VALUE: Resilientable {
        resilientlyDecode(valueForKey: key, fallback: [KEY: VALUE].decodingFallback) { _ in
            let value = try self.decode([KEY: VALUE].self, forKey: key)
            return Resilient(wrappedValue: value)
        }
    }

    // @Resilient dictionary - enum key
    public func decode<KEY, VALUE, RAWVALUE>(_ type: Resilient<[KEY: VALUE]>.Type, forKey key: Key) throws -> Resilient<[KEY: VALUE]>
    where KEY: RawRepresentable, KEY: Decodable, KEY.RawValue == RAWVALUE,
          VALUE: Resilientable,
          RAWVALUE: Decodable, RAWVALUE: Hashable {
        resilientlyDecode(valueForKey: key, fallback: [KEY: VALUE].decodingFallback) { _ in
            let rawDictionary = try self.decode([RAWVALUE: VALUE].self, forKey: key)
            var dictionary = [KEY: VALUE]()

            for (key, value) in rawDictionary {
                guard let enumKey = KEY(rawValue: key) else {
                    let error = DecodingError.Context(codingPath: codingPath,
                                                      debugDescription: "Could not parse json key \(key) to a \(KEY.self) enum")
                    throw DecodingError.dataCorrupted(error)
                }

                dictionary[enumKey] = value
            }

            return Resilient(wrappedValue: dictionary)
        }
    }

    private func resilientlyDecode<T>(valueForKey key: Key,
                                      fallback: @autoclosure () -> T,
                                      behaveLikeOptional: Bool = true,
                                      body: (Decoder) throws -> Resilient<T> = { Resilient(wrappedValue: try T(from: $0)) }) -> Resilient<T>
    where T: Decodable {
        if behaveLikeOptional, !contains(key) {
            return Resilient(wrappedValue: fallback())
        }
        do {
            let decoder = try superDecoder(forKey: key)
            do {
                if behaveLikeOptional, try decoder.singleValueContainer().decodeNil() {
                    return Resilient(wrappedValue: fallback())
                }
                return try body(decoder)
            } catch {
                Log.error(error)
                return Resilient(wrappedValue: fallback())
            }
        } catch {
            Log.error(error)
            return Resilient(wrappedValue: fallback())
        }
    }
}
