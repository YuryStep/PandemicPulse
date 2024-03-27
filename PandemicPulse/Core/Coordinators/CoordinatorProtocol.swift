//
//  CoordinatorProtocol.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

public protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController { get set }
    var finishDelegate: CoordinatorProtocolFinishDelegate? { get set }

    func start(_: AppFlow?)
    func finish()
}

public protocol CoordinatorProtocolFinishDelegate: AnyObject {
    func didFinish(_ coordinator: CoordinatorProtocol)
}

public extension CoordinatorProtocol {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.didFinish(self)
    }
}
