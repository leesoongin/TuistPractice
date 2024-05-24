//
//  PostsRequestBuilder.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/24/24.
//  Copyright © 2024 TuistPracticeOne. All rights reserved.
//

import Foundation
import NetworkProvider

class PostsRequestBuilder: RequestBuilder {
    typealias ResponseType = [Post]
    
    let method: HTTPMethod = .get
    let baseURL: String = APIConstant.defaultBase
    let path: String = EndPoint.Post.fetchPosts.path
    let parameters: Parameters?

    init(_ paramater: PostQuery) {
        self.parameters = paramater.toParameters()
    }
}
