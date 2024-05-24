//
//  ErrorHandlingStrategy.swift
//  SwitNetwork
//
//  Created by Ren Shin on 2023/10/20.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

public enum ErrorHandlingStrategy {
    /// error를 호출한곳까지 전달
    case passthrough
    /// error를 알아서 처리하는 등 호출한곳까지 전달하지 않음.
    case stopPropagation
}
