//
//  DataStreamEvent.swift
//  Swit-iOS
//
//  Created by Leo on 2023/12/12.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

public struct DataStreamEvent {
    var id: String?
    var event: String?
    var data: String?
}

extension DataStreamEvent {
    internal init?(parsing eventString: String) {
        guard !eventString.hasPrefix(":") else {
            return nil
        }
        self = DataStreamEvent.parseEvent(eventString)
    }
}

extension DataStreamEvent {
    static func parseEvent(_ eventString: String) -> DataStreamEvent {
        var event = DataStreamEvent()
        let fields = eventString.components(separatedBy: .newlines).compactMap(Field.init(parsing:))

        for field in fields {
            switch field.key {
            case .id:
                event.id = field.value
            case .event:
                event.event = field.value
            case .data:
                event.data = field.value
            }
        }

        return event
    }
}

extension DataStreamEvent {

    internal struct Field {
        enum Key: String {
            case event
            case id
            case data
        }

        var key: Key
        var value: String

        init?(parsing string: String) {
            let scanner = Scanner(string: string)
            guard let key = scanner.scanUpToString(":").flatMap(Key.init(rawValue:)) else {
                return nil
            }

            _ = scanner.scanString(":")

            guard let value = scanner.scanUpToCharacters(from: .newlines) else {
                return nil
            }

            self.key = key
            self.value = value
        }
    }
}
