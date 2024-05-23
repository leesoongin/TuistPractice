//
//  DecodableDataStreamEvent.swift
//  Swit-iOS
//
//  Created by Leo on 2023/12/12.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

public struct DecodableDataStreamEvent<T: Decodable> {
    public var id: String?
    public var event: String?
    public var data: T?
}
