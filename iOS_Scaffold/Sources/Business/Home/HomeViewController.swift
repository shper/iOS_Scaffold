//
//  HomeViewController.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/19.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController: SPViewController, HomeViewModelDelegate {

    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SPLogger.debug("viewDidLoad")
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.testTextView)
        self.testTextView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(300)
            make.top.equalToSuperview()
        }
        
        self.view.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-100)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(50)
            make.top.equalTo(self.testTextView.snp.bottom).offset(50)
        }
        
        self.button.addTarget(self, action: #selector(self.btnClickFun), for: .touchDown)
        
        viewModel = HomeViewModel(self)
        viewModel?.loadDate()
    }
    
    func setTextViews(_ text: String) {
        self.testTextView.text = text
    }
    
    // MARK: - UI
    
    fileprivate lazy var testTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Main ViewController"
        textView.font = UIFont.systemFont(ofSize: 15.0)
        textView.textColor = UIColor.black
        textView.isEditable = false
        
        return textView
    }()
    
    fileprivate lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = UIColor.blue
        
        return button
    }()
    
    // MARK - Target
    
    @objc func btnClickFun() {
        SPLogger.debug("AAAAA")
//        self.showToast("AAAA")
//        self.showLoading()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.hideLoading()
//
//            self.showToast("数据加载成功")
//        }
        
        self.showAlert(title: "Alert", message: "Message", actions: [
            UIAlertAction(title: "OK", style: .default, handler: { action in
                print("OK")
                
            }),
            UIAlertAction(title: "cancel", style: .cancel, handler: { action in
                print("cancel")
                
            })]) {
                print("BBB")
        }
    }
    
}
