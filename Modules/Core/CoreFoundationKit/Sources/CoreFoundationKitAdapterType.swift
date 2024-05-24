//
//  CoreFoundationKitAdapterType.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/08/29.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit

public protocol CoreFoundationKitAdapterType {
    var isTokTok: Bool { get }
    var currentLocale: Locale { get }
}

typealias AdapterManager = CoreFoundationKitAdapterManager
public final class CoreFoundationKitAdapterManager {
    public static let shared = CoreFoundationKitAdapterManager()
    public var adapter: CoreFoundationKitAdapterType!
}
