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

    static func makeModule() -> UIViewController {
        let riskGroup = makeRiskGroup(count: 112)

        let monitorViewController = MonitorViewController()
        let dataManager = PandemicDataManager(riskGroup: riskGroup, infectionFactor: 1)
        let monitorViewPresenter = MonitorPresenter(view: monitorViewController, dataManager: dataManager, infectionUpdateInterval: 1)
        monitorViewController.presenter = monitorViewPresenter

        return monitorViewController.wrappedInNavigationController()
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
