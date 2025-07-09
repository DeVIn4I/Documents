//
//  SceneDelegate.swift
//  Documents
//
//  Created by Razumov Pavel on 09.07.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let documentVC = DocumentsViewController()
        let navigationController = UINavigationController(rootViewController: documentVC)
        navigationController.navigationBar.prefersLargeTitles = true
        documentVC.navigationItem.title = "Documents"
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

