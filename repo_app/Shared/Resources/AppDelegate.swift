//
//  AppDelegate.swift
//  repo_app
//
//  Created by Mohamed Gamal on 1/6/21.
//  Copyright © 2021 Me. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let navigationController = UINavigationController(rootViewController: RepoViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

}

