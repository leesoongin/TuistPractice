//
//  String+Extension+toLinkUrls.swift
//  CoreFoundationKit
//
//  Created by Charles Choi on 3/6/24.
//  Copyright © 2024 Swit. All rights reserved.
//

import Foundation

extension String {
    public func extractLinkURLs(_ attributeString: NSAttributedString? = nil) -> ([URL], [NSRange]) {
        var linkUrls: [URL] = []
        var linkRanges: [NSRange] = []

        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let attr = attributeString {
                attr.enumerateAttributes(in: NSRange(location: 0, length: (attr.string as NSString).length), options: []) { _, range, _ in
                    detector.enumerateMatches(in: attr.string, options: [], range: range, using: { result, _, _ in
                        if let match = result, let url = match.url {
                            linkUrls.append(url)
                            linkRanges.append(match.range)
                        }
                        return
                    })
                }
            }
        } catch let error as NSError {
            Log.error(error.localizedDescription)
        }
        return (linkUrls, linkRanges)
    }

    public func extranctRtLinkURLs(_ attributeString: NSAttributedString? = nil, tappedOffset: Int) -> (URL?, [NSRange]?) {
        var linkUrl: URL?
        var linkRange: [NSRange] = []

        if let attr = attributeString {
            attr.enumerateAttributes(in: NSRange(location: 0, length: (attr.string as NSString).length), options: []) { att, range, _ in
                if att[NSAttributedString.Key.link] != nil {
                    if range.location <= tappedOffset &&
                        tappedOffset <= (range.location + range.length) {
                        if let url = att[NSAttributedString.Key.link].value as? URL {
                            linkUrl = url
                            linkRange.append(range)
                            return
                        }

                        if let linkPath = att[NSAttributedString.Key.link].value as? String {
                            if let url = URL(from: linkPath) {
                                linkUrl = url
                                linkRange.append(range)
                                return
                            }
                        }
                    }
                }
            }

            attr.enumerateAttributes(in: NSRange(location: 0, length: (attr.string as NSString).length), options: []) { att, range, _ in
                if att[NSAttributedString.Key.link] != nil {
                    if att[NSAttributedString.Key.link].value as? URL != nil,
                       linkUrl != nil,
                       att[NSAttributedString.Key.link].value as? URL == linkUrl,
                       linkRange.contains(range) == false {
                        linkRange.append(range)
                    }

                    if att[NSAttributedString.Key.link].value as? String != nil,
                       linkUrl != nil,
                       att[NSAttributedString.Key.link].value as? String == linkUrl?.absoluteString,
                       linkRange.contains(range) == false {
                        linkRange.append(range)
                    }
                }
            }
        }

        return (linkUrl, linkRange)
    }
}
