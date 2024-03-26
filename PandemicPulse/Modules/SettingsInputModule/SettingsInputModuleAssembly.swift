//
//  SettingsInputModuleAssembly.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

enum SettingsInputModuleAssembly {
    static func makeModule() -> UIViewController {
        let settingsInputViewController = SettingsInputViewController()
        return settingsInputViewController.wrappedInNavigationController()
    }
}
