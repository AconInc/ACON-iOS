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
        // TODO: - 추후 유저디폴트 토큰으로 변경
        let token = ""
        let headers = HeaderType.headerWithToken(token: "Bearer " + token)
        return headers
    }

}
