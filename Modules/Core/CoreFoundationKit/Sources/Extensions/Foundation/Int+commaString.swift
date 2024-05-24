//
//  Int+commaString.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 3/26/24.
//  Copyright © 2024 Swit. All rights reserved.
//

import Foundation

extension Int {
    public var commaString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = AdapterManager.shared.adapter.currentLocale

        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
