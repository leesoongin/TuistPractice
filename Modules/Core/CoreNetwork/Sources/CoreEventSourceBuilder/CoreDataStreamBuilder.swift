//
//  CoreDataStreamBuilder.swift
//  Swit-iOS
//
//  Created by Leo on 2023/12/12.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Combine
import Alamofire

public protocol CoreDataStreamBuilder: NetworkBuilder {
    typealias DecodableEventType = DecodableDataStreamSource<ResponseType>

    var lastEventID: String? { get }
    var serializer: DecodableEventSourceSerializer<ResponseType> { get }

    func request(debug: Bool) -> AnyPublisher<DecodableEventType, Error>
}

// MARK: Serializer
extension CoreDataStreamBuilder {
    public var serializer: DecodableEventSourceSerializer<ResponseType> {
        DecodableEventSourceSerializer()
    }
}

// MARK: Request
extension CoreDataStreamBuilder {
    public func request() -> AnyPublisher<DecodableEventType, Error> {
        return Deferred {
            self.defaultDataStreamRequest()
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    public func defaultDataStreamRequest() -> AnyPublisher<DecodableEventType, Error> {
        guard let convertedURL = createURL() else {
            return Fail(error: CommonNetworkError.invalidURL).eraseToAnyPublisher()
        }

        return createDataStreamRequest(url: convertedURL,
                                       on: DispatchQueue.main,
                                       serializer: serializer)
    }
}

// MARK: - Private Method
extension CoreDataStreamBuilder {
    private func createDataStreamRequest(url: URL,
                                         on queue: DispatchQueue,
                                         serializer: DecodableEventSourceSerializer<ResponseType>) -> AnyPublisher<DecodableEventType, Error> {
        #if DEBUG
//        Log.debug("Network -> URL(\(method.rawValue)) : \(url)")
//        Log.debug("Network -> request header : \(String(describing: createDefaultHeader()))")
//        Log.debug("Network -> parameters : \(String(describing: parameters))")
        #endif

        let passthroughSubject = PassthroughSubject<DecodableEventType, Error>()
        let request: DataStreamRequest = createDataStreamRequest(url: url)

        request.responseStream(using: serializer, on: queue) { stream in
            if let error = stream.error {
                passthroughSubject.send(completion: .failure(error))
                return
            }

            switch stream.event {
            case .stream(let result):

                switch result {
                case .success(let messages):
                    for message in messages {
                        passthroughSubject.send(DecodableDataStreamSource(event: .message(message), token: stream.token))
                    }
                case .failure(let error):
                    passthroughSubject.send(completion: .failure(error))
                }

            case .complete(let completion):
                if let error = request.error {
                    switch error {
                    case .requestRetryFailed(_, let originalError):
                        passthroughSubject.send(completion: .failure(originalError))
                    default:
                        passthroughSubject.send(completion: .failure(error))
                    }
                    return
                }

                passthroughSubject.send(DecodableDataStreamSource(event: .complete(completion), token: stream.token))
                passthroughSubject.send(completion: .finished)
            }
        }

        return passthroughSubject.eraseToAnyPublisher()
    }

    private func createDataStreamRequest(url: URL) -> DataStreamRequest {
        return networkSession().streamRequest(url) { request in
            self.createDefaultHeader().makeIterator().forEach { header in
                request.headers.add(header)
            }

            request.method = self.method

            if request.method == .post {
                request.httpBody = try? JSONSerialization.data(withJSONObject: self.parameters ?? [:])
            }
        }
    }
}

// MARK: - decode
extension CoreDataStreamBuilder {
    // !!!: not used
    public func defaultDecode(from data: Data) throws -> ResponseType {
        throw CommonNetworkError.unknown
    }
}

// MARK: - HTTP Headers
extension CoreDataStreamBuilder {
    func createDefaultHeader() -> HTTPHeaders {
        var defaultHeader: HTTPHeaders = .default

        header?.makeIterator().forEach { defaultHeader.update($0) }

        additionalHeader?.forEach { (key, value) in
            defaultHeader.update(name: key, value: value)
        }

        defaultHeader.update(name: "Accept", value: "text/event-stream")
        defaultHeader.update(name: "Cache-Control", value: "no-cache")
        defaultHeader.update(name: "Content-Type", value: "application/json")
        if let lastEventID = lastEventID {
            defaultHeader.update(name: "Last-Event-ID", value: lastEventID)
        }

        return defaultHeader
    }
}
