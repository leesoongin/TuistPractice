//
//  SwitNetworkAdapterType.swift
//  SwitNetwork
//
//  Created by Ren Shin on 2023/10/19.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Combine
import CoreNetwork
import Alamofire

public protocol SwitNetworkAdapterType {
    var sessionConfiguration: URLSessionConfiguration { get }
    var middleTimeIntervalSessionConfiguration: URLSessionConfiguration { get }
    var longTimeIntervalSessionConfiguration: URLSessionConfiguration { get }
    var retryInterceptor: RequestInterceptor { get }

    var defaultHeader: HTTPHeaders { get }
    var defaultBaseURL: String { get }

    func refreshTokenIfNeeded(with header: HTTPHeaders?) -> AnyPublisher<Void, Never>

    func convertError(from code: Int) -> Error?
    func handleNetworkError(error: Error, data: Data)
    func isPreventEmit(from error: Error) -> ErrorHandlingStrategy
}

typealias AdapterManager = SwitNetworkAdapterManager
public final class SwitNetworkAdapterManager {
    public static let shared = SwitNetworkAdapterManager()
    public var adapter: SwitNetworkAdapterType!
}
