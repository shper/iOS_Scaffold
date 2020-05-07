//
//  JSON+Exteension.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/26.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation

// MARK: - Encodable

extension Data {
    
    func tk_toJSON() -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: self)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .fragmentsAllowed)
            return String(data: prettyData, encoding: .utf8) ?? String(data: self, encoding: .utf8) ?? ""
        } catch {
            return String(data: self, encoding: .utf8) ?? ""
        }
    }
    
}

extension Encodable {

    func tk_toJSON() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

}

// MARK: - Decodable

extension Data {
    
    func tk_fromJSON<T: Decodable>(_ type: T.Type) -> T? {
        return try? JSONDecoder().decode(type, from: self)
    }
    
}

extension String {

    func tk_fromJSON<T: Decodable>(_ type: T.Type) ->  T? {
        return self.data(using: .utf8)?.tk_fromJSON(type)
    }

}

