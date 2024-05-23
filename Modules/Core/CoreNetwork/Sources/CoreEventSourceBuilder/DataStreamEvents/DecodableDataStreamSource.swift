//
//  DecodableDataStreamSource.swift
//  Swit-iOS
//
//  Created by Leo on 2023/12/19.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Alamofire

public struct DecodableDataStreamSource<T: Decodable> {
    public let event: DecodableEvent<T>

    public let token: DataStreamRequest.CancellationToken

    public func cancel() {
        token.cancel()
    }

    public enum DecodableEvent<U: Decodable> {

        case message(DecodableDataStreamEvent<U>)

        case complete(DataStreamRequest.Completion)

    }
}
