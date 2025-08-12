//
//  ProfileTargetType.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/15/25.
//

import Foundation

import Moya

enum ProfileTargetType {
    
    case getProfile
    
    case getSavedSpots
    
    case getNicknameValidity(_ parameter: GetNicknameValidityRequest)
    
    case patchProfile(_ requestBody: PatchProfileRequest)

}

extension ProfileTargetType: ACTargetType {

    var method: Moya.Method {
        switch self {
        case .getProfile, .getSavedSpots:
            return .get
        case .getNicknameValidity:
            return .get
        case .patchProfile:
            return .patch
        }
    }

    var path: String {
        switch self {
        case .getProfile:
            return utilPath + "members/me"
        case .getSavedSpots:
            return utilPath + "saved-spots"
        case .getNicknameValidity:
            return utilPath + "nickname/validate"
        case .patchProfile(_):
            return utilPath + "members/me"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .getNicknameValidity(let parameter):
            return ["nickname": parameter.nickname]
        default:
            return .none
        }
    }

    var task: Task {
        switch self {
        case .getNicknameValidity:
            if let parameter = parameter {
                return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            } else {
                return .requestPlain
            }
        case .patchProfile(let requestBody):
            return .requestJSONEncodable(requestBody)
        default:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .getProfile, .getSavedSpots:
            return HeaderType.tokenOnly()
        case .getNicknameValidity:
            return HeaderType.tokenOnly()
        case .patchProfile:
            return HeaderType.headerWithToken()
        }
    }

}
