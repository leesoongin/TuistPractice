//
//  URLResolver.swift
//  SwitNetwork
//
//  Created by Ren Shin on 2023/10/19.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

final class URLResolver {
    static let shared = URLResolver()

    var defaultAPIServer: String { AdapterManager.shared.adapter.defaultBaseURL }
}
