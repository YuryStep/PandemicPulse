//
//  SettingsTextField.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

class SettingsTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        borderStyle = .roundedRect
        translatesAutoresizingMaskIntoConstraints = false
    }
}
