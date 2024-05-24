//
//  String+commaString.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 3/26/24.
//  Copyright © 2024 Swit. All rights reserved.
//

import Foundation

extension String {
    public var commaString: String {
        Int(self)?.commaString ?? self
    }
}
