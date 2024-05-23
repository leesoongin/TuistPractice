//
//  CommonNetworkError.swift
//  CoreNetwork
//
//  Created by Ren Shin on 2023/10/18.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

public enum CommonNetworkError: Error {
    case unknown
    case invalidURL
    case invalidResponse
    case invalidStatus(code: Int)
    case cancelled
}
