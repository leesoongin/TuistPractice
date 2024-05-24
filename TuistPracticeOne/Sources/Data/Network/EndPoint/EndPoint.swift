//
//  EndPoint.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/24/24.
//  Copyright © 2024 TuistPracticeOne. All rights reserved.
//

import Foundation

protocol PathMakeable {
    var path: String { get }
}

enum EndPoint { }

extension EndPoint {
    enum User: PathMakeable {
        case createUser
        case fetchUsers
        case fetchUserByID
        case userEdit
        case userDelete
        
        var path: String {
            switch self {
            case .fetchUsers:
                return "/users"
            case .createUser:
                return ""
            case .fetchUserByID:
                return ""
            case .userEdit:
                return ""
            case .userDelete:
                return ""
            }
        }
    }
    
    enum Post: PathMakeable {
        case createPost
        case fetchPosts
        case fetchPostByID
        case postEdit
        case postDelete
        
        var path: String {
            switch self {
            case .createPost:
                return ""
            case .fetchPosts:
                return "/posts"
            case .fetchPostByID:
                return ""
            case .postEdit:
                return ""
            case .postDelete:
                return ""
            }
        }
    }
}
