//
//  MonitorPresenter.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import Foundation

protocol MonitorPresenterProtocol {
    func getNumberOfSections() -> Int
    func getSectionType(for sectionIndex: Int) -> MonitorCollectionView.Section
    func getItemsForSection(at sectionIndex: Int) -> [MonitorCollectionView.Item]

    func didTapOnElement(at: IndexPath)
    func resetButtonTapped()
}

final class MonitorPresenter {
    private struct State {
        var riskGroup: ThreadSafeMatrix<Infectable>
        var healthyElementsCount: Int

        init(riskGroup: ThreadSafeMatrix<Infectable>) {
            self.riskGroup = riskGroup
            healthyElementsCount = riskGroup.countElements
        }
    }

    private weak var view: MonitorViewProtocol?
    private var dataManager: AppDataManager
    private var state: State = .init(riskGroup: ThreadSafeMatrix<Infectable>())

    private let infectionUpdateInterval: TimeInterval

    private lazy var onInfectionSpreadCompletion = { [weak self] in
        guard let self else { return }
        updateCurrentState()
        view?.renderUserInterface()
        if state.healthyElementsCount == 0 {
            stopTimer()
        }
    }

    private var timer: Timer?
    private var infectionSpreadInitiated = false

    init(view: MonitorViewProtocol, dataManager: AppDataManager, infectionUpdateInterval: TimeInterval) {
        self.view = view
        self.dataManager = dataManager
        self.infectionUpdateInterval = infectionUpdateInterval
        self.dataManager.onCompletion = onInfectionSpreadCompletion
        updateCurrentState()
    }

    private func updateCurrentState() {
        state.riskGroup = dataManager.getCurrentRiskGroup()
        state.healthyElementsCount = dataManager.getCurrentHealthyElementsCount()
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
    func getNumberOfSections() -> Int {
        return state.riskGroup.countRows
    }

    func getSectionType(for sectionIndex: Int) -> MonitorCollectionView.Section {
        return .main(id: sectionIndex)
    }

    func getItemsForSection(at sectionIndex: Int) -> [MonitorCollectionView.Item] {
        var items: [MonitorCollectionView.Item] = []

        let row = state.riskGroup[sectionIndex]
        for element in row {
            let displayData = PersonCell.DisplayData(isInfected: element.isInfected)
            let item = MonitorCollectionView.Item.person(displayData)
            items.append(item)
        }
        return items
    }

    func didTapOnElement(at indexPath: IndexPath) {
        dataManager.infectElement(at: Position(indexPath))
        startTimerIfNeeded()
        updateCurrentState()
        view?.renderUserInterface()
    }

    func resetButtonTapped() {
        stopTimer()
        // reset
    }
}

private extension Position {
    init(_ indexPath: IndexPath) {
        row = indexPath.section
        column = indexPath.row
    }
}

private extension PersonCell.DisplayData {
    init(person: Person) {
        isInfected = person.isInfected
    }
}
