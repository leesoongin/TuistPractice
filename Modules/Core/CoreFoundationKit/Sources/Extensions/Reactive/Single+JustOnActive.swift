//
//  Single+JustOnActive.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/06/25.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa
//import RxSwiftExt

//extension PrimitiveSequenceType where Trait == SingleTrait {
    /// application state가 active 라면 바로 emit하고, 그렇지 않으면 active까지 기다렸다가 emit하는 just
//    public static func justOnActive(_ element: Element) -> Single<Element> {
//        Single.just(UIApplication.shared.applicationState)
//            .subscribe(on: ConcurrentMainScheduler.instance)
//            .flatMap { state in
//                if state == .active {
//                    return .just(element)
//                } else {
//                    return NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
//                        .asSingleSafely()
//                        .mapTo(element)
//                }
//            }
//    }
//}
