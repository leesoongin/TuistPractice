//
//  Publisher+sinkIgnoreCompletion.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2/21/24.
//  Copyright © 2024 Swit. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    public func sinkIgnoreCompletion(to subject: any Subject<Output, Failure>,
                                     receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void = { _ in }) -> AnyCancellable {
        sink(receiveCompletion: receiveCompletion, receiveValue: { subject.send($0) })
    }
}
