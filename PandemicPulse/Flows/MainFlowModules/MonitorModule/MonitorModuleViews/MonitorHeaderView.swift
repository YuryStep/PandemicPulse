//
//  MonitorHeaderView.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 25.03.2024.
//

import UIKit

final class MonitorHeaderView: UIView {
    private enum Constants {
        static let offsetBeforeContent: CGFloat = -10
    }

    private lazy var healthyLabel: UILabel = {
        let label = UILabel()
        label.text = "Healthy"
        label.textAlignment = .center
        return label
    }()

    private lazy var healthyCountLabel: UILabel = {
        let label = UILabel()
        label.text = "750"
        label.textColor = .systemGreen
        label.textAlignment = .center
        return label
    }()

    private lazy var infectedLabel: UILabel = {
        let label = UILabel()
        label.text = "Infected"
        label.textAlignment = .center
        return label
    }()

    private lazy var infectedCountLabel: UILabel = {
        let label = UILabel()
        label.text = "93"
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    private lazy var healthyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [healthyLabel, healthyCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center // Выравнивание по центру
        return stackView
    }()

    private lazy var infectedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infectedLabel, infectedCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center // Выравнивание по центру
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [healthyLabel, healthyCountLabel, infectedLabel, infectedCountLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center // Выравнивание по центру
        stackView.distribution = .equalCentering
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    private func setupSubviews() {
        addSubview(mainStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.offsetBeforeContent)
        ])
    }
}
