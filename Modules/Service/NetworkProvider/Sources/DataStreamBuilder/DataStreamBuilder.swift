//
//  DataStreamBuilder.swift
//  Swit-iOS
//
//  Created by Leo on 2023/12/18.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Combine
import CoreNetwork

public protocol DataStreamBuilder: CoreDataStreamBuilder {
    var needsRefreshToken: Bool { get }
}

// MARK: - Public Default Properties
extension DataStreamBuilder {
    public var header: HTTPHeaders? { AdapterManager.shared.adapter.defaultHeader }
    public var baseURL: String { "" }
    public var needsRefreshToken: Bool { true }
}

// MARK: - session
extension DataStreamBuilder {
    public func networkSession() -> Session {
        SessionStorage.longTimeIntervalSession
    }
}

// MARK: - request
extension DataStreamBuilder {
    public func request(debug: Bool) -> AnyPublisher<DecodableEventType, Error> {
        return Deferred {
            self.requestPreprocessing()
                .flatMap {
                    self.defaultDataStreamRequest()
                }
        }
        .catch { error in
            self.preventEmitIfNeeded(from: error)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

}

// MARK: - Private Method
extension DataStreamBuilder {
    private func requestPreprocessing() -> AnyPublisher<Void, Never> {
        if needsRefreshToken {
            return AdapterManager.shared.adapter.refreshTokenIfNeeded(with: header)
        } else {
            return Just(Void()).eraseToAnyPublisher()
        }
    }

    private func preventEmitIfNeeded(from error: Error) -> AnyPublisher<DecodableEventType, Error> {
        switch AdapterManager.shared.adapter.isPreventEmit(from: error) {
        case .passthrough:
            return Fail(error: error).eraseToAnyPublisher()
        case .stopPropagation:
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
    }
}
