//
//  HomeTabViewController.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/25.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import UIKit

class RootTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundColor = UIColor.white
        
        self.setupTabbars()
    }
    
    fileprivate func setupTabbars() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem (title: "首页",
                                          image: UIImage(named: "home"),
                                          selectedImage: UIImage(named: "home"))
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem (title: "我的",
                                              image: UIImage(named: "setting"),
                                              selectedImage: UIImage(named: "setting"))
        
        self.setViewControllers([homeVC, settingsVC], animated: true)
    }
    
}
