//
//  SPMoyaProvider.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/20.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import Moya

let SUCCESS_STATUS_CODE = 200

class SPMoyaProvider<Target: TargetType>: MoyaProvider<Target> {
    
    @discardableResult
    func request<D: Codable>(_ type: D.Type,
                             _ target: Target,
                             callbackQueue: DispatchQueue? = .none,
                             progress: ProgressBlock? = .none,
                             completion: @escaping (_ result: Result<D, SPError>) -> Void) -> Cancellable {
        
        return super.request(target, callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case .success(let result):
                SPLogger.debug("Success")
                
                if(result.statusCode == SUCCESS_STATUS_CODE) {
                    guard let data = try? result.map(D.self) else {
                        // TODO
                        completion(.failure(.network("", "")))
                        return
                    }
                    
                    // TODO
                    completion(.success(data))
                    return
                }
                
                // TODO
                completion(.failure(.network("", "")))
            case .failure(let error):
                SPLogger.warning("Failure")

                // TODO
                completion(.failure(.network("", error.errorDescription)))
            }
        }
    }
    
}
