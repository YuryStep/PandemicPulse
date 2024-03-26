//
//  AppCoordinator.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import Foundation
import UIKit

protocol IAppCoordinator: ICoordinator {
    func performMainFlow()
}

final class AppCoordinator: IAppCoordinator {
    var childCoordinators: [ICoordinator] = []
    var navigationController: UINavigationController
    var finishDelegate: ICoordinatorFinishDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(_ flow: AppFlow? = nil) {
        switch flow {
        case .mainFlow: performMainFlow()
        case .none: performMainFlow()
        }
    }

    func performMainFlow() {
        let mainFlowCoordinator = MainFlowCoordinator(navigationController: navigationController)
        childCoordinators.append(mainFlowCoordinator)
        mainFlowCoordinator.start()
    }
}
