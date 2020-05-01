//
//  UIView+Loading.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/5/1.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func showLoading() {
        SPLoading.shared.show()
    }
    
    func hideLoading() {
        SPLoading.shared.hide()
    }
    
}
