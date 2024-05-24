//
//  Collection+Transposed.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/08/09.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

/**
 let a = [1, 2, 3]
 let b = [4, 5]
 let c = [6, 7, 8, 9]

 let result = [a, b, c].transposed()

 print(result) // [1, 4, 6, 2, 5, 7, 3, 8, 9]
 */
extension Collection where Self.Element: RandomAccessCollection {
    public func transposed() -> [Self.Element.Element] {
        guard let rowWithMaxElems = self.max(by: { $0.count < $1.count }) else { return [] }
        return rowWithMaxElems.indices.flatMap { index in
            self.compactMap { $0[safe: index] }
        }
    }
}

extension RandomAccessCollection {
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
