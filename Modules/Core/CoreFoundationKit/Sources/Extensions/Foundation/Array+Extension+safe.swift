//
//  Array+Extension+safe.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/05/30.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Index) -> Element? { indices ~= index ? self[index] : nil }
}
