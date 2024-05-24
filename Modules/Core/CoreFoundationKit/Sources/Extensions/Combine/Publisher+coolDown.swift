//
//  Publisher+coolDown.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/09/04.
//  Copyright © 2023 Swit. All rights reserved.
//

import Combine

extension Publisher {
    public func coolDown<S: Scheduler>(for cooltime: S.SchedulerTimeType.Stride,
                                       scheduler: S) -> some Publisher<Self.Output, Self.Failure> {
        return self.receive(on: scheduler)
            .scan((S.SchedulerTimeType?.none, Self.Output?.none)) {
                let eventTime = scheduler.now
                let minimumTolerance = scheduler.minimumTolerance
                guard let lastSentTime = $0.0 else {
                    return (eventTime, $1)
                }

                let diff = lastSentTime.distance(to: eventTime)

                guard diff >= (cooltime - minimumTolerance) else {
                    return (lastSentTime, nil)
                }

                return (eventTime, $1)
            }
            .compactMap { $0.1 }
    }
}
