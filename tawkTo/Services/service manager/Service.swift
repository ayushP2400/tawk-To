//
//  Service.swift
//  iFollow
//
//  Created by Ayush Pathak on 01/03/21.
//

import Foundation

enum ServiceMethod: String {
    case get = "GET"
    case post = "POST"
    // implement more when needed: post, put, delete, patch, etc.
}


protocol Service {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var method: ServiceMethod { get }
    var header: [String:String] { get }    
}

extension Service {
    public var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        for item in header{
            request.addValue(item.value, forHTTPHeaderField: item.key)
        }
        
        if method == .post{
           
                guard let parameter = parameters else {
                    fatalError("parameters for Post http method must conform to [String: String]")
                }
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else {
                    return request
                }
                request.httpBody = httpBody
            
            
        }
        
        return request
    }
    
    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        if method == .get {
            // add query items to url
            guard let parameters = parameters as? [String: String] else {
                return urlComponents?.url
            }
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return urlComponents?.url
    }
}
