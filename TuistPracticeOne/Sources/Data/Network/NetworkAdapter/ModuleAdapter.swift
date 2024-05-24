//
//  ModuleAdapter.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/24/24.
//  Copyright © 2024 TuistPracticeOne. All rights reserved.
//

import Foundation
import NetworkProvider

struct ModuleAdapter {
    static func setup() {
        SwitNetworkAdapterManager.shared.adapter = NetworkAdapter()
    }
}
