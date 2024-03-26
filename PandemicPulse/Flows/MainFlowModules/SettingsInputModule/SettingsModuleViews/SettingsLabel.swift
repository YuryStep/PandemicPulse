//
//  SettingsLabel.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

final class SettingsLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
