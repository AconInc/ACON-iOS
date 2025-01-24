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
    
    case getAddress(_ latitude: Double, _ longitude: Double)

}

extension SpotListTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postSpotList:
            return .post
        case .getAddress:
            return .get
        }
    }

    var path: String {
        switch self {
        case .postSpotList:
            return utilPath + "spots"
        case .getAddress:
            return utilPath + "area"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .getAddress(let latitude, let longitude):
            return ["latitude": latitude, "longitude": longitude]
        default:
            return .none
        }
    }

    var task: Task {
        switch self {
        case .postSpotList(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .getAddress(let latitude, let longitude):
            if let parameter = parameter {
                return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            } else {
                return .requestPlain
            }
        }
    }

    var headers: [String : String]? {
        let headers = HeaderType.headerWithToken()
        return headers
    }

}
