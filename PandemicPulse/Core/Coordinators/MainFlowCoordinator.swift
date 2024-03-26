//
//  MainFlowCoordinator.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

protocol IMainFlowCoordinator: ICoordinator {
    func showSettingsInputScene()
    func showMonitorScene(groupSize: Int, infectionFactor: Int, period: Double)
}

final class MainFlowCoordinator: IMainFlowCoordinator {
    var childCoordinators: [ICoordinator] = []
    var navigationController: UINavigationController
    var finishDelegate: ICoordinatorFinishDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(_: AppFlow? = nil) {
        showSettingsInputScene()
    }

    func showSettingsInputScene() {
        let viewController = SettingsModuleAssembly.makeModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showMonitorScene(groupSize: Int, infectionFactor: Int, period: Double) {
        let viewController = MonitorModuleAssembly.makeModule(
            coordinator: self,
            groupSize: groupSize,
            infectionFactor: infectionFactor,
            period: period
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}
