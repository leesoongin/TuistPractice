//
//  NetworkAdapter.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/24/24.
//  Copyright © 2024 TuistPracticeOne. All rights reserved.
//

import Foundation
import NetworkProvider
import Alamofire
import Combine

struct NetworkAdapter: SwitNetworkAdapterType {
    var defaultBaseURL: String { "https://koreanjson.com" }
    
    func refreshTokenIfNeeded(with header: Alamofire.HTTPHeaders?) -> AnyPublisher<Void, Never> {
        //TODO: Token 관련 로직은 추후 구현
        Just(Void()).eraseToAnyPublisher()
    }
    
    func convertError(from code: Int) -> Error? {
        return nil
    }
    
    func handleNetworkError(error: Error, data: Data) {
        //TODO: error handling 로직 추후 구현
    }
    
    /// 위에서 이미 handling한 error중 실제 호출한 곳까지 emit할 필요가 없는 error들은 emit을 막는다
    func isPreventEmit(from error: Error) -> NetworkProvider.ErrorHandlingStrategy {
        //TODO: error handling 로직 추후 구현
        return .passthrough
    }
    
    var sessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.urlCache = URLCache.shared
        return configuration
    }

    var middleTimeIntervalSessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 35
        configuration.urlCache = URLCache.shared
        return configuration
    }

    var longTimeIntervalSessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 110
        configuration.urlCache = URLCache.shared
        return configuration
    }

    var retryInterceptor: RequestInterceptor {
        RetryInterceptor(retryLimit: 3, retryDelay: 1.0)
    }

    var defaultHeader: HTTPHeaders {
        /// header 에 필요한 값이 존재할 경우, 딕셔너리 주입
        return setupHTTPHeaders(headers: [:])
    }
}

extension NetworkAdapter {
    // MARK: - http headers
    private func setupHTTPHeaders(headers: [String: String]) -> HTTPHeaders {
        var headers = headers
        guard headers.isEmpty == false else {
            return HTTPHeaders.default
        }
        
        let dummyValue: String = headers[HeaderKey.dummyKey] ?? ""
        headers.updateValue(dummyValue, forKey: HeaderKey.dummyKey)
        return HTTPHeaders(headers)
    }
}

enum HeaderKey {
    static let dummyKey = "dummyValue"
}

final class RetryInterceptor: RequestInterceptor {
    private let retryLimit: Int
    private let retryDelay: TimeInterval

    init(retryLimit: Int, retryDelay: TimeInterval) {
        self.retryLimit = retryLimit
        self.retryDelay = retryDelay
    }

    func retry(_ request: Request, for _: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        var retries = 0

        guard let response = request.task?.response as? HTTPURLResponse else {
            // 재시도 할 필요가 없는 경우 실패 처리
            completion(.doNotRetryWithError(error))
            return
        }

        if let dataRequest = request as? DataRequest {
            // 재시도 횟수가 지정한 횟수보다 작을 경우 재시도
            if retries < retryLimit {
                retries += 1
                dataRequest.resume()
                completion(.retryWithDelay(retryDelay)) // 재시도 딜레이 설정
            } else {
                completion(.doNotRetryWithError(error))
            }
        } else {
            completion(.doNotRetryWithError(error))
        }
    }
}
