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
                                          image: UIImage.iconFont(code: "\u{e7a7}", size: 30.0),
                                          selectedImage: UIImage.iconFont(code: "\u{e7a7}",size: 30.0))
        
//        let webVC = SPWebviewController()
//        webVC.tabBarItem = UITabBarItem (title: "H5",
//                                              image: UIImage.iconFont(code: "\u{e753}", size: 30.0),
//                                              selectedImage: UIImage.iconFont(code: "\u{e753}", size: 30.0))
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem (title: "我的",
                                              image: UIImage.iconFont(code: "\u{e6ef}", size: 30.0),
                                              selectedImage: UIImage.iconFont(code: "\u{e6ef}", size: 30.0))
        
        self.setViewControllers([homeVC, settingsVC], animated: true)
    }
    
}
