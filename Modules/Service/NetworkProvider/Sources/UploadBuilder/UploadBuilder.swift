//
//  UploadBuilder.swift
//  SwitNetwork
//
//  Created by Ren Shin on 2023/10/23.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Combine
import CoreNetwork

public protocol UploadBuilder: CoreUploadBuilder {
    /**
     API request 전에 처리할 로직.
     기본적으로는 refreshToken을 하지만, additionalHeader에 HeaderKey.xtoken가 존재한다면 하지 않음.
     더불어 임의로 refreshToken을 하고 싶지 않다면 이 함수를 아래와 같이 구현하면 된다.
     public func uploadPreprocessing() -> AnyPublisher<Void, Never> {
     Just(Void()).eraseToAnyPublisher()
     }
     */
    func uploadPreprocessing() -> AnyPublisher<Void, Never>
}

// MARK: - Public Default Properties
extension UploadBuilder {
    public var header: HTTPHeaders? { AdapterManager.shared.adapter.defaultHeader }
    public var baseURL: String { URLResolver.shared.defaultAPIServer }
}

// MARK: - session
extension UploadBuilder {
    public func networkSession() -> Session {
        SessionStorage.longTimeIntervalSession
    }
}

// MARK: - upload
extension UploadBuilder {
    public func upload(debug: Bool = false, progressHandler: ((Double) -> Void)? = nil) -> AnyPublisher<ResponseType, Error> {
        return Deferred {
            self.uploadPreprocessing()
                .flatMap {
                    self.defaultUpload(debug: debug, progressHandler: progressHandler)
                }
        }
        .catch { error in
            self.preventEmitIfNeeded(from: error)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    public func uploadPreprocessing() -> AnyPublisher<Void, Never> {
        AdapterManager.shared.adapter.refreshTokenIfNeeded(with: header)
    }

    public func defaultDecode(from data: Data) throws -> ResponseType {
        if let decoded = try? jsonDecoder().decode(ResponseWrapper<EmptyResponseType>.self, from: data) {
            if let error = AdapterManager.shared.adapter.convertError(from: decoded.code) {
                AdapterManager.shared.adapter.handleNetworkError(error: error, data: data)
                throw error
            }
        }

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

// MARK: - Private Method
extension UploadBuilder {
    private func preventEmitIfNeeded(from error: Error) -> AnyPublisher<ResponseType, Error> {
        switch AdapterManager.shared.adapter.isPreventEmit(from: error) {
        case .passthrough:
            return Fail(error: error).eraseToAnyPublisher()
        case .stopPropagation:
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
    }
}
