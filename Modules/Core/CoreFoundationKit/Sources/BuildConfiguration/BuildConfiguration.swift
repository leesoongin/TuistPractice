//
//  BuildConfiguration.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/15.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

public enum BuildConfiguration {
    case debug
    case testFlight
    case appStore
}

public extension BuildConfiguration {
    static let isTokTok: Bool = {
        AdapterManager.shared.adapter.isTokTok
    }()

    static let isDebug: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()

    // debug 빌드가 아니면서 sandboxReceipt 인 경우 testFlight 빌드
    static let isTestFlight: Bool = {
        isDebug == false && Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }()

    // debug 빌드가 아니면서 testFlight 빌드도 아니면 appStore 빌드
    static let isAppStore: Bool = {
        isDebug == false && isTestFlight == false
    }()

    static let current: BuildConfiguration = {
        if isDebug {
            return .debug
        } else if isTestFlight {
            return .testFlight
        } else {
            return .appStore
        }
    }()
}
