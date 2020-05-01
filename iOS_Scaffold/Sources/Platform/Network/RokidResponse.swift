//
//  RokidResponse.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/19.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation

struct RokidResponse<D>: Codable where D: Codable {
    var code: String
    var message: String
    var object: D
}
