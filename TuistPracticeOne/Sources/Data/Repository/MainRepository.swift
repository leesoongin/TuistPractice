//
//  MainRepository.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/24/24.
//  Copyright © 2024 TuistPracticeOne. All rights reserved.
//

import Foundation
import Combine
import NetworkProvider

protocol KoreanJsonManagable {
    func fetchPosts() -> AnyPublisher<[Post], Error>
}

final class KoreanJsonRepository: KoreanJsonManagable {
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        // fetch 해온 데이터를 Convert, 저장할 데이터가 존재한다면 저장 로직 구현
        PostsRequestBuilder(PostQuery()).request()
        PostsRequestBuilder(PostQuery()).defaultRequest(debug: <#T##Bool#>)
    }
    
    func fetchMockPosts() -> AnyPublisher<[Post], Error> {
        PostsRequestBuilder(PostQuery()).mockRequest(from: "json string 을 입력")
    }
}
