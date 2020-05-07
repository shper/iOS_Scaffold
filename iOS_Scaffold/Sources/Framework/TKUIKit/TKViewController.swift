//
//  TKViewController.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/25.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

/*
 VC 基类
 */
class TKViewController : UIViewController {
    
    override func loadView() {
        super.loadView()

        TKLogger.debug("loadView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        TKLogger.debug("viewDidLoad")
        
        setupLayout()
    }
    
    func setupLayout() {
        TKLogger.debug("setupLayout")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        TKLogger.debug("viewWillAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        TKLogger.debug("viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        TKLogger.debug("viewDidDisappear")
    }

}

// MARK: Toast

enum ToastDuration: Double {
    case short = 3
    case long = 6
}

extension TKViewController {

    // 显示 Toast
    func showToast(_ title: String, duration: ToastDuration = .short) {
        TKToast.showToast(title, duration: duration, yOffset: self.view.frame.size.height / 3)
    }
    
}

// MARK: Loading

extension TKViewController {

    func showLoading() {
        TKLoading.shared.show()
    }
    
    func hideLoading() {
        TKLoading.shared.hide()
    }
    
}

// MARK: Alert

extension TKViewController {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach({ (action) in
            alert.addAction(action)
        })
        self.present(alert, animated: true, completion: completion)
    }
    
}
