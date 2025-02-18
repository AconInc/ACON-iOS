//
//  LocalVerificationTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

import Moya

enum LocalVerificationTargetType {
    
    case postLocalArea(_ requestBody: PostLocalAreaRequest)
    
    case getLocalAreaList
    
}

extension LocalVerificationTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postLocalArea:
            return .post
        case .getLocalAreaList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .postLocalArea:
            return utilPath + "members/verified-areas"
        case .getLocalAreaList:
            return utilPath + "members/verified-areas"
        }
    }
    
    var task: Task {
        switch self {
        case .postLocalArea(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .getLocalAreaList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let headers = HeaderType.headerWithToken()
        return headers
    }
    
}
