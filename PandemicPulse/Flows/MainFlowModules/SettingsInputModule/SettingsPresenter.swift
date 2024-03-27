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

protocol SettingsPresenterDelegateProtocol: AnyObject {
    func startSimulationButtonTapped(with: SettingsViewController.UserInput)
}

final class SettingsPresenter {
    private weak var view: SettingsViewProtocol?
    private weak var delegate: SettingsPresenterDelegateProtocol?

    init(view: SettingsViewProtocol, delegate: SettingsPresenterDelegateProtocol) {
        self.view = view
        self.delegate = delegate
    }
}

extension SettingsPresenter: SettingsPresenterProtocol {
    func startSimulationButtonTapped(with userInput: SettingsViewController.UserInput) {
        delegate?.startSimulationButtonTapped(with: userInput)
    }
}
