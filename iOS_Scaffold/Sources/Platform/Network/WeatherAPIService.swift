//
//  WeatherAPI.swift
//  iOS_Scaffold
//
//  Created by Shper on 2021/7/11.
//  Copyright © 2021 Shper. All rights reserved.
//

import Foundation
import Moya

//let weatherProvider1 = TKMoyaProvider<WeatherAPIService>(plugins: [NetworkLoggerPlugin(requestDataFormatter: { (_ data: Data) -> (String) in
//    return data.tk_toJSON()
//})])

let weatherProvider = TKMoyaProvider<WeatherAPIService>()

public enum WeatherAPIService {
    case weather(cityCode: String)
}

extension WeatherAPIService: TargetType  {
    
    public var baseURL: URL {
        return URL(string: "http://t.weather.itboy.net")!
    }
    
    public var path: String {
        switch self {
        case .weather(let cityCode):
            return "/api/weather/city/\(cityCode)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .weather:
            return .get
        }
    }
    
    public var sampleData: Data {
        return "just for test。".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .weather:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
}
