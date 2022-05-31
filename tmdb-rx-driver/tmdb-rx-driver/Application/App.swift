//
//  App.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 30/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

final class App {
    static let shared = App()
    
    func startInterface(in window: UIWindow) {
        let discoverViewController = DiscoverViewController.Factory.default
        let discoverNavigationController = UINavigationController(rootViewController: discoverViewController)
        
        let searchNavigationController = UINavigationController(rootViewController: SearchViewController.Factory.default)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
        tabBarController.tabBar.tintColor = .white

        discoverNavigationController.tabBarItem = UITabBarItem(title: "Discover", image: nil, selectedImage: nil)
        
        searchNavigationController.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        
        tabBarController.viewControllers = [
            discoverNavigationController,
            searchNavigationController
        ]
        
        let loginNavigationController = UINavigationController(rootViewController: LoginViewController.Factory.default)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        // Not the nicest solution, if someone has any idea how to manage login/main screens, please let me know!
        tabBarController.present(loginNavigationController, animated: true, completion: nil)

    }
}
