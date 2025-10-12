//
//  PreferenceTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/16/25.
//

import Foundation

import Moya

enum PreferenceTargetType {
    
    case putPreference(_ requestBody: PutPreferenceRequest)
    
}

extension PreferenceTargetType: ACTargetType {

    var method: Moya.Method {
        switch self {
        case .putPreference:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .putPreference:
            return utilPath + "preference"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .putPreference:
            return .none
        }
    }
    
    var task: Task {
        switch self {
        case .putPreference(let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }
    
    var headers: [String : String]? {
        var headers = HeaderType.headerWithToken()
        switch self {
        case .putPreference:
            headers = HeaderType.headerWithToken()
        }
        return headers
    }
    
}
