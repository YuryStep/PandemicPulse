//
//  PandemicPulseAssembly.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import UIKit

enum PandemicPulseAssembly {
    static func makeRootModule() -> UIViewController {
        let rootViewController = MonitorModuleAssembly.makeModule()
        return rootViewController
    }
}
