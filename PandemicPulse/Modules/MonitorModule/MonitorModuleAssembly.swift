//
//  MonitorModuleAssembly.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import UIKit

enum MonitorModuleAssembly {
    static func makeModule() -> UIViewController {
        let monitorViewController = MonitorViewController()
        let dataManager = PandemicDataManager()
        let monitorViewPresenter = MonitorPresenter(view: monitorViewController, dataManager: dataManager)
        monitorViewController.presenter = monitorViewPresenter

        return monitorViewController
    }
}
