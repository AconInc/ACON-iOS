//
//  OnboardingTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/16/25.
//

import Foundation

import Moya

enum OnboardingTargetType {
    
    case putOnboarding(_ requestBody: PutOnboardingRequest)
    
}

extension OnboardingTargetType: ACTargetType {

    var method: Moya.Method {
        switch self {
        case .putOnboarding:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .putOnboarding:
            return utilPath + "preference"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .putOnboarding:
            return .none
        }
    }
    
    var task: Task {
        switch self {
        case .putOnboarding(let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }
    
    var headers: [String : String]? {
        var headers = HeaderType.headerWithToken()
        switch self {
        case .putOnboarding:
            headers = HeaderType.headerWithToken()
        }
        return headers
    }
    
}
