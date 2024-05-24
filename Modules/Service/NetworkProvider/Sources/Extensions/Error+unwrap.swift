//
//  Error+unwrap.swift
//  Swit-iOS
//
//  Created by Leo on 2024/03/17.
//  Copyright © 2024 Swit. All rights reserved.
//

import Foundation
import Alamofire

extension Error {
    public func unwrapIfWrappedByRetry() -> Error {
        guard let error = self.asAFError else { return self }
        guard error.isRequestRetryError else { return self }

        switch error {
        case .requestRetryFailed(_, let originalError):
            return originalError.unwrapIfWrappedByRetry()
        default:
            return error
        }
    }
}
