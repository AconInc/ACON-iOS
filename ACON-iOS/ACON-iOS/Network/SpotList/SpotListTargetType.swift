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
    
    var parameter: [String : Any]?  {
        switch self {
        default:
            return .none
        }
    }
    
    var task: Task {
        switch self {
        case .postSpotList(let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .postSpotList:
            return HeaderType.headerWithToken()
        }
    }

}
