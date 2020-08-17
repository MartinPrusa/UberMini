//
//  SceneDelegate.swift
//  UberMini
//
//  Created by Martin Prusa on 16.08.2020.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        let login = LoginViewController(style: .plain)
        let navC = UINavigationController(rootViewController: login)
        navC.navigationBar.prefersLargeTitles = true

        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            self.window?.rootViewController = navC
            self.window?.makeKeyAndVisible()
        }
    }
}

