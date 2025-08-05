//
//  SpotDetailTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

import Moya

enum SpotDetailTargetType {
    
    case getSpotDetail(spotID: Int64, isDeepLink: Bool)
    case getSpotMenu(spotID: Int64)
    case getMenuboardImageList(spotID: Int64)
    case postGuidedSpot(spotID: Int64)
    case postSavedSpot(spotID: Int64)
    case deleteSavedSpot(spotID: Int64)
    
}

extension SpotDetailTargetType: ACTargetType {

    var method: Moya.Method {
        switch self {
        case .postGuidedSpot, .postSavedSpot:
            return .post
        case .deleteSavedSpot:
            return .delete
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getSpotDetail(let spotID, _):
            return utilPath + "spots/\(spotID)"
        case .getSpotMenu(let spotID):
            return utilPath + "spots/\(spotID)/menus"
        case .getMenuboardImageList(let spotID):
            return utilPath + "spots/\(spotID)/menuboards"
        case .postGuidedSpot:
            return utilPath + "guided-spots"
        case .postSavedSpot:
            return utilPath + "saved-spots"
        case .deleteSavedSpot(let spotID):
            return utilPath + "saved-spots/\(spotID)"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .getSpotDetail(_, let isDeepLink):
            return ["isDeepLink": isDeepLink]
        default: return .none
        }
    }
    
    var task: Task {
        switch self {
        case .postGuidedSpot(let spotID), .postSavedSpot(let spotID):
            return .requestParameters(parameters: ["spotId": spotID], encoding: JSONEncoding.default)
        default:
            if let parameter = parameter {
                return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            } else {
                return .requestPlain
            }
        }
    }
    
    var headers: [String : String]? {
        var headers = HeaderType.noHeader
        switch self {
        case .getSpotMenu, .getMenuboardImageList:
            headers = HeaderType.noHeader
        case .postGuidedSpot, .postSavedSpot:
            headers = HeaderType.headerWithToken()
        case .getSpotDetail, .deleteSavedSpot:
            headers = HeaderType.tokenOnly()
        }
        return headers
    }
    
}

