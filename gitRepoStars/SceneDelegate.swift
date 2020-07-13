//
//  SceneDelegate.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = (scene as? UIWindowScene) {
            let controller = RepositoriesViewController()
            let viewModel = RepositoriesViewModel()
            let navigation = UINavigationController(rootViewController: controller)
            controller.bind(to: viewModel)

            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = navigation
            window?.makeKeyAndVisible()

        }
    }
}

