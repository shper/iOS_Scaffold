//
//  WeatherModel.swift
//  iOS_Scaffold
//
//  Created by Shper on 2021/7/11.
//  Copyright © 2021 Shper. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    var shidu: String
    var pm25: Int
    var pm10: Int
    var quality: String
    var wendu: String
    var ganmao: String
    var forecast: [WeatherDetail]
    var yesterday: WeatherDetail
}

struct WeatherDetail: Codable {
    var date: String
    var high: String
    var low: String
    var ymd: String
    var week: String
    var sunrise: String
    var sunset: String
    var aqi: Int
    var fx: String
    var fl: String
    var type: String
    var notice: String
}
