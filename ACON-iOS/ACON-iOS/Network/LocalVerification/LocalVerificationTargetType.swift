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
    
}

extension LocalVerificationTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postLocalArea:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .postLocalArea:
            return utilPath + "member/area"
        }
    }
    
    var task: Task {
        switch self {
        case .postLocalArea(let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }
    
    var headers: [String : String]? {
        let headers = HeaderType.headerWithToken()
        return headers
    }
    
}
