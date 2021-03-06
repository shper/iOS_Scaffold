//
//  UIVIew+Toast.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/5/1.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import UIKit

// MARK: Toast

extension UIView {
    
    // 显示 Toast
    func showToast(_ title: String, duration: ToastDuration = .short) {
        TKToast.showToast(title, duration: duration, view: self, yOffset: self.frame.size.height / 3)
    }
    
}

// MARK: Loading

extension UIView {
    
    func showLoading() {
        TKLoading.shared.show()
    }
    
    func hideLoading() {
        TKLoading.shared.hide()
    }
    
}
