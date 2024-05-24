//
//  Project+FrameworkTarget.swift
//  Templates
//
//  Created by 이숭인 on 5/23/24.
//

import ProjectDescription
import MyPlugin

extension Project {    
    static func makeFrameworkTargets(module: Module,
                                     bundleIdentifier: String,
                                     deploymentTargetVersion: String,
                                     destinations: Destinations) -> Target? {
        guard module.targetProducts.contains(where: { $0.isFramework }) else { return nil }
        
        let hasDynamicFramework = module.targetProducts.contains(where: { $0.hasDynamicFramework })
        let headers = Headers.headers(public: "\(module.path)/Sources/**/*.h")
        
        let frameworkTarget = Target.target(name: module.name,
                                            destinations: destinations,
                                            product: hasDynamicFramework ? .framework : .staticFramework,
                                            bundleId: "\(bundleIdentifier).\(module.name)",
                                            deploymentTargets: .iOS(deploymentTargetVersion),
                                            sources: ["\(module.path)/Sources/**"],
                                            resources: .resources([]),
                                            headers: headers,
                                            dependencies: module.frameworkDependencies,
                                            settings: module.frameworkSettings)
        
        return frameworkTarget
    }
}
