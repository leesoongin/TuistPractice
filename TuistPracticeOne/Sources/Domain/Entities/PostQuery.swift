//
//  PostQuery.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/24/24.
//  Copyright © 2024 TuistPracticeOne. All rights reserved.
//

import Foundation
import Alamofire

struct PostQuery: Encodable {
    //TODO: toParameters 는 추후 Query struct 에 사용될 Protocol 정의
    func toParameters() -> Parameters {
        return [:]
    }
}
