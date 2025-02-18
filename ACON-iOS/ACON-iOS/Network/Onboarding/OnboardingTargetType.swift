//
//  tp.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/20/25.
//

import Foundation
import Moya

enum OnboardingTargetType {
    
    case postOnboarding(requestBody: OnboardingRequest)
    
}


extension OnboardingTargetType: TargetType {
    
    var path: String {
        switch self {
        case .postOnboarding:
            return utilPath + "members/preference"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postOnboarding:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .postOnboarding(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String: String]? {
        let headers = HeaderType.headerWithToken()
        return headers
    }
}
