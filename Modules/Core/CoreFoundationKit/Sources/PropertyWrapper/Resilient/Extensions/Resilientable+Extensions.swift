//
//  Resilientable+Extensions.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/15.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

extension Bool: Resilientable {
    public static var decodingFallback: Self { false }
}

extension Int: Resilientable {
    public static var decodingFallback: Self { .zero }
}

extension String: Resilientable {
    public static var decodingFallback: Self { "" }
}

extension Array where Element: Resilientable {
    public static var decodingFallback: Self { [] }
}

extension Dictionary where Value: Resilientable {
    public static var decodingFallback: Self { [:] }
}
