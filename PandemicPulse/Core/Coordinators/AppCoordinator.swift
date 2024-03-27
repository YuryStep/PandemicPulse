//
//  AppCoordinator.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol: CoordinatorProtocol {
    func performMainFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    var finishDelegate: CoordinatorProtocolFinishDelegate?

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
