//
//  WeatherResponse.swift
//  iOS_Scaffold
//
//  Created by Shper on 2021/7/11.
//  Copyright © 2021 Shper. All rights reserved.
//

import Foundation

struct WeatherResponse<D>: Codable where D: Codable {
    var message: String
    var status: Int
    var date: String
    var time: String
    var cityInfo: CityInfo
    var data: D
}

struct CityInfo: Codable {
    var city: String
    var citykey: String
    var parent: String
    var updateTime: String
}
