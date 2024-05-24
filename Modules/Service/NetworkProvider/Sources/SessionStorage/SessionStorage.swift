//
//  SessionStorage.swift
//  SwitNetwork
//
//  Created by Ren Shin on 2023/10/22.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Alamofire

public struct SessionStorage {
    public static let defaultSesssion = Session(configuration: AdapterManager.shared.adapter.sessionConfiguration,
                                                interceptor: AdapterManager.shared.adapter.retryInterceptor)

    public static let middleTimeIntervalSession = Session(configuration: AdapterManager.shared.adapter.middleTimeIntervalSessionConfiguration,
                                                          interceptor: AdapterManager.shared.adapter.retryInterceptor)

    public static let longTimeIntervalSession = Session(configuration: AdapterManager.shared.adapter.longTimeIntervalSessionConfiguration,
                                                        interceptor: AdapterManager.shared.adapter.retryInterceptor)
}
