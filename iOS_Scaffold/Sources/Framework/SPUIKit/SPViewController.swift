//
//  SPViewController.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/25.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import UIKit

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
