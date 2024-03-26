//
//  SettingsPresenter.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

protocol SettingsPresenterProtocol {
    func startSimulationButtonTapped(with: SettingsViewController.UserInput)
}

final class SettingsPresenter {
    private weak var view: SettingsViewProtocol?
    private var coordinator: IMainFlowCoordinator

    init(view: SettingsViewProtocol, coordinator: IMainFlowCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }
}

extension SettingsPresenter: SettingsPresenterProtocol {
    func startSimulationButtonTapped(with userInput: SettingsViewController.UserInput) {
        coordinator.showMonitorScene(groupSize: userInput.groupSize,
                                     infectionFactor: userInput.infectionFactor,
                                     period: userInput.period)
    }
}
