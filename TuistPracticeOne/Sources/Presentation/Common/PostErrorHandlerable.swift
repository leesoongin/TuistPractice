//
//  PostErrorHandlerable.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/24/24.
//  Copyright © 2024 TuistPracticeOne. All rights reserved.
//

import UIKit
import Combine

// 공통 에러 처리를 위한 인터페이스 일수도, 기능단위의 에러처리를 위한 인터페이스 일 수도 있음
protocol PostErrorHandlerable where Self: UIViewController {
    var cancellables: Set<AnyCancellable> { get set }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    func bindErrorHandler()
    func presentErrorPopup(with error: Error)
}

extension PostErrorHandlerable {
    func bindErrorHandler() {
        errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                do {
                    //TODO: 에러 타입을 통해 처리할지, 무시할지 check
                    // try ~~~
                } catch {
                    //TODO: error popup present or ???
                    self?.presentErrorPopup(with: error)
                }
            }
            .store(in: &cancellables)
    }
    
    func presentErrorPopup(with error: Error) {
        //TODO: error popup present
    }
}
