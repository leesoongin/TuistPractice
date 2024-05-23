//
//  Config.swift
//  Packages
//
//  Created by 이숭인 on 5/22/24.
//

import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("Plugins/MyPlugin"))
    ]
)

