//
//  dclj.swift
//  Tempest
//
//  Created by Developer on 23/03/2017.
//  Copyright © 2017 Julien. All rights reserved.
//

import Foundation
import Alamofire

class dclj : SessionManager {
       
    public func setToken(_ token: String) {
        self.adapter = AccessTokenAdapter(accessToken: token)
    }
}

class Router : URLRequestConvertible {
    
    let baseURLString = "http://swift.archloy.xyz"
    
    private var endpoint :String = "auth"
    private var method :HTTPMethod
    private var parameters :Parameters?
    
    init(endpoint: String, method: HTTPMethod = .get, parameters: Parameters? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try self.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(self.endpoint))
        
        urlRequest.httpMethod = self.method.rawValue
        
        urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameters)
        
        return urlRequest
    }
}

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if (urlRequest.url?.absoluteString) != nil {
            urlRequest.setValue("Token " + accessToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
