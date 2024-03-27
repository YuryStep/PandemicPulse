//
//  MonitorHeaderView.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 25.03.2024.
//

import UIKit

final class MonitorHeaderView: UIView {
    struct DisplayData {
        let healthyElementsCount: Int
        let infectedElementsCount: Int
    }

    private enum Constants {
        static let offsetBeforeContent: CGFloat = -10
        static let defaultStackSpacing: CGFloat = 8
        static let mainStackSpacing: CGFloat = 16
        static let healthyLabelText = "Healthy"
        static let infectedLabelText = "Infected"
    }

    private lazy var healthyLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.healthyLabelText
        label.textAlignment = .center
        return label
    }()

    private lazy var healthyCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .center
        return label
    }()

    private lazy var infectedLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.infectedLabelText
        label.textAlignment = .center
        return label
    }()

    private lazy var infectedCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    private lazy var healthyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [healthyLabel, healthyCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = Constants.defaultStackSpacing
        stackView.alignment = .center
        return stackView
    }()

    private lazy var infectedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infectedLabel, infectedCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = Constants.defaultStackSpacing
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [healthyLabel, healthyCountLabel, infectedLabel, infectedCountLabel])
        stackView.axis = .vertical
        stackView.spacing = Constants.mainStackSpacing
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
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

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.offsetBeforeContent)
        ])
    }

    func configure(with displayData: DisplayData) {
        infectedCountLabel.text = String(displayData.infectedElementsCount)
        healthyCountLabel.text = String(displayData.healthyElementsCount)
    }
}
