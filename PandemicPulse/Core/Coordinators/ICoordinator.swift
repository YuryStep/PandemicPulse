//
//  ICoordinator.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

public protocol ICoordinator: AnyObject {
    var childCoordinators: [ICoordinator] { get set }
    var navigationController: UINavigationController { get set }
    var finishDelegate: ICoordinatorFinishDelegate? { get set }

    func start(_: AppFlow?)
    func finish()
}

public protocol ICoordinatorFinishDelegate: AnyObject {
    func didFinish(_ coordinator: ICoordinator)
}

public extension ICoordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.didFinish(self)
    }
}
