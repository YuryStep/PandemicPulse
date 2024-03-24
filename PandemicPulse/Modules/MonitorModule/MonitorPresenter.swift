//
//  MonitorPresenter.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

protocol MonitorPresenterProtocol {}

class MonitorPresenter {
    private weak var view: MonitorViewProtocol?
    private var dataManager: AppDataManager

    init(view: MonitorViewProtocol, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
    }
}

extension MonitorPresenter: MonitorPresenterProtocol {}
