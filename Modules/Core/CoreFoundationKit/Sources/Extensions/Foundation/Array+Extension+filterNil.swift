//
//  Array+Extension+filterNil.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/17.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

extension Array where Element: OptionalType {
    public func filterNil() -> [Element.Wrapped] {
        self.compactMap { $0.value }
    }
}
