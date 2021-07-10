//
//  AppDelegate.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/19.
//  Copyright © 2020 Shper. All rights reserved.
//

import UIKit
import TKLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate?
    
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppDelegate.shared = self
        
        setupTKLogger()

        setupBootViewController()
        
        return true
    }
    
    private func setupTKLogger() {
        TKLogger.setup(tag: "iOS_Scaffold")
        TKLogger.addDestination(TKLogConsoleDestination())
    }
    
    private func setupBootViewController() {
        let navigation = UINavigationController(rootViewController: RootTabViewController())
        navigation.setNavigationBarHidden(true, animated: false)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
    }

}

