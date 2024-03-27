//
//  SettingsModuleAssembly.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

enum SettingsModuleAssembly {
    static func makeModule(withPresenterDelegate delegate: SettingsPresenterDelegateProtocol) -> UIViewController {
        let settingsViewController = SettingsViewController()
        let presenter = SettingsPresenter(view: settingsViewController, delegate: delegate)
        settingsViewController.presenter = presenter
        return settingsViewController
    }
}
