//
//  RequestBuilder.swift
//  SwitNetwork
//
//  Created by Ren Shin on 2023/10/19.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Combine
import CoreNetwork

public protocol RequestBuilder: CoreRequestBuilder {
    var needsRefreshToken: Bool { get }
}

// MARK: - Public Default Properties
extension RequestBuilder {
    public var header: HTTPHeaders? { AdapterManager.shared.adapter.defaultHeader }
    public var baseURL: String { AdapterManager.shared.adapter.defaultBaseURL }
    public var needsRefreshToken: Bool { true }
}

// MARK: - session
extension RequestBuilder {
    public func networkSession() -> Session {
        SessionStorage.defaultSesssion
    }
}

// MARK: - request
extension RequestBuilder {
    public func request(debug: Bool = false) -> AnyPublisher<ResponseType, Error> {
        return Deferred {
            // TODO: Refresh Token 체크 후, 필요한 경우 Token Refresh
            self.defaultRequest(debug: debug)
        }
        .catch { error in
            //TODO: Error Handling
            Fail(error: error).eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    public func defaultDecode(from data: Data) throws -> ResponseType {
        //TODO: Empty Response Type 처리 로직 추가
        return try decode(from: data)
    }

    public func decode(from data: Data) throws -> ResponseType {
        let decodedResponse = try jsonDecoder().decode(ResponseType.self, from: data)
        return decodedResponse
    }
}

// MARK: - mockRequest
extension RequestBuilder {
    public func mockRequest(from string: String) -> AnyPublisher<ResponseType, Error> {
        defaultMockRequest(from: string)
            .catch { error in
                self.preventEmitIfNeeded(from: error)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private Method
extension RequestBuilder {
    private func requestPreprocessing() -> AnyPublisher<Void, Never> {
        if needsRefreshToken {
            return AdapterManager.shared.adapter.refreshTokenIfNeeded(with: header)
        } else {
            return Just(Void()).eraseToAnyPublisher()
        }
    }

    private func preventEmitIfNeeded(from error: Error) -> AnyPublisher<ResponseType, Error> {
        switch AdapterManager.shared.adapter.isPreventEmit(from: error) {
        case .passthrough:
            return Fail(error: error).eraseToAnyPublisher()
        case .stopPropagation:
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
    }
}
