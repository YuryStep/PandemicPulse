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
    func getNumberOfElementsInRow() -> Int
    func getHeaderDisplayData() -> MonitorHeaderView.DisplayData
    func didTapOnElement(at: IndexPath)
}

final class MonitorPresenter {
    private struct State {
        var riskGroup: ThreadSafeMatrix<Infectable>
        var healthyElementsCount: Int

        var numberOfElementsInRow: Int {
            riskGroup.countColumns
        }

        init(riskGroup: ThreadSafeMatrix<Infectable>) {
            self.riskGroup = riskGroup
            healthyElementsCount = riskGroup.countElements
        }
    }

    private weak var view: MonitorViewProtocol?
    private var coordinator: IMainFlowCoordinator?
    private var dataManager: AppDataManager

    private var state: State = .init(riskGroup: ThreadSafeMatrix<Infectable>())
    private let infectionUpdateInterval: TimeInterval
    private var timer: Timer?
    private var infectionSpreadInitiated = false

    private lazy var onInfectionSpreadCompletion = { [weak self] in
        guard let self else { return }
        updateCurrentState()
        view?.renderUserInterface()
        if state.healthyElementsCount == 0 { stopTimer() }
    }

    init(view: MonitorViewProtocol,
         dataManager: AppDataManager,
         infectionUpdateInterval: TimeInterval,
         coordinator: IMainFlowCoordinator)
    {
        self.view = view
        self.coordinator = coordinator
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
            let displayData = InfectableItemCell.DisplayData(isInfected: element.isInfected)
            let item = MonitorCollectionView.Item.person(displayData)
            items.append(item)
        }
        return items
    }

    func getNumberOfElementsInRow() -> Int {
        return state.numberOfElementsInRow
    }

    func getHeaderDisplayData() -> MonitorHeaderView.DisplayData {
        let infectedElementsCount = state.riskGroup.countElements - state.healthyElementsCount
        return MonitorHeaderView.DisplayData(healthyElementsCount: state.healthyElementsCount,
                                      infectedElementsCount: infectedElementsCount)
    }

    func didTapOnElement(at indexPath: IndexPath) {
        dataManager.infectElement(at: Position(indexPath))
        startTimerIfNeeded()
        updateCurrentState()
        view?.renderUserInterface()
    }
}

private extension Position {
    init(_ indexPath: IndexPath) {
        row = indexPath.section
        column = indexPath.row
    }
}

private extension InfectableItemCell.DisplayData {
    init(person: Person) {
        isInfected = person.isInfected
    }
}
