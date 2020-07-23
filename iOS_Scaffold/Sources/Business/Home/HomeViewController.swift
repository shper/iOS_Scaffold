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
import TKLogger

class HomeViewController: TKViewController, HomeViewModelDelegate {

    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TKLogger.debug("viewDidLoad")
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.testTextView)
        self.testTextView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(300)
            make.top.equalToSuperview()
        }
        
        //        self.view.addSubview(self.testImageView)
        //        self.testImageView.snp.makeConstraints { (make) in
        //            make.width.equalTo(100)
        //            make.height.equalTo(100)
        //            make.top.equalTo(self.testTextView).offset(50)
        //        }
        
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
    
    fileprivate lazy var testImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.iconFont(code: "\u{e7a7}", size: 50.0)
        
        return imageView
    }()
    
    fileprivate lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = UIColor.blue
        
        return button
    }()
    
    // MARK - Target
    
    @objc func btnClickFun() {
        TKLogger.debug("AAAAA")
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
    
//    func saveToFile() {
//        let fileManager = FileManager.default
//
//        // 获取Documents目录
//        let urlForDocument = fileManager.urls(for: .documentDirectory, in:.userDomainMask)
//        let urlDocument = urlForDocument[0] as URL
//
//        TKLogger.debug("Document:\(urlDocument)")
//
//        let myDocuments = urlDocument.appendingPathComponent("MyDocuments")
//        try! fileManager.createDirectory(atPath: myDocuments.path,
//                                         withIntermediateDirectories: true,
//                                         attributes: nil)
//
//
//        // 获取 Library/Caches 目录
//        let urlForCaches = fileManager.urls(for: .cachesDirectory, in:.userDomainMask)
//        let urlCache = urlForCaches[0] as URL
//
//        TKLogger.debug("Document:\(urlCache)")
//
//        let myCache = urlDocument.appendingPathComponent("MyCache")
//        try! fileManager.createDirectory(atPath: myCache.path,
//                                         withIntermediateDirectories: true,
//                                         attributes: nil)
//    }
    
}
