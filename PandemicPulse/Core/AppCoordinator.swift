//
//  AppCoordinator.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import Foundation
import UIKit

/// Протокол координатора
public protocol CoordinatorProtocol: AnyObject {
    /// установка зависимости на UINavigationController, для выполнения навигации
    /// - Parameter navigationController: экземпларя UINavigationController
    func set(navigationController: UINavigationController)
    /// Старт
    func start()
}

/// Основной координатор
open class BaseCoordinator: NSObject, CoordinatorProtocol {
    /// Координаторы
    var childCoordinators: [CoordinatorProtocol] = []

    var navigationController: UINavigationController?

    public func set(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    /// Старт
    open func start() {
    }

    public func cleanDependency() {
        self.childCoordinators.removeAll()
    }

    /// Добавление зависимостей
    /// - Parameter coordinator: Координатор
    public func addDependency(_ coordinator: CoordinatorProtocol) {
        for element in self.childCoordinators {
            if element === coordinator { return }
        }
        self.childCoordinators.append(coordinator)
    }

    /// Удаление зависимостей
    /// - Parameter coordinator: coordinator Координатор
    public func removeDependency(_ coordinator: CoordinatorProtocol?) {
        guard self.childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        for (index, element) in self.childCoordinators.enumerated() {
            if element === coordinator {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
}

final class AppCoordinator: BaseCoordinator {

    static let shared: AppCoordinator = AppCoordinator()
    private var dataManager: AppDataManager?

    func set(dataManager: AppDataManager) {
        self.dataManager = dataManager
    }

    override func start() {
        self.performFlow()
    }

    private func performFlow() {
        // здесь может быть выбор между экранами авторизации, онбординга и т д
        performMain()
    }

    func performMain() {
        guard let navigationController else { return }

        let coordinator = SettingsModuleCoordinator()
        coordinator.set(navigationController: navigationController)
        coordinator.start()
        self.addDependency(coordinator)
    }
}
