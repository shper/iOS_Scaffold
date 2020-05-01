//
//  SPViewController+Loading.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/29.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension SPViewController {

    func showLoading() {
        SPLoading.shared.show()
    }
    
    func hideLoading() {
        SPLoading.shared.hide()
    }
    
}
