//
//  ModuleInfo.swift
//  MyPlugin
//
//  Created by 이숭인 on 5/23/24.
//

import ProjectDescription

public protocol ModuleInfoType: CaseIterable {
    var rawValue: String { get }
    var path: String { get }
}

public extension TargetDependency {
    static let CoreNetwork = TargetDependency.target(name: "CoreNetwork")
    static let NetworkProvider = TargetDependency.target(name: "NetworkProvider")
    static let CoreFoundationKit = TargetDependency.target(name: "CoreFoundationKit")
    static let ThirdPartyLibrary = TargetDependency.target(name: "ThirdPartyLibrary")
}

public struct ModuleInfo {
    //MARK: - Common
    enum Common: String, ModuleInfoType {
        case ThirdPartyLibrary
        
        var path: String { "Modules/Common/\(self.rawValue)" }
    }
    
    //MARK: - Core
    enum Core: String, ModuleInfoType {
        case CoreNetwork
        case CoreFoundationKit
        
        var path: String { "Modules/Core/\(rawValue)" }
    }
    
    //MARK: - Service
    enum Service: String, ModuleInfoType {
        case NetworkProvider
        
        var path: String { "Modules/Service/\(self.rawValue)" }
    }
}

//MARK: - Modules
extension Module {
    static var ThirdPartyLibrary: Module {
        Module(name: ModuleInfo.Common.ThirdPartyLibrary.rawValue,
               path: ModuleInfo.Common.ThirdPartyLibrary.path,
               frameworkDependencies: TargetDependency.SPM.all,
        frameworkSettings: makeThirdPartySettings())
    }
    
    static var CoreNetwork: Module {
        Module(name: ModuleInfo.Core.CoreNetwork.rawValue,
               path: ModuleInfo.Core.CoreNetwork.path,
        frameworkDependencies: [
            .ThirdPartyLibrary
        ])
    }
    
    static var CoreFoundationKit: Module {
        Module(name: ModuleInfo.Core.CoreFoundationKit.rawValue,
               path: ModuleInfo.Core.CoreFoundationKit.path)
    }
    
    static var NetworkProvider: Module {
        Module(name: ModuleInfo.Service.NetworkProvider.rawValue,
               path: ModuleInfo.Service.NetworkProvider.path,
               frameworkDependencies: [
                .ThirdPartyLibrary,
                .CoreNetwork
               ])
    }
}

//MARK: - All Modules
public extension Module {
    static var allModules: [Module] {
        [
            ThirdPartyLibrary,
            CoreNetwork,
            NetworkProvider
        ]
    }
}

extension Module {
    private static func makeThirdPartySettings() -> Settings {
        return .settings(
            base: [
                "GCC_PREPROCESSOR_DEFINITIONS": "FLEXLAYOUT_SWIFT_PACKAGE=1",
                "OTHER_LDFLAGS": "-ObjC -all_load -Xlinker -no_warn_duplicate_libraries"
            ],
            debug: ["GCC_PREPROCESSOR_DEFINITIONS": "$(inherited)"],
            release: ["EXCLUDED_SOURCE_FILE_NAMES": "FLEX*"],
            defaultSettings: .recommended)
    }
}
