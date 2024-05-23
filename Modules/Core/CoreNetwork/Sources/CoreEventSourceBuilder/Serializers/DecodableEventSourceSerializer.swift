//
//  DecodableEventSourceSerializer.swift
//  Swit-iOS
//
//  Created by Leo on 2023/12/12.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Alamofire

public final class DecodableEventSourceSerializer<T: Decodable>: DataStreamSerializer {
    private let decoder: DataDecoder
    private let serializer: DefaultDataStreamSerializer

    public init(decoder: DataDecoder = JSONDecoder()) {
        self.decoder = decoder
        self.serializer = DefaultDataStreamSerializer()
    }

    public func serialize(_ data: Data) throws -> [DecodableDataStreamEvent<T>] {
        try checkError(with: data)

        return try serializer.serialize(data).map { event in
            let convertedData = try event.data?.data(using: .utf8).flatMap {
                do {
                    return try decoder.decode(T.self, from: $0)
                } catch {
                    let streamError = try decoder.decode(DataStreamErrorData.self, from: $0)
                    throw StreamDataError.error(code: streamError.code, message: streamError.message)
                }
            }
            return DecodableDataStreamEvent(id: event.id,
                                            event: event.event,
                                            data: convertedData)
        }
    }
}

extension DecodableEventSourceSerializer {
    fileprivate struct DataStreamErrorData: Decodable {
        var code: Int
        var message: String?
    }

    fileprivate func checkError(with data: Data) throws {
        guard let response = try? decoder.decode(DataStreamErrorData.self, from: data) else { return }
        guard (200..<300).contains(response.code) == false else { return }
        throw StreamDataError.error(code: response.code, message: response.message)
    }
}
