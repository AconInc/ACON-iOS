//
//  SpotListTargetType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/22/25.
//

import Foundation

import Moya

enum SpotListTargetType {

    case postSpotList(_ requestBody: PostSpotListRequest)

}

extension SpotListTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postSpotList:
            return .post
        }
    }

    var path: String {
        switch self {
        case .postSpotList:
            return utilPath + "spots"
        }
    }

    var task: Task {
        switch self {
        case .postSpotList(let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }

    var headers: [String : String]? {
        let token = UserDefaults.standard.string(forKey: StringLiterals.Network.accessToken) ?? ""
        let headers = HeaderType.headerWithToken(token: "Bearer " + token)
        return headers
    }

}
