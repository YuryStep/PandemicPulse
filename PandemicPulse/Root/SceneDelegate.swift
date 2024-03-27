//
//  SceneDelegate.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let appCoordinator = AppCoordinator(navigationController: UINavigationController())

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let rootNavigationController = UINavigationController()
        appCoordinator.navigationController = rootNavigationController
        window?.rootViewController = rootNavigationController

        window?.makeKeyAndVisible()
        appCoordinator.start(.mainFlow)
    }
}
