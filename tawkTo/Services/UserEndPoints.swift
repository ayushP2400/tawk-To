//
//  UserEndPoints.swift
//  tawkTo
//
//  Created by love on 15/03/21.
//

import Foundation

enum UserEndPoints{
    
    case getUserList(parameters:[String:Any])
    case getUserDetails(parameters:String)
    
    var APIPath: String{
        switch self {
        case .getUserList(_):
            return "/users"
        case .getUserDetails(parameters: let parameters):
            return "/users/"+parameters
        }
    }
    
}
extension UserEndPoints:Service{
    
    var parameters: [String : Any]? {
        switch self {
        case .getUserList(parameters: let parameters):
            return parameters
        case .getUserDetails(_):
            return nil
        }
    }
    
    var method: ServiceMethod {
        switch self {
        case .getUserList(_):
            return .get
        case .getUserDetails(_):
            return .get
        }
    }
    
    var header: [String : String] {
        return [
            "Content-Type":"application/json",
        ]
    }
    
    var baseURL: String {
        return baseUrl
    }
    var path: String{
        return self.APIPath
    }

}
