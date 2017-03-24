//
//  dclj.swift
//  Tempest
//
//  Created by Developer on 23/03/2017.
//  Copyright © 2017 Julien. All rights reserved.
//

import Foundation
import Alamofire


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


class dclj : SessionManager {
    static let instance = dclj()
    
    private func setToken(_ token: String) {
        self.adapter = AccessTokenAdapter(accessToken: token)
    }
    public func auth(username: String, password: String, callback: @escaping (Bool)->()) {
        let param :Parameters = ["username":username, "password":password]
        
        self.req("/auth/", .post, param).responseJSON{ response in
            debugPrint(response)
            switch response.result {
                case .success:
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        api.setToken(json.value(forKey: "token") as! String)
                        callback(true)
                    }
                case .failure(let error):
                    debugPrint(error)
                    callback(false)
            }
        }
    }
    
    func req(_ endpoint: String, _ method: HTTPMethod = .get, _ parameters: Parameters? = nil) -> DataRequest {
        return super.request(Router(endpoint, method, parameters))
    }
}

let api = dclj.instance

class Router : URLRequestConvertible {
    
    let baseURLString = "http://swift.archloy.xyz"
    
    private var endpoint :String
    private var method :HTTPMethod
    private var parameters :Parameters?
    
    init(_ endpoint: String, _ method: HTTPMethod = .get, _ parameters: Parameters? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try self.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(self.endpoint))
        debugPrint(url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameters)
        return urlRequest
    }
}
