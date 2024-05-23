import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project.app(name: "TuistPracticeOne",
                          targets: Module.allModules)

//let project = Project(
//    name: "TuistPracticeOne",
//    settings: .settings(defaultSettings: .recommended),
//    targets: [
//        .target(
//            name: "TuistPracticeOne",
//            destinations: .iOS,
//            product: .app,
//            bundleId: "io.tuist.TuistPracticeOne",
//            deploymentTargets: .iOS("15.1"),
//            infoPlist: .extendingDefault(
//                with: [
//                    "CFBundleShortVersionString": "1.0",
//                    "CFBundleVersion": "1",
//                    "UILaunchStoryboardName": "LaunchScreen",
//                ]
//            ),
//            sources: ["TuistPracticeOne/Sources/**"],
//            resources: ["TuistPracticeOne/Resources/**"],
//            dependencies: [
////                .external(name: "Alamofire")
//                TargetDependency.target(name: "Alamofire")
//            ]
//        ),
//        .target(name: "CoreNetwork",
//                destinations: [.iPhone],
//                product: .framework,
//                bundleId: "io.tuist.CoreNetwork",
//                deploymentTargets: .iOS("15.1"),
//                infoPlist: .default,
//                sources: ["Modules/Core/CoreNetwork/Sources/**"],
////                sources: [.glob("Modules/Core/CoreNetwork/Sources/**", excluding: "Modules/Core/CoreNetwork/")],
//                resources: .resources([]),
//                headers: Headers.headers(public: ["Modules/Core/CoreNetwork/Sources/**/*.h"]),
//                dependencies: [],
//                settings: makeDefaultSettings())
//        
//        
////        .target(name: module.name,
////                destinations: destinations,
////                product: hasDynamicFramework ? .framework : .staticFramework,
////                bundleId: "\(bundleIdentifier).\(module.name)",
////                deploymentTargets: .iOS(deploymentTargetVersion),
////                infoPlist: module.frameworkInfoPlist,
////                sources: [.glob("\(module.path)/Sources/**", excluding: frameworkExcludingSourcePaths)],
////                resources: .resources(frameworkResourceFilePaths),
////                headers: headers,
////                dependencies: module.frameworkDependencies,
////                settings: module.frameworkSettings)
////
//    ]
//)
