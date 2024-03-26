//
//  SettingsModuleCoordinator.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import Foundation

class SettingsModuleCoordinator: BaseCoordinator {

    override func start() {
        self.performFlow()
    }

    private func performFlow() {
        let viewController = SettingsInputModuleAssembly.makeModule()
        self.navigationController?.setViewControllers([viewController], animated: false)
    }

}
