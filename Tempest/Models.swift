//
//  Models.swift
//  Tempest
//
//  Created by Developer on 24/03/2017.
//  Copyright © 2017 Julien. All rights reserved.
//

import Foundation
import Alamofire

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}

protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: Any)
}

extension DataRequest {
    func responseObject<T: ResponseObjectSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
                return .failure(BackendError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
            }
            
            return .success(responseObject)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

struct User: ResponseObjectSerializable, CustomStringConvertible {
    let id: Int
    let username: String
    let name: String
    
    var description: String {
        return "User: { username: \(username), name: \(name) }"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let username = response.url?.lastPathComponent,
            let representation = representation as? [String: Any],
            let name = representation["name"] as? String,
            let id = representation["id"] as? Int
            else { return nil }
        
        self.id = id
        self.username = username
        self.name = name
    }
    
    public func getReports(lat: String, lon: String)
    {
        let param :Parameters = ["lat":lat, "lon":lon]
        api.req("/reports/", .get, param).responseJSON{ response in
            switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
            }
        }
    }
}



