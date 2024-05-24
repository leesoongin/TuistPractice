//
//  RxSwift+FilterNil.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/21.
//  Copyright © 2023 Swit. All rights reserved.
//

//import RxSwift
//import RxCocoa

//public extension ObservableType where Element: OptionalType {
//    func filterNil() -> Observable<Element.Wrapped> {
//        return flatMap { (element) -> Observable<Element.Wrapped> in
//            if let value = element.value {
//                return .just(value)
//            } else {
//                return .empty()
//            }
//        }
//    }
//}

//public extension Signal where Element: OptionalType {
//    func filterNil() -> Signal<Element.Wrapped> {
//        return flatMap { (element) -> Signal<Element.Wrapped> in
//            if let value = element.value {
//                return .just(value)
//            } else {
//                return .empty()
//            }
//        }
//    }
//}

//public extension Driver where Element: OptionalType {
//    func filterNil() -> Driver<Element.Wrapped> {
//        return flatMap { (element) -> Driver<Element.Wrapped> in
//            if let value = element.value {
//                return .just(value)
//            } else {
//                return .empty()
//            }
//        }
//    }
//}
