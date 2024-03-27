//
//  SettingsViewController.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {}

final class SettingsViewController: UIViewController {
    private enum Constants {
        static let mainTitleText = "Настройки моделирования"
        static let groupSizeLabelText = "Количество людей в группе"
        static let groupSizeTextFieldPlaceholderText = "Введите количество"
        static let infectionFactorLabelText = "Количество зараженных от одного контакта"
        static let infectionFactorTextFieldPlaceholder = "Введите количество"
        static let periodLabelText = "Период пересчёта количества заражённых (сек)"
        static let periodTextFieldPlaceholder = "Введите период"
        static let startSimulationButtonTitle = "Запустить моделирование"
        static let alertMessage = "Проверьте правильность введенных данных."
        static let alertTitle = "Ошибка"
        static let alertTitleButtonText = "OK"
        static let iconSize: CGFloat = 20
    }

    struct UserInput {
        let groupSize: Int
        let infectionFactor: Int
        let period: Double
    }

    var presenter: SettingsPresenterProtocol!

    private lazy var groupSizeLabel = SettingsLabel(text: Constants.groupSizeLabelText)
    private lazy var groupSizeTextField = SettingsTextField(placeholder: Constants.groupSizeTextFieldPlaceholderText)
    private lazy var infectionFactorLabel = SettingsLabel(text: Constants.infectionFactorLabelText)
    private lazy var infectionFactorTextField = SettingsTextField(placeholder: Constants.infectionFactorTextFieldPlaceholder)
    private lazy var periodLabel = SettingsLabel(text: Constants.periodLabelText)
    private lazy var periodTextField = SettingsTextField(
        placeholder: Constants.periodTextFieldPlaceholder)

    private lazy var startSimulationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.startSimulationButtonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startSimulationButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        title = Constants.mainTitleText

        view.addSubviews([groupSizeLabel, groupSizeTextField, infectionFactorLabel, infectionFactorTextField, periodLabel, periodTextField, startSimulationButton])

        NSLayoutConstraint.activate([
            groupSizeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            groupSizeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            groupSizeTextField.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor, constant: 10),
            groupSizeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            groupSizeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            infectionFactorLabel.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 20),
            infectionFactorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            infectionFactorTextField.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 10),
            infectionFactorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infectionFactorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            periodLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 20),
            periodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            periodTextField.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 10),
            periodTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            periodTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            startSimulationButton.topAnchor.constraint(equalTo: periodTextField.bottomAnchor, constant: 40),
            startSimulationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func startSimulationButtonTapped() {
        guard let userInput = validUserInput() else {
            showAlert(with: Constants.alertTitle, message: Constants.alertMessage)
            return
        }
        presenter.startSimulationButtonTapped(with: userInput)
    }

    private func validUserInput() -> UserInput? {
        guard let groupSizeString = groupSizeTextField.text,
              let groupSize = Int(groupSizeString),
              groupSize > 0,

              let infectionFactorString = infectionFactorTextField.text,
              let infectionFactor = Int(infectionFactorString),
              infectionFactor > 0,

              let periodString = periodTextField.text,
              let period = Double(periodString),
              period > 0
        else { return nil }
        let validUserInput = UserInput(groupSize: groupSize, infectionFactor: infectionFactor, period: period)
        return validUserInput
    }

    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertTitleButtonText, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: SettingsViewProtocol {}
