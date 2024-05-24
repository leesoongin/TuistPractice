//
//  Resilientable.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/15.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

public protocol Resilientable: Codable {
    static var decodingFallback: Self { get }
}
