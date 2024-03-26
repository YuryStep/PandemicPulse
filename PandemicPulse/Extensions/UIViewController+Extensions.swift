//
//  UIViewController+Extensions.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 25.03.2024.
//

import UIKit

extension UIViewController {
    func wrappedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        return navigationController
    }
}
