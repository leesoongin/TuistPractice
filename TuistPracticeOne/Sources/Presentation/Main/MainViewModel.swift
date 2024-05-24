//
//  MainViewModel.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/24/24.
//  Copyright © 2024 TuistPracticeOne. All rights reserved.
//

import Foundation
import Combine
import CombineExt

final class MainViewModel {
    var cancellables = Set<AnyCancellable>()
    let repository: KoreanJsonManagable = KoreanJsonRepository()
    
    private let posts = CurrentValueSubject<[Post], Never>([])
    var postsPublisher: AnyPublisher<[Post], Never> {
        posts.eraseToAnyPublisher()
    }
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> { errorSubject.eraseToAnyPublisher() }
    
    func fetchPosts() {
        let publisher = repository.fetchPosts().share().materialize()
        
        publisher.values()
            .sink { [weak self] posts in
                self?.posts.send(posts)
            }
            .store(in: &cancellables)
        
        publisher.failures()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] error in
                self?.errorSubject.send(error)
            })
            .store(in: &cancellables)
    }
}
