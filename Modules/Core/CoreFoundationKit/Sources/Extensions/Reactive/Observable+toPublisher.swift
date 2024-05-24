//
//  Observable+toPublisher.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/07/21.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Combine
//import RxSwift

//extension Observable {
//    public func toPublisher() -> AnyPublisher<Element, Never> {
//        let subject = PassthroughSubject<Element, Never>()
//
//        let disposable = subscribe(onNext: { element in
//            subject.send(element)
//        })
//
//        return subject
//            .handleEvents(receiveCancel: {
//                disposable.dispose()
//            })
//            .eraseToAnyPublisher()
//    }
//}
