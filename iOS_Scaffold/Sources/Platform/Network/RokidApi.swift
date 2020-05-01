//
//  RokidType.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/19.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import Moya

let rokidProvider = SPMoyaProvider<RokidApi>(plugins: [NetworkLoggerPlugin(verbose: true, requestDataFormatter: { (_ data: Data) -> (String) in
    return data.sp_toJSON()
})])

public enum RokidApi {
    case appConfig(_ configVersion: String)
    case deviceCustomConfig(_ parameters: [String: Any])
}

extension RokidApi: TargetType  {
    
    public var baseURL: URL {
        return URL(string: "https://mobile-service-pro.rokid.com")!
    }
    
    public var path: String {
        switch self {
        case .appConfig:
            return "/conf/app_config"
        case .deviceCustomConfig:
            return "/conf/device_custom_config"
        }
    }
    
    
    public var method: Moya.Method {
        switch self {
        case .appConfig:
            return .get
        case .deviceCustomConfig:
            return .get
        }
    }
    
    public var sampleData: Data {
        return "just for test。".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .appConfig(let configVersion):
            return .requestParameters(parameters: ["configVersion": configVersion], encoding: URLEncoding.default)
        case .deviceCustomConfig(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
}
