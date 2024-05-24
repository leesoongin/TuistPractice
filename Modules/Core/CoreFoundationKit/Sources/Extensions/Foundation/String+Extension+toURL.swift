//
//  String+Extension+toURL.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/06/09.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation

extension String {
    public var toURL: URL? {
        if !isEscaped(), let encoded = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: encoded)
        } else {
            return URL(string: self)
        }
    }

    public func toFragmentURL(with fragment: String) -> URL? {
        if let url = self.toURL, var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.fragment = fragment
            return components.url
        } else {
            return self.toURL
        }
    }

    private func isEscaped() -> Bool {
        removingPercentEncoding != self
    }
}
