//
//  TuistPracticeOne.swift
//  Packages
//
//  Created by 이숭인 on 5/22/24.
//

import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Custom Template",
    attributes: [nameAttribute, .optional("platform", default: "iOS")],
    items: [
        .file(path: "TuistPracticeOne/Sources/AppDelegate.swift",
              templatePath: "AppDelegate.stencil"),
        .file(path: "TuistPracticeOne/Sources/LaunchScreen.storyboard",
              templatePath: "LaunchScreen.stencil"),
    ]
)
