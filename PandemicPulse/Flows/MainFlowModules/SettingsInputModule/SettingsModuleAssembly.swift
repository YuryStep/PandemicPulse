//
//  SettingsModuleAssembly.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

enum SettingsModuleAssembly {
    static func makeModule(coordinator: IMainFlowCoordinator) -> UIViewController {
        let settingsViewController = SettingsViewController()
        let presenter = SettingsPresenter(view: settingsViewController, coordinator: coordinator)
        settingsViewController.presenter = presenter
        return settingsViewController
    }
}
