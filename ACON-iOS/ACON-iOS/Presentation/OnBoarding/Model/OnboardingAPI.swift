//
//  tp.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/20/25.
//

import Foundation
import Moya

enum OnboardingAPI {
    case postOnboarding(data: OnboardingDTO)
}

extension OnboardingAPI: TargetType {
    
    var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let url = URL(string: urlString) else {
            fatalError("💢 BASE_URL이 잘못되었습니다! 💢")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .postOnboarding:
            // TODO: i will chage
            return utilPath + "メンバー"
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
        //        let token = UserDefaults.standard.string(forKey: StringLiterals.Network.accessToken) ?? ""
        //        let headers = HeaderType.headerWithToken(token: "Bearer " + token)
        // TODO:  i will chage this to existHeader ㅇㅇ
        let headers = HeaderType.noHeader
        return headers
    }
}
