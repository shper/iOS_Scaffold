//
//  SPViewController.swift
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
class SPViewController : UIViewController {
    
    override func loadView() {
        super.loadView()

        SPLogger.debug("loadView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SPLogger.debug("viewDidLoad")
        
        setupLayout()
    }
    
    func setupLayout() {
        SPLogger.debug("setupLayout")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SPLogger.debug("viewWillAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        SPLogger.debug("viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        SPLogger.debug("viewDidDisappear")
    }

}

// MARK: Toast

enum ToastDuration: Double {
    case short = 3
    case long = 6
}

extension SPViewController {

    // 显示 Toast
    func showToast(_ title: String, duration: ToastDuration = .short) {
        SPToast.showToast(title, duration: duration, yOffset: self.view.frame.size.height / 3)
    }
    
}

// MARK: Loading

extension SPViewController {

    func showLoading() {
        SPLoading.shared.show()
    }
    
    func hideLoading() {
        SPLoading.shared.hide()
    }
    
}

// MARK: Alert

extension SPViewController {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach({ (action) in
            alert.addAction(action)
        })
        self.present(alert, animated: true, completion: completion)
    }
    
}
