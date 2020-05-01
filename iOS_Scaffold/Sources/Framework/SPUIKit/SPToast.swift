//
//  SPToast.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/29.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class SPToast {
    
    // 显示 Toast
    class func showToast(_ title: String, duration: ToastDuration = .short) {
        let window = rootWindow()
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
//        hud.offset.y = CGFloat(self.view.frame.size.height / 3)
        hud.hide(animated: true, afterDelay: duration.rawValue)
        
        hud.bezelView.alpha = 0.8
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColor.black
        hud.bezelView.snp.makeConstraints { (make) in
            make.height.equalTo(45)
        }
        
        hud.label.text = title
        hud.label.textColor = UIColor.white
        hud.label.font = UIFont.systemFont(ofSize: 16)
        hud.label.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
        }
    }
    
    // 获取用于显示提示框的 window
    class func rootWindow() -> UIView {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windowArray = UIApplication.shared.windows
            for tempWin in windowArray {
                if tempWin.windowLevel == UIWindow.Level.normal {
                    window = tempWin;
                    break
                }
            }
        }
        return window!
    }
    
}
