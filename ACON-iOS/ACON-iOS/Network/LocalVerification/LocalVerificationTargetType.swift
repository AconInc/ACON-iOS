//
//  LocalVerificationTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

import Moya

enum LocalVerificationTargetType {
    
    case postLocalArea(_ requestBody: PostLocalAreaRequest)
    
    case getLocalAreaList
    
    case deleteLocalArea(_ verifiedAreaID: String)
    
    case postReplaceLocalArea(_ requestBody: PostReplaceVerifiedAreaRequest)
    
}

extension LocalVerificationTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postLocalArea, .postReplaceLocalArea:
            return .post
        case .getLocalAreaList:
            return .get
        case .deleteLocalArea:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .postLocalArea:
            return utilPath + "verified-areas"
        case .getLocalAreaList:
            return utilPath + "verified-areas"
        case .deleteLocalArea(let verifiedAreaID):
            return utilPath + "verified-areas/" + verifiedAreaID
        case .postReplaceLocalArea:
            return utilPath + "verified-areas/replacement"
        }
    }
    
    var task: Task {
        switch self {
        case .postLocalArea(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .getLocalAreaList:
            return .requestPlain
        case .deleteLocalArea:
            return .requestPlain
        case .postReplaceLocalArea(let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .deleteLocalArea :
            return HeaderType.tokenOnly()
        default:
            return HeaderType.headerWithToken()
        }
    }
    
}
