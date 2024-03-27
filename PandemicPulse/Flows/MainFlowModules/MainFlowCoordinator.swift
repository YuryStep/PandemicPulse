//
//  MainFlowCoordinator.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

protocol IMainFlowCoordinator: CoordinatorProtocol {
    func showSettingsInputScene()
    func showMonitorScene(groupSize: Int, infectionFactor: Int, period: Double)
}

final class MainFlowCoordinator: IMainFlowCoordinator {
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    var finishDelegate: CoordinatorProtocolFinishDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(_: AppFlow? = nil) {
        showSettingsInputScene()
    }

    func showSettingsInputScene() {
        let viewController = SettingsModuleAssembly.makeModule(withPresenterDelegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showMonitorScene(groupSize: Int, infectionFactor: Int, period: Double) {
        let viewController = MonitorModuleAssembly.makeModule(
            withPresenterDelegate: self,
            groupSize: groupSize,
            infectionFactor: infectionFactor,
            period: period
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainFlowCoordinator: SettingsPresenterDelegateProtocol {
    func startSimulationButtonTapped(with userInput: SettingsViewController.UserInput) {
        showMonitorScene(
            groupSize: userInput.groupSize,
            infectionFactor: userInput.infectionFactor,
            period: userInput.period
        )
    }
}

extension MainFlowCoordinator: MonitorPresenterDelegateProtocol {
    func didTapOnBackButton() {
        navigationController.popViewController(animated: true)
    }
}
