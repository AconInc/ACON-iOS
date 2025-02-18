//
//  SpotDetailTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

import Moya

enum SpotDetailTargetType {
    
    case getSpotDetail(spotID: Int64)
    case getSpotMenu(spotID: Int64)
    case postGuidedSpot(_ requestBody: PostGuidedSpotRequest)
    
}

extension SpotDetailTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postGuidedSpot:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getSpotDetail(let spotID):
            return utilPath + "spot/\(spotID)"
        case .getSpotMenu(let spotID):
            return utilPath + "spot/\(spotID)/menus"
        case .postGuidedSpot:
            return utilPath + "members/guided-spots"
        }
    }
    
    var task: Task {
        switch self {
        case .postGuidedSpot(let requestBody):
            return .requestJSONEncodable(requestBody)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var headers = HeaderType.noHeader
        switch self {
        case .getSpotDetail:
            headers = HeaderType.basicHeader
        case .getSpotMenu:
            headers = HeaderType.noHeader
        case .postGuidedSpot:
            headers = HeaderType.headerWithToken()
        }
        return headers
    }
    
}

