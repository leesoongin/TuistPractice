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

public struct ModuleInfo {
    enum Core: String, ModuleInfoType {
        case CoreNetwork
        
        var path: String { "Modules/Core/\(rawValue)" }
    }
}

//MARK: - Modules
extension Module {
    static var CoreNetwork: Module {
        Module(name: ModuleInfo.Core.CoreNetwork.rawValue,
               path: ModuleInfo.Core.CoreNetwork.path)
    }
}

//MARK: - All Modules
public extension Module {
    static var allModules: [Module] {
        [
            CoreNetwork
        ]
    }
}
