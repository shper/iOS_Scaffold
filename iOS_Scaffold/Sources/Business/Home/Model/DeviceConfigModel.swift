//
//  DeviceConfigModel.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/19.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation

struct DeviceConfigModel: Codable {
    var id: Int
    var customType: String
    var deviceTypeId: String
    var miniVersion: String
    var enabled: Bool
}
