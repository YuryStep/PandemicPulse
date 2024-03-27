//
//  SettingsTextField.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 26.03.2024.
//

import UIKit

final class SettingsTextField: UITextField {
    init(placeholder: String, keyboard: UIKeyboardType = .numberPad) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setup(withKeyboardType: keyboard)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(withKeyboardType type: UIKeyboardType) {
        borderStyle = .roundedRect
        translatesAutoresizingMaskIntoConstraints = false
        keyboardType = type
    }
}
