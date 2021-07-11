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
import TKLogger

protocol HomeViewModelDelegate: AnyObject {
    
    func setTextViews(_ text: String)
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    init(_ delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func loadDate() {
        fetchWeatherData()
    }

    fileprivate func fetchWeatherData() {
        weatherProvider.request(WeatherResponse<WeatherModel>.self, .weather(cityCode: "101210101")) { result in
            switch result {
            case let .success(response):
                TKLogger.debug("SUCCESS")
                
                let weatherData = response.data
                let dataJson = weatherData.tk_toJSON()
                
                self.delegate?.setTextViews(dataJson ?? "")
            case let .failure(error):
                TKLogger.warning(error.errorDescription ?? "")
            }
        }
    }
    
}
