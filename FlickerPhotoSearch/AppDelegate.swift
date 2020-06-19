//
//  AppDelegate.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 19/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let flickerSearchVC = FlickerSearchViewController()
        let navigationController = UINavigationController(rootViewController: flickerSearchVC)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

