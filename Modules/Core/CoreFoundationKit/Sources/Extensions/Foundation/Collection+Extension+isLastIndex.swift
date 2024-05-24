//
//  Collection+Extension+isLastIndex.swift
//  CoreFoundationKit
//
//  Created by Charles Choi on 2023/09/08.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

extension Collection {
    public func isLastIndex(_ index: Int) -> Bool {
        return ((self.count - 1) == index)
    }
}
