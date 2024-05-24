//
//  Post.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/24/24.
//  Copyright © 2024 TuistPracticeOne. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let title: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case createdAt
        case updatedAt
        case userId = "UserId"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.userId = try container.decode(Int.self, forKey: .userId)
    }
}
