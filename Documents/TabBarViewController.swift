//
//  TabBarViewController.swift
//  Documents
//
//  Created by Razumov Pavel on 30.07.2025.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        tabBar.tintColor = .label
    }
    
    private func setupControllers() {
        let mainVC = DocumentsViewController()
        mainVC.tabBarItem = UITabBarItem(
            title: "Documents",
            image: UIImage(systemName: "folder"),
            selectedImage: nil
        )
        mainVC.navigationItem.title = "Documents"
        mainVC.tabBarItem.badgeColor = .label
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: nil
        )
        settingsVC.navigationItem.title = "Settings"
        
        let nav1 = UINavigationController(rootViewController: mainVC)
        let nav2 = UINavigationController(rootViewController: settingsVC)
        
        [nav1, nav2].forEach {
            $0.navigationBar.prefersLargeTitles = true
        }
        
        viewControllers = [nav1, nav2]
    }
}
