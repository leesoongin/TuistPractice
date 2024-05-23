//
//  Project+AppTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 5/23/24.
//

import ProjectDescription
import MyPlugin

extension Project {
    static func makeAppTargets(name: String,
                               bundleIdentifier: String,
                               deploymentTargetVersion: String,
                               destinations: Destinations) -> [Target] {
        let mainTarget = Target.target(name: name,
                                       destinations: destinations,
                                       product: .app,
                                       bundleId: bundleIdentifier,
                                       deploymentTargets: .iOS(deploymentTargetVersion),
                                       infoPlist: makeAppInfoPlist(),
                                       sources: ["TuistPracticeOne/Sources/**"],
                                       resources: ["TuistPracticeOne/Resources/**"],
                                       dependencies: [.external(name: "Alamofire")])
        
        return [mainTarget]
    }
}
