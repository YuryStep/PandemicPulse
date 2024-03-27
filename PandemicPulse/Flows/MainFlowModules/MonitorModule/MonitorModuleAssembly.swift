//
//  MonitorModuleAssembly.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import UIKit

enum MonitorModuleAssembly {
    private enum Constants {
        static let minElementSizeByHIG: CGFloat = 44
    }

    /// Создание экрана моделирования распространения инфекции
    /// - Parameters:
    ///   - groupSize: Количество людей в моделируемой группе
    ///   - infectionFactor: Количество людей, которое может быть заражено одним человеком при контакте
    ///   - period: Период пересчёта количества заражённых людей в секундах
    static func makeModule(withPresenterDelegate delegate: MonitorPresenterDelegateProtocol,
                           groupSize: Int,
                           infectionFactor: Int,
                           period: Double) -> UIViewController {

        let riskGroup = makeRiskGroup(count: groupSize)
        let monitorViewController = MonitorViewController()
        let dataManager = PandemicDataManager(riskGroup: riskGroup, infectionFactor: infectionFactor)
        let monitorViewPresenter = MonitorPresenter(view: monitorViewController, dataManager: dataManager, infectionUpdateInterval: period, delegate: delegate)
        monitorViewController.presenter = monitorViewPresenter

        return monitorViewController
    }

    private static func makeRiskGroup(count: Int) -> ThreadSafeMatrix<Infectable> {
        guard count > 0 else { return ThreadSafeMatrix<Infectable>() } // TODO: Throw Error
        let rowLimit = calculateMaxRowLengthForDevice()
        let plainGroup = Array(repeating: Person(), count: count)
        return ThreadSafeMatrix(plainGroup, maxElementsInRow: rowLimit)
    }

    /// Расчет максимального количества элементов, которые можно разместить вплотную
    /// друг к другу на экране устройства соблюдая рекомендации Apple Human Interface Guidelines
    private static func calculateMaxRowLengthForDevice() -> Int {
        let screenSize = UIScreen.main.bounds.width
        let minimumWidth: CGFloat = Constants.minElementSizeByHIG
        let maxElementCount = Int(floor(screenSize / minimumWidth)) // TODO: Refactor
        return maxElementCount
    }
}
