//
//  AuthTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/22/25.
//

import Foundation

import Moya

enum AuthTargetType {

    case postLogin(_ requestBody: PostLoginRequest)
    
    case postLogout(_ requestBody: PostLogoutRequest)
    
    case postReissue(_ requestBody: PostReissueRequest)
    
}

extension AuthTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postLogin, .postLogout, .postReissue:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .postLogin:
            return utilPath + "auth/login"
        case .postLogout(_):
            return utilPath + "auth/logout"
        case .postReissue:
            return utilPath + "auth/reissue"
        }
    }
    
    var task: Task {
        switch self {
        case .postLogin(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .postLogout(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .postReissue(let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }
    
    var headers: [String : String]? {
        var headers = HeaderType.basicHeader
        switch self {
        case .postLogin, .postReissue:
            headers = HeaderType.basicHeader
        case .postLogout:
            headers = HeaderType.headerWithToken()
        }
        return headers
    }
    
}
