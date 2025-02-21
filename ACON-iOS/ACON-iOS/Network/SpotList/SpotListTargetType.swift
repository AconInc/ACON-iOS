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
    
    case getDong(_ query: GetDongRequestQuery)

}

extension SpotListTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postSpotList:
            return .post
        case .getDong:
            return .get
        }
    }

    var path: String {
        switch self {
        case .postSpotList:
            return utilPath + "spots"
        case .getDong:
            return utilPath + "area"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .getDong(let parameter):
            return ["latitude": parameter.latitude,
                    "longitude": parameter.longitude]
        default:
            return .none
        }
    }
    
    var task: Task {
        switch self {
        case .postSpotList(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .getDong:
            if let parameter = parameter {
                return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            } else {
                return .requestPlain
            }
        }
    }

    var headers: [String : String]? {
        switch self {
        case .postSpotList:
            return HeaderType.headerWithToken()
        case .getDong:
            return HeaderType.tokenOnly()
        }
    }

}
