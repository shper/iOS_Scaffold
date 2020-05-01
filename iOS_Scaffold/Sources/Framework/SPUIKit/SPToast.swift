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
    static func showToast(_ title: String,
                          duration: ToastDuration = .short,
                          view: UIView = SPRootUtils.getRootWindow(),
                          yOffset: CGFloat = 0) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        hud.offset.y = yOffset
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
    
}
