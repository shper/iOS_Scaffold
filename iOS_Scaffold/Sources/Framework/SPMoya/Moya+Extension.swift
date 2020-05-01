//
//  Moya+Extension.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/20.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import Moya

extension Moya.Response {

    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }

}
