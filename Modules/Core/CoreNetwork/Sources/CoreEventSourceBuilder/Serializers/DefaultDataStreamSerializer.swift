//
//  DefaultDataStreamSerializer.swift
//  Swit-iOS
//
//  Created by Leo on 2023/12/12.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Alamofire

public final class DefaultDataStreamSerializer: DataStreamSerializer {
    let validNewlineCharacters: [String] = ["\r\n", "\n", "\r"]
    private var dataBuffer: Data = Data()

    var currentBuffer: String? {
        return String(data: dataBuffer as Data, encoding: .utf8)
    }

    public func serialize(_ data: Data) throws -> [DataStreamEvent] {
        dataBuffer.append(data)
        return extractEventsFromBuffer().compactMap { return DataStreamEvent.init(parsing: $0) }
    }

    private func extractEventsFromBuffer() -> [String] {
        var messages = [String]()
        var searchRange: Range<Data.Index> = dataBuffer.startIndex..<dataBuffer.endIndex

        while let delimiterRange = searchFirstEventDelimiter(in: searchRange) {
            let dataChunk = dataBuffer.subdata(in: searchRange.startIndex..<delimiterRange.endIndex)

            if let message = String(bytes: dataChunk, encoding: .utf8) {
                messages.append(message)
            }

            searchRange = delimiterRange.endIndex..<dataBuffer.endIndex
        }

        dataBuffer.removeSubrange(dataBuffer.startIndex..<searchRange.endIndex)

        return messages
    }

    private func searchFirstEventDelimiter(in range: Range<Data.Index>) -> Range<Data.Index>? {
        let delimiters: [Data] = validNewlineCharacters.compactMap { "\($0)\($0)".data(using: .utf8) }
        for delimiter in delimiters {
            if let foundRange = dataBuffer.range(of: delimiter, in: range) {
                return foundRange
            }
        }
        return nil
    }
}
