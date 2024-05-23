//
//  RequestBuilder.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/23/24.
//

import Foundation
import Combine

public protocol RequestBuilder: CoreRequestBuilder {
    var needsRefreshToken: Bool { get }
}

// MARK: - Public Default Properties
extension RequestBuilder {
    public var header: HTTPHeaders? { AdapterManager.shared.adapter.defaultHeader }
    public var baseURL: String { URLResolver.shared.defaultAPIServer }
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
            self.requestPreprocessing()
                .flatMap {
                    self.defaultRequest(debug: debug)
                }
        }
        .catch { error in
            self.preventEmitIfNeeded(from: error)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    public func defaultDecode(from data: Data) throws -> ResponseType {
//        if let decoded = try? jsonDecoder().decode(ResponseWrapper<EmptyResponseType>.self, from: data) {
//            if let error = AdapterManager.shared.adapter.convertError(from: decoded.code) {
//                AdapterManager.shared.adapter.handleNetworkError(error: error, data: data)
//                throw error
//            }
//        }

        return try decode(from: data)
    }

    public func decode(from data: Data) throws -> ResponseType {
        let decoded = try jsonDecoder().decode(ResponseWrapper<ResponseType>.self, from: data)

        if let data = decoded.data {
            return data
        } else {
            throw CommonNetworkError.invalidResponse
        }
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
