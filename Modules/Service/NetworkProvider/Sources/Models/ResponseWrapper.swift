//
//  ResponseWrapper.swift
//  SwitNetwork
//
//  Created by Ren Shin on 2023/10/19.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

// API에서 내려주는 데이터는 data외에 code와 version등 추가로 내려오는게 있어 이걸 분리 하기 위한 wrapper
// 이를 decode(from:)에서 한번 정제하여 전달한다
public struct ResponseWrapper<ResponseType: Decodable>: Decodable {
    public let code: Int
    public let timestamp: String?
    public let data: ResponseType?
    public let message: String?
}
