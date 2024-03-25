//
//  MonitorModuleAssembly.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import UIKit

enum MonitorModuleAssembly {
    static func makeModule() -> UIViewController {
        let groupOfPeople = {
            var group = [Infectable]()
            for _ in 0 ... 1_000_000 {
                group.append(Person())
            }
            return ThreadSafeMatrix(group)
        }()

        let monitorViewController = MonitorViewController()
        let dataManager = PandemicDataManager(riskGroup: groupOfPeople, infectionFactor: 3)
        let monitorViewPresenter = MonitorPresenter(view: monitorViewController, dataManager: dataManager, infectionUpdateInterval: 1)
        monitorViewController.presenter = monitorViewPresenter

        return monitorViewController
    }
}
