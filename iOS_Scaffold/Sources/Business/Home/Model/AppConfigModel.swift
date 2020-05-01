//
//  AppConfigModel.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/19.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation

struct AppConfigModel: Codable {
    var binderConfig: BinderConfig
}

struct BinderConfig: Codable {
    var id: Int
    var configVersion: String
    var deviceTypeIds: [String]
    var title: String
    var linkUrl: String
    var iconUrl: String?
    var tips: [String]
    var requestUrl: String
    var requestDomain: String
    var requestIntent: String
    var requestVersion: String
    var enabled: Bool
}
