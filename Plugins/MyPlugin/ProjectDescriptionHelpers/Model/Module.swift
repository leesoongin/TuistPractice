//
//  Module.swift
//  MyPlugin
//
//  Created by 이숭인 on 5/23/24.
//

import ProjectDescription

public struct Module {
    /// Module 이름
    public let name: String
    /// Module이 위치한 경로
    public let path: String
    /// framework에 대한 의존성
    public let frameworkDependencies: [TargetDependency]
    /// framework 리소스 경로
    public let frameworkResources: [String]
    /// framework 의 target membership 에서 제외할 소스 경로
    public let frameworkExcludingSourcePath: [String]
    /// framework의 빌드 세팅 정보
    public let frameworkSettings: ProjectDescription.Settings?
    /// framework의 infoPlist 정보
    public let frameworkInfoPlist: ProjectDescription.InfoPlist
    /// 모듈의 타겟 Product Type
    public let targetProducts: Set<TargetProductType>

    public init(name: String,
                path: String,
                frameworkDependencies: [TargetDependency] = [],
                frameworkResources: [String] = [],
                frameworkExcludingSourcePath: [String] = [],
                frameworkSettings: ProjectDescription.Settings? = makeDefaultSettings(),
                frameworkInfoPlist: ProjectDescription.InfoPlist = .default,
                targetProducts: Set<TargetProductType> = [.dynamicFramework]) {
        self.name = name
        self.path = path
        self.frameworkDependencies = frameworkDependencies
        self.frameworkResources = frameworkResources
        self.frameworkExcludingSourcePath = frameworkExcludingSourcePath
        self.frameworkSettings = frameworkSettings
        self.frameworkInfoPlist = frameworkInfoPlist
        self.targetProducts = targetProducts
    }
}

extension Module {
    public static func makeDefaultSettings() -> ProjectDescription.Settings {
        return .settings(
            base: [
                "OTHER_LDFLAGS": ["-Xlinker -no_warn_duplicate_libraries", "-ObjC", "-all_load"]
            ],
            defaultSettings: .recommended)
    }
}
