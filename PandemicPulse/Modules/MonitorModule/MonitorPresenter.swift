//
//  MonitorPresenter.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import Foundation

protocol MonitorPresenterProtocol {
    func getPersonCellDisplayData() -> [MonitorCollectionView.Item]
    func didTapOnElement(at: IndexPath)
}

final class MonitorPresenter {
    private struct State {
        private var healthyElementsCount: Int
    }

    private weak var view: MonitorViewProtocol?

    private let dataManager: AppDataManager
    private let infectionUpdateInterval: TimeInterval

    private let onInfectionSpreadCompletion = {
        // updateState
        // update UI
        // If healthyElementsCount == 0 - Stop Timer
    }

    private var timer: Timer?
    private var infectionSpreadInitiated = false

    init(view: MonitorViewProtocol, dataManager: AppDataManager, infectionUpdateInterval: TimeInterval) {
        self.view = view
        self.dataManager = dataManager
        self.infectionUpdateInterval = infectionUpdateInterval
    }

    private func startTimerIfNeeded() {
        guard infectionSpreadInitiated == false else { return }
        infectionSpreadInitiated = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: infectionUpdateInterval, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
    }

    private func stopTimer() {
        timer?.invalidate()
    }

    @objc private func timerDidFire() {
        dataManager.spreadInfectionInGroup()
    }
}

extension MonitorPresenter: MonitorPresenterProtocol {
    func getPersonCellDisplayData() -> [MonitorCollectionView.Item] {
        return [MonitorCollectionView.Item.person(PersonCell.DisplayData(isInfected: true)),
                MonitorCollectionView.Item.person(PersonCell.DisplayData(isInfected: true)),
                MonitorCollectionView.Item.person(PersonCell.DisplayData(isInfected: false)),
                MonitorCollectionView.Item.person(PersonCell.DisplayData(isInfected: false)),
                MonitorCollectionView.Item.person(PersonCell.DisplayData(isInfected: true)),
                MonitorCollectionView.Item.person(PersonCell.DisplayData(isInfected: false)),
                MonitorCollectionView.Item.person(PersonCell.DisplayData(isInfected: true)),
                MonitorCollectionView.Item.person(PersonCell.DisplayData(isInfected: false))]
    }

    func didTapOnElement(at indexPath: IndexPath) {
        let elementPosition = Position(indexPath)
        dataManager.infectElement(at: elementPosition)
        startTimerIfNeeded()
    }
}

private extension Position {
    init(_ indexPath: IndexPath) {
        row = indexPath.section
        column = indexPath.row
    }
}
