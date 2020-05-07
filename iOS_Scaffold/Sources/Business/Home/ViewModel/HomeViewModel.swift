//
//  HomeViewModel.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/25.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import Alamofire
import Moya

protocol HomeViewModelDelegate: class {
    
    func setTextViews(_ text: String)
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    init(_ delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func loadDate() {
//        testAlamofire()
//        testMoya()
        testMoya1()
    }
    
    fileprivate func testAlamofire() {
        let parameters = ["customType" : "voiceAccount"]
        Alamofire.request("https://mobile-service-pro.rokid.com/conf/device_custom_config", method:.get, parameters:parameters).responseJSON { (response) in
            switch response.result {
            case .success:
                TKLogger.debug("SUCCESS")
                self.delegate?.setTextViews(response.description)
            case .failure:
                TKLogger.warning("ERROR")
            }
        }
    }

    fileprivate func testMoya() {
        let parameters = ["customType" : "voiceAccount"]
        rokidProvider.request(.deviceCustomConfig(parameters)) { result in
            switch result {
            case .success(let response):
                TKLogger.debug("SUCCESS")
                let rokidResponse = try? response.map(RokidResponse<Array<DeviceConfigModel>>.self)
                let text = rokidResponse?.object[0].deviceTypeId
                self.delegate?.setTextViews(text ?? "")
            case .failure(let error):
                TKLogger.warning("ERROR")
                TKLogger.warning(error.errorDescription)
            }
        }
    }

    fileprivate func testMoya1() {
        rokidProvider.request(RokidResponse<AppConfigModel>.self, .appConfig("1.3.2")) { result in
            switch result {
            case let .success(response):
                TKLogger.debug("SUCCESS")
                let appConfigModel = response.object
                
                let json = appConfigModel.tk_toJSON()
                
//                let appConfigModel111 = json?.sp_fromJSON(AppConfigModel.self)

                self.delegate?.setTextViews(json ?? "")
            case let .failure(error):
                TKLogger.warning("ERROR")
                TKLogger.warning(error.errorDescription ?? "")
            }
        }
    }
    
}
