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
            return utilPath + "member/preference"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postOnboarding:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postOnboarding(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String: String]? {
        let token = UserDefaults.standard.string(forKey: StringLiterals.Network.accessToken) ?? ""
        let headers = HeaderType.headerWithToken(token: "Bearer " + token)
        return headers
    }
}
