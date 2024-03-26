//
//  SceneDelegate.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    enum Flow {
        case onboarding
        case main
    }

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let rootNavigationController = UINavigationController()
        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()


        let coordinator = AppCoordinator.shared
        coordinator.set(navigationController: rootNavigationController)
        coordinator.start()
    }
}
