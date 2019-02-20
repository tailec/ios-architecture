//
//  AppDelegate.swift
//  MVVMClosures
//
//  Created by krawiecp-home on 26/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        if let window = window {
            let view = ReposWireframe.createReposModule()
            window.rootViewController = view
            window.makeKeyAndVisible()
        }
        return true
    }
}
