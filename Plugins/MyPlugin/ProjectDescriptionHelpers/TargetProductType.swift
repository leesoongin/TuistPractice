//
//  TargetProductType.swift
//  MyPlugin
//
//  Created by 이숭인 on 5/23/24.
//

import Foundation

public enum TargetProductType: Hashable {
    case app // 추후 사용하게 된다면 사용 예정 
    case dynamicFramework
    case staticFramework
    
    public var isApp: Bool { self == .app }
    public var isFramework: Bool {
        switch self {
        case .dynamicFramework, .staticFramework:
            return true
        case .app:
            return false
        }
    }
    public var hasDynamicFramework: Bool { self == .dynamicFramework }
}
