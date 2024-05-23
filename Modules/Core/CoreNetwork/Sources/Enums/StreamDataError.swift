//
//  StreamDataError.swift
//  CoreNetwork
//
//  Created by Leo on 2024/02/26.
//  Copyright © 2024 Swit. All rights reserved.
//

import Foundation

public enum StreamDataError: Error {
    case error(code: Int, message: String?)
}
